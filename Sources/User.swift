import PerfectLib

class User : JSONConvertibleObject {

	static let registerName = "user"

	var idUser: String = ""
	var firstName: String = ""
  var secondName: String = ""
	var lastName: String = ""

	var fullName: String {
    if lastName == ""{
        return "\(firstName) \(lastName)"
    }else{
        return "\(firstName) \(secondName) \(lastName)"
    }

	}

	init(firstName: String,secondName: String, lastName: String) {
		self.idUser		= ""
		self.firstName	= firstName
    self.secondName = secondName
		self.lastName	= lastName

	}

	override public func setJSONValues(_ values: [String : Any]) {
		self.idUser			= getJSONValue(named: "idUser", from: values, defaultValue: "")
		self.firstName		= getJSONValue(named: "firstName", from: values, defaultValue: "")
    self.secondName		= getJSONValue(named: "secondName", from: values, defaultValue: "")
		self.lastName		= getJSONValue(named: "lastName", from: values, defaultValue: "")

	}
	override public func getJSONValues() -> [String : Any] {
		return [
			"idUser":idUser,
			"firstName":firstName,
      "secondName":secondName,
			"lastName":lastName
		]
	}

}
