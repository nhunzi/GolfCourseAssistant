import Foundation

class LoginModel: NSObject {
    
    //properties
	var Email : String?
	var Id: Int?
	var Name: String?
	var Password: String?
	var Skill: String?
	
	
    
    //empty constructor
    
    override init()
    {
        
    }
    
    //construct with @name, @address, @latitude, and @longitude parameters
    
    init(Email: String, Id: Int, Name: String, Password: String, Skill: String) {
        
		self.Email = Email
		self.Id = Id
		self.Name = Name
		self.Password = Password
		self.Skill = Skill
    }
    
    
    //prints object's current state
    
    override var description: String {
        return "Email: \(Email), Id: \(Id), Name: \(Name), Password: \(Password), Skill: \(Skill)"
        
    }
    
    
}