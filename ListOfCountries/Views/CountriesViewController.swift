//
//  CountriesViewController.swift
//  ListOfCountries
//
//  Created by Zak Mills on 6/16/25.
//

import UIKit

class CountriesViewController: UIViewController {
    private let viewModel = CountriesViewModel()
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Countries"
        view.backgroundColor = .white
        
        setupSearchController()
        setupTableView()
        bindViewModel()

        Task {
            await viewModel.loadData(from: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json")
        }
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search country..."
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // Optional: keeps search bar always visible
        definesPresentationContext = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomCellViewController.self, forCellReuseIdentifier: "Cell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.systemGray6
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()}
    }
    
    
    
}

extension CountriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = viewModel.filteredCountries[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCellViewController else {
            return UITableViewCell()
        }
        cell.configure(mainText: "\(country.name), \(country.region)", secondaryText: country.capital, trailingText: country.code)
        return cell
    }
}

extension CountriesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterCountries(with: searchText)
    }
}
