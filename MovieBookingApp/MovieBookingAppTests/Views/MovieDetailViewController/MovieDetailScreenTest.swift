//
//  MovieDetailScreenTest.swift
//  FightClubTests
//
//  Created by Arvind Patel on 29/06/21.
//  Copyright © 2021 Arvind Patel. All rights reserved.
//

import XCTest
@testable import FightClub

class MovieDetailScreenTest: XCTestCase {
    
    
    // MARK:- variables
    private let handler = FileHandler()
    private let networkManager = NetworkManager()
    private let defaultsManager = UserDefaultsManager()
    
    private let movieId = 508943
    private let posterPath = "620hnMVLu6RSZW6a5rwO8gqpt0t.jpg"
    private var detailViewModel: DetailsViewModel!
    private var detailListViewModel: DetailListViewModel!
    
    override func setUpWithError() throws {
        detailViewModel = DetailsViewModel(movieId: movieId, moviePosterPath: posterPath, fileHandler: handler, defaultsManager: defaultsManager, networkManager: networkManager)
        detailListViewModel = DetailListViewModel(movieId: movieId, handler: handler, networkManager: networkManager, defaultsManager: defaultsManager)
        
    }
    
    override func tearDownWithError() throws {
        detailViewModel = nil
        detailListViewModel = nil
    }
    
    // DetailsViewModel Test
    func testThatCheckMoviePostDownload_WhenAPIGetsCall() throws {
        //CHECK
        let expectation = XCTestExpectation(description: "Download Poster")
        detailViewModel.moviePosterImage.bind { image in
            expectation.fulfill()
            XCTAssertNotNil(image)
        }
        wait(for: [expectation], timeout: 30)
    }
    
    // MovieListViewModel Test
    func testThatCheckMovieDetails_WhenAPIGetsCall() throws {
        //CHECK
        let expectation = XCTestExpectation(description: "Movie Details fetch")
        detailViewModel.movieDetails.bind { movieDetails in
            if (movieDetails != nil) {
                expectation.fulfill()
                XCTAssertTrue(movieDetails?.id == self.movieId)
            }
        }
        wait(for: [expectation], timeout: 30)
    }
    
    // MovieListViewModel Test
    func testThatCheckSimilarMovieList_WhenAPIGetsCall() throws {
        //CHECK
        let expectation = XCTestExpectation(description: "Similar Movie List fetch")
        detailListViewModel.similarMovies.bind { similarMovies in
            if (similarMovies?.first?.id != 0) {
                expectation.fulfill()
                XCTAssertTrue(similarMovies?.count ?? 0 > 0)
            }
        }
        wait(for: [expectation], timeout: 30)
        
    }
    
    // MovieListViewModel Test
    func testThatCheckMovieCastList_WhenAPIGetsCall() throws {
        //CHECK
        let expectation = XCTestExpectation(description: "Movie Cast List fetch")
        detailListViewModel.movieCredits.bind { movieCredits in
            if (movieCredits?.first?.id != 0) {
                expectation.fulfill()
                XCTAssertTrue(movieCredits?.count ?? 0 > 0)
            }
        }
        wait(for: [expectation], timeout: 30)
    }
    
    // MovieListViewModel Test
    func testThatCheckMovieReviewList_WhenAPIGetsCall() throws {
        //CHECK
        let expectation = XCTestExpectation(description: "Movie Review List fetch")
        detailListViewModel.movieReviews.bind { movieReviews in
            if (movieReviews?.first?.id != "") {
                expectation.fulfill()
                XCTAssertTrue(movieReviews?.count ?? 0 > 0)
            }
        }
        wait(for: [expectation], timeout: 30)
    }
}
