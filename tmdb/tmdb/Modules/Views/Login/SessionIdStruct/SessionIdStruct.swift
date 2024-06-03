import Foundation

struct SessionIdStruct : Codable {
    
	let success : Bool
	let session_id : String

	enum CodingKeys: String, CodingKey {
		case success = "success"
		case session_id = "session_id"
	}

}
