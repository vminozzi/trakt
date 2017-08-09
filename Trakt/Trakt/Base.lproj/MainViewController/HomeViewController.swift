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

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, LoadContent {

    // MARK: - Attributes
    
    lazy private var viewModel: HomeViewModel = HomeViewModel(delegate: self)
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 15, height: 230)
    }

    
    // MARK: - LoadContent
    
    func didLoadContent(success: Bool) {
        if success {
            DispatchQueue.main.async {
                self.dismissLoader()
                self.collectionView?.reloadData()
            }
        }
    }
    
    func didLoadImage(imageURL: String?, traktId: Int?) {
        if let imageURL = imageURL, let traktId = traktId, let movieCells = collectionView.visibleCells as? [MovieCell], let movieCell = movieCells.filter ({ $0.traktId == traktId }).first {
            DispatchQueue.main.async {
                movieCell.fillImage(imageURL: imageURL)
            }
        }
    }
}
