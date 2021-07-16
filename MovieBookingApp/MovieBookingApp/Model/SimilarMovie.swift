
import Foundation

// MARK: - SimilarMovie
struct SimilarMovies: Codable {
    let page: Int?
    let results: [SimilarMovieResult]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - SimilarMovieResult
struct SimilarMovieResult: Codable {
    let posterPath, title: String?
    let video: Bool?
    let id: Int?
    let overview, releaseDate: String?
    let adult: Bool?
    let backdropPath: String?
    let voteCount: Int?
    let genreIDS: [Int]?
    let voteAverage: Double?
    let originalLanguage: OriginalLanguage?
    let originalTitle: String?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case title, video, id, overview
        case releaseDate = "release_date"
        case adult
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case genreIDS = "genre_ids"
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case fr = "fr"
    case ja = "ja"
    case zh = "zh"
    case ko = "ko"
}
