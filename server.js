// node server.js

const ws = require("ws");

var p = 5566;
var server = new ws.Server({ port: p });

server.on("connection", function(ws) {
  console.log("connected to: " + p);

  ws.on("message", function(data, flags) {

    // read data byte

    console.log("got data byte: " + data[0]);

    var cmd = data[0] == "m" ? "--mend" : "--advise";
    var result = "";
    var spawn = require("child_process").spawn;
    var scry = spawn("lua", ["scry.lua", cmd]);
    scry.stdout.on("data", function(data) {
      result += data.toString();
    });
    scry.stdout.on("end", function() {
      console.log("result=", result);
      ws.send(result);
    });

    scry.stdin.write(data.substring(1));
    scry.stdin.end();
  });

  ws.on("close", function() {
    console.log("close");
  });
});
