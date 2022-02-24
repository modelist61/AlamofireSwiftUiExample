
import Foundation

struct MainModelFetcher: Decodable {
    let results: [PopularMovieList]
}

struct PopularMovieList: Identifiable, Decodable {
    let id: Int
    let original_title : String
    let poster_path : String
    let overview: String
    let genre_ids: [Int]
}

struct Parameters: Encodable {
    let api_key: String
}

struct UsersModel: Identifiable, Codable {
    let id: Int
    let name: String
    let email: String
}
