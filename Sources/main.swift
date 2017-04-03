import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Create HTTP server.
let server = HTTPServer()

// Create the container variable for routes to be added to.
var routes = Routes()

// Register your own routes and handlers
// This is an example "Hello, world!" HTML route
routes.add(method: .get, uri: "/", handler: {
	request, response in
	// Setting the response content type explicitly to text/html
	response.setHeader(.contentType, value: "text/html")
	// Adding some HTML to the response body object
	response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
	// Signalling that the request is completed
	response.completed()
	}
)

/*
----------------------------------------------------------------------------------
                     				Messages
----------------------------------------------------------------------------------
*/

// POST FOR GETTING USER MESSAGES
routes.add(method: .post, uri: "/api/v1/message/mymessages", handler: {
	request, response in

	let message = Messages()

	// Setting the response content type explicitly to application/json
  message.fetchMyMessages(request)
	response.setHeader(.contentType, value: "application/json")
	// Setting the body response to the JSON list generated

  response.appendBody(string: message.list())

	response.completed()
	}
)

// POST User METHOD
routes.add(method: .post, uri: "/api/v1/message/", handler: {
	request, response in

	let message = Messages()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")

	response.appendBody(string: message.addMessage(request))
	// Signalling that the request is completed
	response.completed()
	}
)

// Add the routes to the server.
server.addRoutes(routes)

// Set a listen port of 8181
server.serverPort = 8181

do {
	// Launch the HTTP server.
	try server.start()
} catch PerfectError.networkError(let err, let msg) {
	print("Network error thrown: \(err) \(msg)")
}
