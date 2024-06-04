import Foundation

struct FavoritesStruct: Codable {
    let page: Int
    let results: Array<Movie>
    let totalPages: Int?
    let totalResults: Int?
}
