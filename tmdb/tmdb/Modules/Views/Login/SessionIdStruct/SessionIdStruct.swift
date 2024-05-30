import Foundation

struct SessionIdStruct : Codable {
    
	let success : Bool
	let session_id : String

	enum CodingKeys: String, CodingKey {

		case success = "success"
		case session_id = "session_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Bool.self, forKey: .success) ?? false
        session_id = try values.decodeIfPresent(String.self, forKey: .session_id) ?? "0"
	}

}
