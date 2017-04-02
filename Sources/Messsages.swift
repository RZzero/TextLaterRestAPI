import PerfectHTTP
import MySQL

public class Users {
  //Database credentials
    let testHost = ""
    let testUser = ""
    let testPassword = ""
    let testDB = ""
    var mysql: MySQL!

	var data = [Message]()

  public func fetchRafa(){
    let rafael = User(firstName: "Leafar",secondName: "Zero", lastName: "Coolio")
    data.append(rafael)
  }


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

	// Accepts the HTTPRequest object and adds a new User from post params.
	public func addUser(_ request: HTTPRequest) -> String {
		let new = Message(
      idMessage: request.param(name: "idMessage")!,
      sender: request.param(name: "sender")!,
      platform: request.param(name: "platform")!,
      subject: request.param(name: "subject")!,
      content: request.param(name: "content")!,
      timeToSend: request.param(name: "timeToSend")!,
      messageStatus: request.param(name: "messageStatus")!
		)
		// do{
		// 			_ = mysql.connect()
		// let query = "INSERT INTO USER (name,secondName, lastName) VALUES('\(new.firstName)','\(new.secondName)','\(new.lastName)')"
    //
		//  _ = mysql.query(statement: query)
		// print(query)
    //
		// }
		// defer {
    //       mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
    //     }
    //
    //     _ = mysql.connect()
		data.append(new)
    return toString()
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
