
import Foundation

class UserDefaultsManager {
    
    // MARK:- variables
    static let savedMovie = "SAVED_MOVIES"
    let defaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    

    // MARK:- setter functions
    func setRecentSearchMovie(movie: MovieList) {
        
        guard let savedMovie = defaults.object(forKey: UserDefaultsManager.savedMovie) as? Data else {
            var movies = [MovieList]()
            movies.insert(movie, at: 0) // Insert on first position
            if let encoded = try? encoder.encode(movies) {
                defaults.set(encoded, forKey: UserDefaultsManager.savedMovie)
            }
            return
        }
        
        guard var movies = try? decoder.decode([MovieList].self, from: savedMovie) else {
            var movies = [MovieList]()
            movies.append(movie)
            if let encoded = try? encoder.encode(movies) {
                defaults.set(encoded, forKey: UserDefaultsManager.savedMovie)
            }
            return
        }
        
        if movies.contains(where: { $0.id == movie.id }) {
            //            if let index = filterArray.index(of: movie.id!) {
            //                movies.remove(at: index)
            //                movies.insert(movie, at: 0)
            //            }
        } else {
            movies.insert(movie, at: 0)
        }
        
        // If recent searches more than 5 then remove first history
        if movies.count > 5 {
            movies.removeLast()
        }
        
        // Encode the model class and save in Local Storage
        if let encoded = try? encoder.encode(movies) {
            defaults.set(encoded, forKey: UserDefaultsManager.savedMovie)
        }
    }
    
    // MARK:- getter functions
    func getRecentSearchMovie() -> [MovieList] {
        // Fetch data from Local Storage
        if let savedMovie = defaults.object(forKey:  UserDefaultsManager.savedMovie) as? Data {
            let decoder = JSONDecoder()
            // Decode into model class
            guard let movies = try? decoder.decode([MovieList].self, from: savedMovie) else {
                return []
            }
            return movies
        }
        return []
    }
}
