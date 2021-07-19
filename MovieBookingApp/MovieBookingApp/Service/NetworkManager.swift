
import UIKit
import Alamofire

enum APIError: String {
    case networkError
    case apiError
    case decodingError
}

enum APIs: URLRequestConvertible  {
    
    // MARK: Cases containing APIs
    case getMoviesList
    case getMoviesDetails(id: Int)
    case getSimilarMovies(id: Int)
    case getCredits(id: Int)
    case getReviews(id: Int)
 
    // MARK:  URL path
    var path: String {
        switch self {
        case .getMoviesList:
            return "/movie/now_playing"
        case .getMoviesDetails(let movieId):
            return "/movie/\(movieId)"
        case .getSimilarMovies(let movieId):
            return "/movie/\(movieId)/similar"
        case .getCredits(let movieId):
            return "/movie/\(movieId)/credits"
        case .getReviews(let movieId):
            return "/movie/\(movieId)/reviews"
        }
    }
    
    // MARK: HTTPMethod
    var method: HTTPMethod {
        return .get
    }
    
    var encoding : URLEncoding {
        return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets)
    }
    
    func addApiHeaders(request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("utf-8", forHTTPHeaderField: "charset")
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = "\(Constants.endpoint.absoluteString)\(path)"
        var request = URLRequest(url: URL(string: url)!)
        var parameters = Parameters()
        parameters["api_key"] = Constants.apiKey
        addApiHeaders(request: &request)
        request = try encoding.encode(request, with: parameters)
        return request
    }
}

struct NetworkManager {
    
    let jsonDecoder = JSONDecoder()
    let fileHandler = FileHandler()
    let imageCompressionScale: CGFloat = 0.25
    
    // functions to call the APIs
    public func getNowPlayingMovies(completion: @escaping([MovieList]?, APIError?) -> ()) {
        Alamofire.request(APIs.getMoviesList).validate().responseData { response in
            switch response.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success:
                if let jsonData = response.data {
                    do {
                        let movies = try jsonDecoder.decode(Movies.self, from: jsonData)
                        completion(movies.results, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    public func getMovieDetails(movieId: Int, completion: @escaping(MovieDetails?, APIError?) -> ()) {
        Alamofire.request(APIs.getMoviesDetails(id: movieId)).validate().responseData { response in
            switch response.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success:
                if let jsonData = response.data {
                    do {
                        let movies = try jsonDecoder.decode(MovieDetails.self, from: jsonData)
                        completion(movies, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }

    public func getCredits(movieId: Int, completion: @escaping([Cast]?, APIError?) -> ()) {
        Alamofire.request(APIs.getCredits(id: movieId)).validate().responseData { response in
            switch response.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success:
                if let jsonData = response.data {
                    do {
                        let movies = try jsonDecoder.decode(MovieCredits.self, from: jsonData)
                        completion(movies.cast, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    public func getSimilarMovies(movieId: Int, completion: @escaping([SimilarMovieResult]?, APIError?) -> ()) {
        Alamofire.request(APIs.getSimilarMovies(id: movieId)).validate().responseData { response in
            switch response.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success:
                if let jsonData = response.data  {
                    do {
                        let movies = try jsonDecoder.decode(SimilarMovies.self, from: jsonData)
                        completion(movies.results, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    public func getReviewFor(movieId: Int, completion: @escaping([MovieReviews]?, APIError?) -> ()) {
        Alamofire.request(APIs.getReviews(id: movieId)).validate().responseData { response in
            switch response.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success:
                if let jsonData = response.data {
                    do {
                        let movies = try jsonDecoder.decode(Reviews.self, from: jsonData)
                        completion(movies.results, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    public func downloadMoviePoster(url: URL, id: Int, completion: @escaping(URL?, APIError?) -> ()) {
        Alamofire.request(URLRequest(url: url)).validate().responseData { res in
            switch res.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let imageData):
                guard let image = UIImage(data: imageData), let compressedData = image.jpegData(compressionQuality: imageCompressionScale) else { return }
                do {
                    try compressedData.write(to: fileHandler.getPathForImage(id: id))
                    completion(fileHandler.getPathForImage(id: id), nil)
                } catch {
                    print(error)
                    completion(nil, .decodingError)
                }
            }
        }
    }
}
