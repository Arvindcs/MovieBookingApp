//
//  MovieCastViewModel.swift
//  FightClub

import Foundation
import UIKit

struct MovieCastViewModel {
    
    // MARK:- variables for the viewModel
    let fileHandler: FileHandler
    let networkManager: NetworkManager

    let imageUrlString: String
    let id: Int
    let movieName: String
    let movieCast: Cast

    var posterImage: BoxBind<UIImage?> = BoxBind(nil)
    
    // MARK:- initializer for the viewModel
    init(movieCast: Cast?, handler: FileHandler = FileHandler(), networkManager: NetworkManager = NetworkManager()) {
        
        guard let movieCast = movieCast else {
            self.id = 0
            self.imageUrlString = ""
            self.movieName = ""
            self.movieCast = Cast(adult: false, gender: 0, id: 0, knownForDepartment: "", name: "", originalName: "", popularity: 0, profilePath: "", castID: 0, character: "", creditID: "", order: 0, department: "", job: "")
            self.fileHandler = handler
            self.networkManager = networkManager
            return
        }
    
        self.imageUrlString = movieCast.profilePath ?? ""
        self.id = movieCast.id ?? 0
        self.movieName = movieCast.name ?? ""
        self.movieCast = movieCast
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
