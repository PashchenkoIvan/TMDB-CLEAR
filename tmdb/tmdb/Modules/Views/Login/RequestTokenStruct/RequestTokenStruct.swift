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

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        expires_at = try values.decodeIfPresent(String.self, forKey: .expires_at) ?? "0"
        request_token = try values.decodeIfPresent(String.self, forKey: .request_token) ?? "0"
	}

}
