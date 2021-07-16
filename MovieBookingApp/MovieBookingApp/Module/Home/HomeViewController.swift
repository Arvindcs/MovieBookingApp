
import UIKit

class HomeViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var recentlySearchedHeaderView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:- Variable
    public var homeViewModel: HomeViewModel!
    private let defaultsManager = UserDefaultsManager()
    private let networkManager = NetworkManager()
    private var searchtext: String = ""
    
    
    // MARK:-  viewController lifeCycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        didSelectSearchBarCancelButton()
    }
    
    // MARK:- functions for the viewController
    private func setupUI() {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.delegate = self
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        searchTableView.register(UINib(nibName: RecentSearchTableCell.identifier(), bundle: nil), forCellReuseIdentifier: RecentSearchTableCell.identifier())
        searchTableView.register(UINib(nibName: HomeTableCell.identifier(), bundle: nil), forCellReuseIdentifier: HomeTableCell.identifier())
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 1))
        tableView.register(UINib(nibName: HomeTableCell.identifier(), bundle: nil), forCellReuseIdentifier: HomeTableCell.identifier())
    }
    
    // MARK:  setupViewModel
    private func setupViewModel() {
        self.homeViewModel = HomeViewModel(defaultsManager: defaultsManager, networkManager: networkManager)
        self.homeViewModel.nowPlayingMovies.bind { _ in
            self.tableView.reloadData()
        }
        
        self.homeViewModel.filteredMovies.bind { _ in
            self.searchTableView.reloadData()
        }
    }
    
    // MARK:  Search Bar Methods
    private func didSelectSearchBarCancelButton() {
        searchTableView.isHidden = true
        tableView.isHidden = false
        searchBar.text = nil
        searchtext = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchTableView.reloadData()
    }
    
    private func didStartSearchBarEditing() {
        searchBar.setShowsCancelButton(true, animated: true)
        searchTableView.isHidden = false
        tableView.isHidden = true
        searchtext = ""
        homeViewModel.getRecentSearchedMovies()
        searchTableView.reloadData()
    }
    
    private func didSelectSearchBarSearchButton() {
        searchBar.resignFirstResponder()
    }
}

// MARK:- UITableViewDataSource & UITableViewDelegate Methods
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchTableView {
            if self.searchtext.count > 0 {
                return self.homeViewModel.getCountForDisplay(type: .search)
            } else {
                return self.homeViewModel.getCountForDisplay(type: .recentSearch)
            }
        } else {
            return self.homeViewModel.getCountForDisplay(type: .nowPlaying)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchTableView {
            if self.searchtext.count > 0 {
                return homeViewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath, type: .search)
            } else {
                return homeViewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath, type: .recentSearch)
            }
        } else {
            return homeViewModel.prepareCellForDisplay(tableView: tableView, indexPath: indexPath, type: .nowPlaying)
        }        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailVC = MovieDetailViewController.instantiate(from: .main)
        var movieModel = MovieViewModel(meta: nil)
        
        
        // TODO:- Check Condition Because multiple tableview here
        if tableView == searchTableView && self.searchtext.count > 0 {
            
            // TODO:- Selection of Searched List
            guard let movieViewModels =  homeViewModel.filteredMovies.value else { return }
            movieModel = movieViewModels[indexPath.row]
            
            // TODO:- Save The Search History in User Defaults
            guard let movieList =  homeViewModel.filteredMovies.value?.compactMap({
                MovieList(adult: $0.adult, backdropPath: $0.backdropPath, genreIDS: $0.genreIDS, id: $0.id, originalLanguage: $0.originalLanguage, originalTitle: $0.originalTitle, overview: $0.overview, popularity: $0.popularity, posterPath: $0.posterPath, releaseDate: $0.releaseDate, title: $0.title, video: $0.video, voteAverage: $0.voteAverage, voteCount: $0.voteCount)
            }) else { return }
            defaultsManager.setRecentSearchMovie(movie: movieList[indexPath.row])
            
        } else if tableView == searchTableView {
            // TODO:- Selection of Recetly Searched List
            let movieViewModels = homeViewModel.recentlySearchedMovies.compactMap({
                MovieViewModel(meta:  $0)
            })
            movieModel = movieViewModels[indexPath.row]
            
        } else {
            
            // TODO:- Selection of Movie List
            guard let movieViewModels =  homeViewModel.nowPlayingMovies.value else { return }
            movieModel = movieViewModels[indexPath.row]
        }
        
        movieDetailVC.movieViewModel = movieModel
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }
    
    // TODO:- Handle Table View Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView && self.searchtext.count == 0 {
            return RecentSearchTableCell().cellHeight
        } else {
            return HomeTableCell().cellHeight
        }
    }
    
    // TODO:- Add Recently Searched View Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == searchTableView {
            return recentlySearchedHeaderView
        }
        return nil
    }
    
    // TODO:- Set Recently Searched View Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == searchTableView {
            return RecentSearchTableCell().headerHeight
        }
        return 0
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.didStartSearchBarEditing()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchtext = searchText
        self.homeViewModel.getMoviesFromSearch(query: searchText)
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.didSelectSearchBarCancelButton()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.didSelectSearchBarSearchButton()
    }
}
