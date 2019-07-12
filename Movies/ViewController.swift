//
//  ViewController.swift
//  Movies
//
//  Created by user on 2019. 07. 12..
//  Copyright © 2019. poimas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var searchController: UISearchController!
    
    var movies: [Result] = []
    var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.titleView = searchController.searchBar

    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.title.text = movies[indexPath.item].title
        cell.backgroundColor = UIColor(red: .random(in: 0...1),
                                       green: .random(in: 0...1),
                                       blue: .random(in: 0...1),
                                       alpha: 1.0)
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text ?? ""
        
        let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=43a7ea280d085bd0376e108680615c7f&language=en-US&page=1&include_adult=false&query=\(searchText)")!
        
        let task = URLSession.shared.moviesTask(with: url) { movies, response, error in
            if let movies = movies {
                self.movies = movies.results ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
            }
        }
        task.resume()
    }
    
}

