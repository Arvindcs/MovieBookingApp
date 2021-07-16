import UIKit

struct DetailsViewModel {
    
    let fileHandler: FileHandler
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    
    var movieDetails: BoxBind<MovieDetails?> = BoxBind(nil)
    var moviePosterImage: BoxBind<UIImage?> = BoxBind(nil)
    let movieId: Int
    let moviePosterPath: String
    
    init(movieId: Int, moviePosterPath: String, fileHandler: FileHandler, defaultsManager: UserDefaultsManager, networkManager: NetworkManager) {
        self.movieId = movieId
        self.moviePosterPath = moviePosterPath
        
        self.fileHandler = fileHandler
        self.defaultsManager = defaultsManager
        self.networkManager = networkManager
        
        self.getMovieDetails()
        self.getMoviePoster()
    }
    
    // MARK:- functions for the viewModel
    func getMovieDetails() {
        networkManager.getMovieDetails(movieId: self.movieId, completion: { res, error in
            guard let movies = res else { return }
            movieDetails.value = movies
        })
    }
    
    func getMoviePoster() {
        if (fileHandler.checkIfFileExists(id: movieId)) {
            self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: self.movieId).path)
        } else {
            guard let url = URL(string: "\(APIs.imageBaseString)\(moviePosterPath)") else { return }
            networkManager.downloadMoviePoster(url: url, id: self.movieId) { res, error in
                if (error == .none) {
                    self.moviePosterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: movieId).path)
                }
            }
        }
    }
}
