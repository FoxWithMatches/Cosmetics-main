//
//  MakeUpListViewController.swift
//  Cosmetics
//
//  Created by Alisa Ts on 30.11.2021.
//

import UIKit
import Alamofire

class MakeUpListViewController: UITableViewController {
    
    @IBOutlet var activitiIndicator: UIActivityIndicatorView!
    @IBOutlet var progressView: UIProgressView!
    
    private var makeUps = [MakeUpElement]()
   
    private var filtredMakeUps = [MakeUpElement]()
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltring: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progressView.isHidden = false
        tableView.rowHeight = 100
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        downloadProgress()
        fetchMakeUP()
    }
    
    func fetchMakeUP() {
        NetworkManager.fetchMakeUp(from: Link.cosmetics.rawValue) { (makeUps) in
            self.makeUps = makeUps
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func downloadProgress() {
        NetworkManager.onProgress = { progress in
            self.progressView.progress = Float(progress)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltring {
            return filtredMakeUps.count
        }
        return makeUps.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        var makeUp: MakeUpElement
        
        if isFiltring {
            makeUp = filtredMakeUps[indexPath.row]
        } else {
            makeUp = makeUps[indexPath.row]
        }
        
        cell.configure(with: makeUp)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            guard let detailsVC = segue.destination as? DetailViewController else { return }

            var makeUp: MakeUpElement

            if isFiltring {
                makeUp = filtredMakeUps[indexPath.row]
            } else {
                makeUp = makeUps[indexPath.row]
            }

            detailsVC.dataMakeUp = makeUp
        }
    }
}

extension MakeUpListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        filtredMakeUps = makeUps.filter({ (makeUp: MakeUpElement) -> Bool in
            return makeUp.name?.lowercased().contains(searchText.lowercased()) ?? false
        })
        tableView.reloadData()
    }
}

