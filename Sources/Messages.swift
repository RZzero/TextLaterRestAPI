import PerfectHTTP
import MySQL

public class Messages {
  //Database credentials
    let testHost = "localhost"
    let testUser = ""
    let testPassword = ""
    let testDB = "TextLater"
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
	public func addMessage(_ request: HTTPRequest) -> String {
		let new = Message(
      idMessage: request.param(name: "idMessage")!,
      sender: request.param(name: "sender")!,
      platform: request.param(name: "platform")!,
      subject: request.param(name: "subject")!,
      content: request.param(name: "content")!,
      timeToSend: request.param(name: "timeToSend")!,
      messageStatus: request.param(name: "messageStatus")!
		)
		do{
					_ = mysql.connect()
		let query = "INSERT INTO Message (sender,platform,subject,content,timetosend,messagestatus)
     VALUES('\(new.sender)','\(new.platform)','\(new.subject)','\(new.content)','\(new.timeToSend)','\(new.messageStatus)')"

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

  func fetchMyMessages(_ request: HTTPRequest) {
    _ = mysql.connect()

    let mySender = request.param(name: "sender")!

    let query = "SELECT idMessage, sender, platform, subject, content, timeToSend,
     messageStatus FROM Message WHERE sender = '\(mySender)' ORDER BY idMessage"
    _ = mysql.query(statement: query)
    print(query)
    let results = mysql.storeResults()

    results?.forEachRow(callback: { (row) in

        let idMessage = row[0] ?? ""
        let sender = row[1] ?? ""
        let platform = row[2] ?? ""
        let subject = row[3] ?? ""
        let content = row[4] ?? ""
        let timeToSend = row[5] ?? ""
        let messageStatus = row[6] ?? ""

        let message = Message(idMessage: idMessage, sender: sender, platform: platform,
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
