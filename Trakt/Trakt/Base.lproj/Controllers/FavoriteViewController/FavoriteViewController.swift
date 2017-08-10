//
//  FavoriteViewController.swift
//  Trakt
//
//  Created by Vinicius on 09/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

protocol LoadFavorite: class {
    func didLoadFavorites()
}

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LoadFavorite {

    
    private lazy var viewModel: FavoriteViewModel = FavoriteViewModel(delegate: self)
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 15, height: 230)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MovieCell else {
            return
        }
        performSegue(withIdentifier: "showDetail", sender: cell.slug)
    }
    
    
    // MARK: - LoadFavorite
    
    func didLoadFavorites() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailViewController = segue.destination as? DetailViewController, let slug = sender as? String {
            detailViewController.slug = slug
        }
    }
}
