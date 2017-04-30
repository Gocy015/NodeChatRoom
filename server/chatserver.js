var ws = require('nodejs-websocket')
var url = require('url')
var myutil = require('./util.js')

var http = require('http')

//WEBSOCKET
var wsServer = ws.createServer(function _onConnect(conn) {
    // console.log("New connection ", conn);
    console.log("connection established.")

    var parsedPath = url.parse(conn.path, true);
    var name = parsedPath.query["username"];
    myutil.addUser(name);
    // conn.close()
    conn.on('text', function _getNewChatMessage(msg) {
        console.log('New message : ' + msg);
        wsServer.broadcast(msg);
    });
    conn.on('close', function _connectClosed(code, reason) {
        console.log('connection closed.');
        // conn.end()
        myutil.removeUser(name)
    });
    conn.on('error', function (err) {
        myutil.removeUser(name)
        if (err.code !== 'ECONNRESET') {
            // Ignore ECONNRESET and re throw anything else
            throw err
        }

    })

}).listen(8081);

wsServer.broadcast = function _broadcast(data) {
    wsServer.connections.forEach(function _forEachConnection(conn) {
        if (conn.OPEN) {
            conn.send(data);
        }
    });
}

// HTTP
http.createServer(function (request, response) {
    console.log(request);
    var parsedUrl = url.parse(request.url, true);
    console.log(parsedUrl);

    var name = parsedUrl.query["name"];
    if (myutil.nameExists(name)) {
        console.log("Duplicate name " + name)
        response.writeHead(403, "Duplicated username")
        response.end();
        return
    }

    response.writeHead(200, "Success");
    response.end();
}).listen(8080);


console.log('Good to go.');