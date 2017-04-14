import PerfectLib

class Attachment : JSONConvertibleObject {

	static let registerName = "Attachment"

	var idAttached: String = ""
	var idMessage: String = ""
	var fileName: String = ""

	init(idAttached: String, idMessage: String, fileName: String) {
		self.idAttached = idAttached
		self.idMessage = idMessage
		self.fileName = fileName
	}

	override public func setJSONValues(_ values: [String : Any]) {
		self.idAttached = getJSONValue(named: "idAttached", from: values, defaultValue: "")
		self.idMessage = getJSONValue(named: "idMessage", from: values, defaultValue: "")
		self.fileName = getJSONValue(named: "fileName", from: values, defaultValue: "")
	}

	override public func getJSONValues() -> [String : Any] {
		return [
			"idAttached":idAttached,
			"idMessage":idMessage,
			"fileName":fileName
		]
	}

}
