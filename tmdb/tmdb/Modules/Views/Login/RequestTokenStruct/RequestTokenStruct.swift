import Foundation

struct RequestTokenStruct : Codable {
    
	let success : Bool
	let expires_at : String
	let request_token : String

	enum CodingKeys: String, CodingKey {
		case success = "success"
		case expires_at = "expires_at"
		case request_token = "request_token"
	}

}
