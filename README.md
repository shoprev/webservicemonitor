# webservicemonitor

Ruby Sinatra Simple Web Service Health Monitor
See the [Demo](http://webservicemonitor.herokuapp.com/).

## Setup

    $ git clone git://github.com/shoprev/webservicemonitor.git
    $ cd webservicemonitor

Modify the config.yml file.

    #
    # failure mail delivery config
    #
    mail:
      address: smtp.gmail.com
      port: 587
      user_name: foo@gmail.com
      domain: gmail.com
      password: bar
      from: foo@gmail.com
      to: baz@gmail.com

    #
    # failure monitoring term
    #
    # 1h => 1 hours
    # 1d => 1 days
    # 1s => 1 seconds
    # 1m => 1 minutes
    term: 1h

    #
    # failure monitoring urls
    #
    urls:
      - https://www.heroku.com
      - https://www.google.com
      - https://www.yahoo.com
      - https://twitter.com
      - https://www.facebook.com

And then execute:

    $ bundle
    $ ruby app.rb -s thin

## Deploy

Deploy webservicemonitor like any other Rack app. Heroku example:

    $ git init
    $ git add .
    $ git commit -m "1st"
    $ heroku create
    $ git push heroku master
    $ heroku open

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
