import PerfectHTTP
import MySQL

public class Messages {
  //Database credentials
    let testHost = ""
    let testUser = ""
    let testPassword = ""
    let testDB = ""
    var mysql: MySQL!

	var data = [Message]()

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
	public func addMessage(_ request: HTTPRequest) -> String {
		let new = Message(
      idMessage: "",
      platform: request.param(name: "platform")!,
      sender: request.param(name: "sender")!,
      ToM: request.param(name: "ToM")!,
      subject: request.param(name: "subject")!,
      content: request.param(name: "content")!,
      timeToSend: request.param(name: "timeToSend")!,
      messageStatus: request.param(name: "messageStatus")!
		)
		do{
					_ = mysql.connect()
		let query = "INSERT INTO Message (platform, sender, ToM,subject, content, timeToSend, messageStatus) VALUES ('\(new.platform)', '\(new.sender)','\(new.ToM)', '\(new.subject)', '\(new.content)', '\(new.timeToSend)', '\(new.messageStatus)')"

		 _ = mysql.query(statement: query)
		print(query)

		}
		defer {
          mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
        }

        _ = mysql.connect()
		data.append(new)

    return toString()
	}

  public func fetchMyMessages(_ request: HTTPRequest) {
    print (request)
    let mySender = request.param(name: "sender")!
    print (mySender)
    _ = mysql.connect()



    let query: String = "SELECT idMessage, platform, sender, ToM, subject, content, timeToSend, messageStatus FROM Message WHERE sender= '\(mySender)' AND messageStatus = '\("NS")'ORDER BY timeToSend"

    _ = mysql.query(statement: query)
    print(query)
    let results = mysql.storeResults()

    results?.forEachRow(callback: { (row) in

        let idMessage = row[0] ?? ""
        let platform = row[1] ?? ""
        let sender = row[2] ?? ""
        let ToM = row[3] ?? ""
        let subject = row[4] ?? ""
        let content = row[5] ?? ""
        let timeToSend = row[6] ?? ""
        let messageStatus = row[7] ?? ""

        let message = Message(idMessage: idMessage, platform: platform, sender: sender, ToM: ToM,
        subject: subject, content: content,timeToSend: timeToSend, messageStatus:messageStatus)
        data.append(message)
    })

    defer {
      mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
    }
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
