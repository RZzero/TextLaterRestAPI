import PerfectLib

class User : JSONConvertibleObject {

	static let registerName = "message"

	var idMessage: String = ""
	var sender: String = ""
  var platform: String = ""
	var subject: String = ""
	var content: String = ""
	var timeToSend: String = ""
	var messageStatus: String = ""

	init(idMessage: String,sender: String, platform: String, subject: String, content: String, timeToSend: String,messageStatus:String) {
		self.idMessage = idMessage
		self.sender = sender
	  self.platform = platform
		self.subject = subject
		self.content = content
		self.timeToSend = timeToSend
		self.messageStatus = messageStatus

	}

	override public func setJSONValues(_ values: [String : Any]) {
		self.idMessage = getJSONValue(named: "idMessage", from: values, defaultValue: "")
		self.sender = getJSONValue(named: "sender", from: values, defaultValue: "")
		self.platform = getJSONValue(named: "platform", from: values, defaultValue: "")
		self.subject = getJSONValue(named: "subject", from: values, defaultValue: "")
		self.content = getJSONValue(named: "content", from: values, defaultValue: "")
		self.timeToSend = getJSONValue(named: "timeToSend", from: values, defaultValue: "")
		self.messageStatus = getJSONValue(named: "messageStatus", from: values, defaultValue: "")


	}
	override public func getJSONValues() -> [String : Any] {
		return [
			"idMessage":idMessage
			"sender":sender
			"platform":platform
			"subject":subject
			"content":content
			"timeToSend":timeToSend
			"messageStatus":messageStatus
		]
	}

}
