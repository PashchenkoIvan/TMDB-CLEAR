import Foundation

struct FavoritesStruct: Codable {
    let page: Int
    let results: Array<Movie>
    let total_pages: Int
    let total_results: Int
}
