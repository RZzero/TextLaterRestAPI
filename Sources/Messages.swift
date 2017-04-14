import PerfectHTTP
import MySQL
import PerfectLib
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

//THIS FUNCTION ASSUMES THAT THE ATTACHED FILES BELONGS TO THE LAST MESSAGE INSERTED
  public func saveFiles(_ request: HTTPRequest)-> String{
    var id_message = ""
    do{
      _ = mysql.connect()
      var query = "SELECT idMessage FROM Message ORDER BY idMessage ASC LIMIT 1"
      _ = mysql.query(statement: query)

    }
    var results = mysql.storeResults()
results?.forEachRow(callback: {(row) in
    id_message = row[0] ?? ""})
    defer {
          mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
        }

    if let uploads = request.postFileUploads, uploads.count > 0 {
    // Create an array of dictionaries which will show what was uploaded
    var ary = [[String:Any]]()
    let fileDir = Dir("~/Desktop/RESTApi/files")
      do {
        try fileDir.create()
      } catch {
        print(error)
      }
    for upload in uploads {
        ary.append([
            "fieldName": upload.fieldName,
            "contentType": upload.contentType,
            "fileName": upload.fileName,
            "fileSize": upload.fileSize,
            "tmpFileName": upload.tmpFileName
            ])
            let thisFile = File(upload.tmpFileName)
            do {
                let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
            } catch {
                print(error)
            }
    }

    }

    return id_message
  }
  public func modifyMessage(_ request: HTTPRequest) -> String {
    let new = Message(
      idMessage: request.param(name: "idMessage")!,
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
    let query = "UPDATE Message SET platform = '\(new.platform)',ToM = '\(new.ToM)' , subject = '\(new.subject)' , content = '\(new.content)', timeToSend = '\(new.timeToSend)' WHERE idMessage = '\(new.idMessage)'"

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



    let query: String = "SELECT idMessage, platform, sender, ToM, subject, content, timeToSend, messageStatus FROM Message WHERE sender= '\(mySender)' ORDER BY idMessage, timeToSend"

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
