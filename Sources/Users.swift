import PerfectHTTP
import MySQL

public class Users {
  //Database credentials
    let testHost = ""
    let testUser = ""
    let testPassword = ""
    let testDB = ""
    var mysql: MySQL!


	// Container for array of type User
	var data = [User]()
	var that = ""

	init(){
        mysql = MySQL() // Create an instance of MySQL to work with

        let connected = mysql.connect(host: testHost, user: testUser, password: testPassword, db: testDB)

        guard connected else {
            // verify we connected successfully
            print(mysql.errorMessage())
            return
        }
	}

	// A simple JSON encoding function for listing data members.
	// Ordinarily in an API list directive, cursor commands would be included.
	public func list() -> String {
		return toString()
	}
	public func giveMeOneUserID() -> String{
		return that
	}
  
	// Accepts the HTTPRequest object and adds a new User from post params.
	public func addUser(_ request: HTTPRequest) -> String {
		let new = User(
			firstName: request.param(name: "firstName")!,
      secondName: request.param(name: "secondName")!,
			lastName: request.param(name: "lastName")!
		)
		do{
					_ = mysql.connect()
		let query = "INSERT INTO USER (name,secondName, lastName) VALUES('\(new.firstName)','\(new.secondName)','\(new.lastName)')"

		 _ = mysql.query(statement: query)
		print(query)

		}
		defer {
          mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
        }

        _ = mysql.connect()

        let query = "SELECT iduser FROM USER WHERE name= '\(new.firstName)' AND lastname = '\(new.lastName)' ORDER BY iduser DESC LIMIT 1"
        _ = mysql.query(statement: query)
        print(query)
        let results = mysql.storeResults()
        results?.forEachRow(callback: {(row) in
            that = row[0] ?? ""})

		data.append(new)
		return that
	}

	// Convenient encoding method that returns a string from JSON objects.
	private func toString() -> String {
		var out = [String]()

		for m in self.data {
			do {
				out.append(try m.jsonEncodedString())
			} catch {
				print(error)
			}
		}
		return "[\(out.joined(separator: ","))]"
	}

}
