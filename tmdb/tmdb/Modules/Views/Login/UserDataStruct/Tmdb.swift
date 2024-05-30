import Foundation

struct Tmdb : Codable {
    
	let avatar_path : String

	enum CodingKeys: String, CodingKey {

		case avatar_path = "avatar_path"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        avatar_path = try values.decodeIfPresent(String.self, forKey: .avatar_path) ?? ""
	}

}
