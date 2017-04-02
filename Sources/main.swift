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
                     				USERS
----------------------------------------------------------------------------------
*/

// GET USER METHOD
routes.add(method: .get, uri: "/api/v1/users", handler: {
	request, response in

	let user = Users()
	//user.fetchUserFirstTime()
	// Setting the response content type explicitly to application/json
  user.fetchRafa()
	response.setHeader(.contentType, value: "application/json")
	// Setting the body response to the JSON list generated

  response.appendBody(string: user.list())

	response.completed()
	}
)

// POST User METHOD
routes.add(method: .post, uri: "/api/v1/users", handler: {
	request, response in

	//let people = People()
	let user = Users()

	// Setting the response content type explicitly to application/json
	response.setHeader(.contentType, value: "application/json")

	// // Adding a new "person", passing the complete HTTPRequest object to the function.
	response.appendBody(string: user.addUser(request))
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
