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
}

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, LoadContent {

    // MARK: - Attributes
    
    lazy private var viewModel: HomeViewModel = HomeViewModel(delegate: self)
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
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

    
    // MARK: - LoadContent
    
    func load() {
        showLoader()
        viewModel.loadContent()
    }
    
    func didLoadContent(success: Bool) {
        if success {
            DispatchQueue.main.async {
                self.dismissLoader()
                self.collectionView?.reloadData()
            }
        }
    }
}
