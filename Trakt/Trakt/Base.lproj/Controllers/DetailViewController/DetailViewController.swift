//
//  DetailViewController.swift
//  Trakt
//
//  Created by Vinicius on 10/08/17.
//  Copyright © 2017 vm. All rights reserved.
//

import UIKit

protocol LoadDetail: class {
    func didLoadDetail(error: Bool)
}

class DetailViewController: UITableViewController, LoadDetail {

    private lazy var viewModel: DetailViewModel = DetailViewModel(delegate: self)
    var slug = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContent()
    }
    
    func loadContent() {
        showLoader()
        viewModel.load(slug: slug)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailCell = DetailCell.createCell(tableView: tableView, indexPath: indexPath)
        cell.fill(title: viewModel.getTitleFor(row: indexPath.row, at: indexPath.section))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - LoadDetail
    
    func didLoadDetail(error: Bool) {
        DispatchQueue.main.async {
            self.dismissLoader()
        }
        if error {
            let alert = UIAlertController(title: "Ops", message: "Something went wrong :(", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
                
                
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                self.loadContent()
            }))
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
