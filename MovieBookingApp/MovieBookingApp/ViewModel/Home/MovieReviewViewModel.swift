
import Foundation
import UIKit

struct MovieReviewViewModel {
    
    // MARK:- variables for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager
    
    let imageUrlString: String
    let id: String
    let authorName: String
    let movieReview: MovieReviews
    
    var posterImage: Binding<UIImage?> = Binding(nil)
    
    // MARK:- initializer for the viewModel
    init(movieReviews: MovieReviews?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        guard let movieReviews = movieReviews else {
            self.id = ""
            self.imageUrlString = ""
            self.authorName = ""
            self.movieReview = MovieReviews(author: "", authorDetails: AuthorDetails(name: "", username: "", avatarPath: "", rating: 0), content: "", createdAt: "", id: "", updatedAt: "", url: "")
            self.fileHandler = handler
            self.networkManager = networkManager
            return
        }
        
        self.imageUrlString = movieReviews.authorDetails?.avatarPath ?? ""
        self.id = movieReviews.id ?? ""
        self.authorName = movieReviews.author ?? ""
        self.movieReview = movieReviews
        self.fileHandler = handler
        self.networkManager = networkManager
        self.getMovieImage()
    }
    
    // MARK:- functions for the viewModel
    func getMovieImage() {
        if (fileHandler.checkIfFileExists(id: Int(id) ?? 0)) {
            self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: Int(id) ?? 0).path)
        } else {
            guard let url = URL(string: "\(Constants.imageBaseString)\(imageUrlString)") else { return }
            networkManager.downloadMoviePoster(url: url, id: Int(id) ?? 0) { res, error in
                if (error == .none) {
                    self.posterImage.value = UIImage(contentsOfFile: fileHandler.getPathForImage(id: Int(id) ?? 0).path)
                }
            }
        }
    }
}
