
import Foundation
import UIKit

struct MovieViewModel {
    
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
    var moviePosterImage: Binding<UIImage?> = Binding(nil)
    var moviePosterUrl: URL {
        guard let url = URL(string: "\(Constants.imageBaseString)\(self.posterPath ?? "")") else { return URL(string: "")! }
        return url
    }
    
    // MARK:- initializer for the viewModel
    init(meta: MovieList?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        
        guard let meta = meta else {
            self.adult = false
            self.backdropPath = ""
            self.genreIDS = []
            self.id = 0
            self.originalLanguage = ""
            self.originalTitle = ""
            self.overview = ""
            self.popularity = 0
            self.posterPath = ""
            self.releaseDate = ""
            self.title = ""
            self.video = false
            self.voteAverage = 0
            self.voteCount = 0
            self.fileHandler = handler
            self.networkManager = networkManager
            return
        }
        
        self.adult = meta.adult
        self.backdropPath = meta.backdropPath
        self.genreIDS = meta.genreIDS
        self.id = meta.id
        self.originalLanguage = meta.originalLanguage
        self.originalTitle = meta.originalTitle
        self.overview = meta.overview
        self.popularity = meta.popularity
        self.posterPath = meta.posterPath
        self.releaseDate = meta.releaseDate
        self.title = meta.title
        self.video = meta.video
        self.voteAverage = meta.voteAverage
        self.voteCount = meta.voteCount
        self.fileHandler = handler
        self.networkManager = networkManager
        getMoviePoster()
    }
    
    func getMoviePoster() {
        if (fileHandler.checkIfFileExists(id: id ?? 0)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id ?? 0).path)
        } else {
            networkManager.downloadMoviePoster(url: self.moviePosterUrl, id: id ?? 0) { res, error in
                if (error == .none) {
                    self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id ?? 0).path)
                }
            }
        }
    }
}
