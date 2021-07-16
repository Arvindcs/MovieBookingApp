
import UIKit

struct SimilarViewModel {
    
    
    // MARK:- variables for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager

    let imageUrlString: String
    let id: Int
    let movieName: String
    let movies: SimilarMovieResult

    var posterImage: BoxBind<UIImage?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(similarMovies: SimilarMovieResult?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        
        guard let similarMovie = similarMovies else {
            self.id = 0
            self.imageUrlString = ""
            self.movieName = ""
            self.movies = SimilarMovieResult(posterPath: "", title: "", video: false, id: 0, overview: "", releaseDate: "", adult: false, backdropPath: "", voteCount: 0, genreIDS: [], voteAverage: 0, originalLanguage: .en, originalTitle: "", popularity: 0)
            
            self.fileHandler = handler
            self.networkManager = networkManager
            return
        }
    
        self.imageUrlString = similarMovie.posterPath ?? ""
        self.id = similarMovie.id ?? 0
        self.movieName = similarMovie.title ?? ""
        self.movies = similarMovie

        self.fileHandler = handler
        self.networkManager = networkManager
        
        self.getMovieImage()
    }
    
    // MARK:- functions for the viewModel
    func getMovieImage() {
        if (fileHandler.checkIfFileExists(id: id)) {
            self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
        } else {
            guard let url = URL(string: "\(APIs.imageBaseString)\(imageUrlString)") else { return }
            networkManager.downloadMoviePoster(url: url, id: self.id) { res, error in
                if (error == .none) {
                    self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: id).path)
                }
            }
        }
    }
}
