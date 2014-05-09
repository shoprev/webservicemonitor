# coding: utf-8
require "sinatra"
require "sinatra/config_file"
require 'mail'
require "net/http"
require 'rufus/scheduler'
if development?
  require 'sinatra/reloader' 
  set :bind, '0.0.0.0'
end

set server: 'thin', connections: []
set scheduler: Rufus::Scheduler

config_file 'config.yml'
settings.scheduler = Rufus::Scheduler.new

opt = { address:   settings.mail["address"],
        port:      settings.mail["port"],
        domain:    settings.mail["domain"],
        user_name: settings.mail["user_name"],
        password:  settings.mail["password"]}
Mail.defaults do
  delivery_method :smtp, opt
end

def deliver_mail(h)
  Mail.deliver do
    from    Sinatra::Application.settings.mail["from"]
    to      Sinatra::Application.settings.mail["to"]
    subject "web service failure"
    body    "%s\n%s\n%s" % [h["url"],h["code"],h["time"]]
  end
end

def response_code(url)
  Net::HTTP.get_response(URI.parse(url)).code
end

settings.scheduler.every settings.term do
  settings.urls.each.with_index(1) do |v,i|
    code = response_code(v)
    time = Time.now	
    deliver_mail({"url"=>v,"code"=>code,"time"=>time}) unless code == "200"
    settings.connections.each do |out|
      out << "data: {\"no\":\"#{i}\",\"url\":\"#{v}\",\"code\":\"#{code}\",\"time\":\"#{time}\"}\n\n" 
    end
  end
end

get '/stream', provides: 'text/event-stream' do
  response.headers['X-Accel-Buffering'] = 'no' # Disable buffering for nginx
  stream :keep_open do |out|
    settings.connections << out
    out.callback { settings.connections.delete(out) }
  end
end

get '/' do
  logger.error "---------- / ----------"
  html=""
  settings.urls.each.with_index(1) do |v,i|
    code = response_code(v)
    time = Time.now	
    deliver_mail({"url"=>v,"code"=>code,"time"=>time}) unless code == "200"
    logger.error "---------- #{code} ----------"
    html<< "<tr id=\"no#{i}\" class=\"#{code == "200" ? "default" : "warning"}\">
    <td>#{i}</td><td><a href=\"#{v}\" target=\"_blank\">#{v.sub(/http(s):\/\//,"")}</a></td>
    <td id=\"code#{i}\">#{code}</td><td id=\"time#{i}\">#{time}</td></tr>"
  end
  erb :index, locals: { html: html }
end
