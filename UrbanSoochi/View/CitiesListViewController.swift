//
//  CitiesListViewController.swift
//  UrbanSoochi
//
//  Created by Vinayak.gh on 16/04/20.
//  Copyright © 2020 Personal. All rights reserved.
//

import UIKit

class CitiesListViewController: UIViewController {

    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityListTableView: UITableView!

    let cellIdentifier = "CellId"

    var viewModel = CitiesListViewModel()
    var countriesAndCities: CountriesAndCities? {
        didSet {
            self.cityListTableView.reloadData()
        }
    }

    // MARK: - View life cycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.initiateLoading()
    }

    // MARK: - Initial data load configuration
    private func initiateLoading() {
        self.viewModel.getListOfCities { (success, error) in
            if success {
                self.updateView()
            }
            if let error = error {
                self.handleError(error)
            }
            self.cityListTableView.reloadData()
        }
    }

    private func setUpView() {
        self.cityListTableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.cityListTableView.dataSource = self
        self.cityListTableView.delegate = self
        self.cityListTableView.allowsSelection = false

        self.citySearchBar.delegate = self
    }

    // MARK: - Helper methods

    //Updates the data source to reload the table view
    private func updateView() {
        if let countriesAndCities = self.viewModel.countriesAndCities {
            self.countriesAndCities = countriesAndCities
        } else {
            self.handleError(.noData)
        }
    }

    //Handles the error by displaying an alert with suitable message
    private func handleError(_ error: NetworkError) {
        let alert = UIAlertController(title: "Note",
                                  message: "\(error.localizedDescription).\nTry after sometime!!",
                                  preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "Ok",
                                     style: UIAlertAction.Style.default, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    //Initiates a search for an entered text to filter the data and updates the view
    private func beginSearch(forKey searchKey: String) {
        guard let filteredCountriesAndCities = self.viewModel.filterForSearchKey(searchKey) else {
            //If the search key is not found reload the view
            self.updateView()
            return
        }
        self.countriesAndCities = filteredCountriesAndCities
    }
}

// MARK: - UISearchBarDelegate methods

extension CitiesListViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.becomeFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.beginSearch(forKey: searchText)
        } else {
            self.updateView()
        }
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        let maxNumberOfCharacters: Int = 40 //An assumption
        guard let searchText = searchBar.text else {
            return false
        }
        //For checking the allowedCharacters
        let validText = text.components(separatedBy: allowedContactFieldCharacterSet).joined(separator: "")
        let currentText: NSString = NSString(string: searchText)
        let newText: NSString = currentText.replacingCharacters(in: range, with: text) as NSString
        return (newText.length <= maxNumberOfCharacters) && (text == validText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.updateView()
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
}

// MARK: - UITableViewDataSource methods

extension CitiesListViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let countriesAndCities = self.countriesAndCities else {
            return 0
        }
        return countriesAndCities.countryNames.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countriesAndCities = self.countriesAndCities else {
            return 0
        }
        let countries = countriesAndCities.countryNames
        let country = countries[section]
        let cities = countriesAndCities.citiesGroupedByCountry[country]
        return cities?.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      guard let countriesAndCities = self.countriesAndCities else {
           return nil
       }
       return countriesAndCities.countryNames[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) else {
            return UITableViewCell()
        }

        if let countriesAndCities = self.countriesAndCities {
            let country = countriesAndCities.countryNames[indexPath.section]
            let cities = countriesAndCities.citiesGroupedByCountry[country]
            if let cities = cities {
                cell.textLabel?.text = cities[indexPath.row].name
            }
         }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CitiesListViewController: UITableViewDelegate {}
