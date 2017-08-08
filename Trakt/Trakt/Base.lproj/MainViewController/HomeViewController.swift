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

class HomeViewController: UICollectionViewController, LoadContent {

    lazy private var viewModel: HomeViewModel = HomeViewModel(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    func load() {
        showLoader()
        viewModel.loadContent()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->UICollectionViewCell {
        let cell: MovieCell = MovieCell.createCell(collectionView: collectionView, indexPath: indexPath)
        cell.fill(dto: viewModel.dtoForRow(row: indexPath.row))
        return cell
    }

    
    // MARK: LoadContent
    
    func didLoadContent(success: Bool) {
        if success {
            DispatchQueue.main.async {
                self.dismissLoader()
                self.collectionView?.reloadData()
            }
        }
    }
}
