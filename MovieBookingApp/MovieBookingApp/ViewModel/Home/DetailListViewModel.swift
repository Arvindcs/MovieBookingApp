
import UIKit

// The DetailListViewModel are the ones that calls the APIs and provide the array data to the Viewcontrollers.
struct DetailListViewModel {
    
    enum ListType {
        case movieCast
        case similarMovies
        case movieReview
    }
    
    // MARK:- variable for the viewModel
    let defaultsManager: UserDefaultsManager
    let networkManager: NetworkManager
    let fileHandler: FileHandler
    
    // Limiting the actors count to 5, since the api doesn't support multiple ids, calling APIs without the limit, easily exahauts the 500 API call / month free limit of the site.
    let movieId: Int
    var offset: Int = 0
    var limit: Int = 5
    
    var prefetch: Binding<Bool> = Binding(false)
    var similarMovies: Binding<[SimilarViewModel]?> = Binding([SimilarViewModel](repeating: SimilarViewModel(similarMovies: nil), count: 5))
    var movieCredits: Binding<[MovieCastViewModel]?> = Binding([MovieCastViewModel](repeating: MovieCastViewModel(movieCast: nil), count: 5))
    var movieReviews: Binding<[MovieReviewViewModel]?> = Binding([MovieReviewViewModel](repeating: MovieReviewViewModel(movieReviews: nil), count: 5))
    
    // MARK:- initializer for the viewModel
    init(movieId: Int = 0, handler: FileHandler, networkManager: NetworkManager, defaultsManager: UserDefaultsManager) {
        self.defaultsManager = defaultsManager
        self.networkManager = networkManager
        self.fileHandler = handler
        self.movieId = movieId
        
        self.getSimilarMovies()
        self.getMovieCredits()
        self.getMovieReviews()
    }
    
    // MARK:- functions for the viewModel
    func getSimilarMovies() {
        networkManager.getSimilarMovies(movieId: movieId) { (res, apiError) in
            guard let movies = res else { return }
            similarMovies.value = movies.map( { SimilarViewModel(similarMovies: $0) })
        }
    }
    
    func getMovieCredits() {
        networkManager.getCredits(movieId: movieId) { (res, apiError) in
            guard let movies = res else { return }
            movieCredits.value = movies.map( { MovieCastViewModel(movieCast: $0) })
        }
    }
    
    func getMovieReviews() {
        networkManager.getReviewFor(movieId: movieId) { (res, apiError) in
            guard let movies = res else { return }
            movieReviews.value = movies.map( { MovieReviewViewModel(movieReviews: $0) })
        }
    }
        
    // for displaying data
    func getCountForDisplay(type : ListType) -> Int {
        if type == .similarMovies {
            guard let actorViewModels =  self.similarMovies.value else { return 0 }
            return actorViewModels.count
        } else if type == .movieReview {
            guard let movieReviewViewModels =  self.movieReviews.value else { return 0 }
            return movieReviewViewModels.count
        } else {
            guard let actorViewModels =  self.movieCredits.value else { return 0 }
            return actorViewModels.count
        }
    }
    
    func prepareCellForDisplay(collectionView: UICollectionView, indexPath: IndexPath, type : ListType) -> UICollectionViewCell {
        if type == .similarMovies {
            guard let movieViewModels = self.similarMovies.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SimilarCollectionViewCell.identifier(), for: indexPath) as? SimilarCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        } else if type == .movieReview {
            guard let movieViewModels = self.movieReviews.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier(), for: indexPath) as? ReviewCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        } else {
            guard let movieViewModels = self.movieCredits.value else { return UICollectionViewCell()}
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier(), for: indexPath) as? CastCollectionViewCell {
                cell.setupCell(viewModel: movieViewModels[indexPath.row])
                return cell
            }
        }
        fatalError()
    }
}
