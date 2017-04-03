import PerfectLib

class Message : JSONConvertibleObject {

	static let registerName = "Message"

	var idMessage: String = ""
	var platform: String = ""
	var sender: String = ""
	var ToM: String = ""
	var subject: String = ""
	var content: String = ""
	var timeToSend: String = ""
	var messageStatus: String = ""

	init(idMessage: String,platform: String, sender: String, ToM: String, subject: String, content: String, timeToSend: String,messageStatus:String) {
		self.idMessage = idMessage
		self.platform = platform
		self.sender = sender
		self.ToM = ToM
		self.subject = subject
		self.content = content
		self.timeToSend = timeToSend
		self.messageStatus = messageStatus

	}

	override public func setJSONValues(_ values: [String : Any]) {
		self.idMessage = getJSONValue(named: "idMessage", from: values, defaultValue: "")
		self.platform = getJSONValue(named: "platform", from: values, defaultValue: "")
		self.sender = getJSONValue(named: "sender", from: values, defaultValue: "")
		self.ToM = getJSONValue(named: "ToM", from: values, defaultValue: "")
		self.subject = getJSONValue(named: "subject", from: values, defaultValue: "")
		self.content = getJSONValue(named: "content", from: values, defaultValue: "")
		self.timeToSend = getJSONValue(named: "timeToSend", from: values, defaultValue: "")
		self.messageStatus = getJSONValue(named: "messageStatus", from: values, defaultValue: "")


	}
	override public func getJSONValues() -> [String : Any] {
		return [
			"idMessage":idMessage,
			"platform":platform,
			"sender":sender,
			"ToM": ToM,
			"subject":subject,
			"content":content,
			"timeToSend":timeToSend,
			"messageStatus":messageStatus
		]
	}

}
