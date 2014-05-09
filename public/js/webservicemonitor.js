// var es = new EventSource('/stream');
// es.onmessage = function(e) {
//   var d = JSON.parse(e.data);
//   $("#no"+d["no"]).removeClass();
//   if (d["code"]=="200") {
//     $("#no"+d["no"]).addClass("default");
//   } else {
//     $("#no"+d["no"]).addClass("warning");
//   }
//   $("#time"+d["no"]).text(d["time"]);
//   $("#code"+d["no"]).text(d["code"]);
// };
