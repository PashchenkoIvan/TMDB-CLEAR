import Foundation

struct Tmdb : Codable {
    
	let avatar_path : String

	enum CodingKeys: String, CodingKey {
		case avatar_path = "avatar_path"
	}
}
