//
//  MainViewController.swift
//  Trakt
//
//  Created by Vinicius on 06/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

protocol LoadContent: class {
    func didLoadContent(success: Bool)
    func didLoadImage(imageURL: String?, traktId: Int?)
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, LoadContent, LoadFavorite {
    
    // MARK: - Attributes
    
    lazy private var viewModel: HomeViewModel = HomeViewModel(delegate: self, favoriteDelegate: self)
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.navigationItem.title = "Trakt"
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
    }
    
    func load() {
        showLoader()
        viewModel.loadContent()
    }
    
    // MARK - UICollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->UICollectionViewCell {
        let cell: MovieCell = MovieCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(dto: viewModel.dtoForRow(row: indexPath.row))
        
        if indexPath.row == viewModel.numberOfRows() - 1 && viewModel.shouldMakeRequest {
            showLoader()
            viewModel.loadMore()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCell else {
            return
        }
        performSegue(withIdentifier: "showDetail", sender: cell.slug)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 15, height: 230)
    }
    
    
    // MARK: - LoadContent
    
    func didLoadContent(success: Bool) {
        DispatchQueue.main.async {
            self.dismissLoader()
        }
        
        if success {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        } else {
            let alert = UIAlertController(title: "Ops", message: "Something went wrong :(", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                self.load()
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - LoadFavorite
    
    func didLoadFavorites() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    func didLoadImage(imageURL: String?, traktId: Int?) {
        if let imageURL = imageURL, let traktId = traktId, let movieCells = collectionView.visibleCells as? [MovieCell], let movieCell = movieCells.filter ({ $0.traktId == traktId }).first {
            DispatchQueue.main.async {
                movieCell.fillImage(imageURL: imageURL)
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.seachRequest(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController, let slug = sender as? String {
            detailViewController.slug = slug
        }
    }
}
