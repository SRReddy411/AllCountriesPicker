//
//  ViewController.swift
//  AllCountriesDemo
//
//  Created by volive on 7/13/18.
//  Copyright © 2018 volive. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    fileprivate var filtered = [String]()
    fileprivate var filterring = false
    
    lazy var countries: [String] = {
        var names = [String]()
        let current = NSLocale(localeIdentifier: "en_US")
        for code in NSLocale.isoCountryCodes {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            print("id's are \(id)")
            let name = current.displayName(forKey: NSLocale.Key.identifier, value: id)
            
            print("names are \(String(describing: name))")
            if let country = name {
                names.append(country)
            }
        }
        return names
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        title = "Countries"
        //self.navigationController?.navigationBar.prefersLargeTitles = true
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        self.navigationItem.searchController = search
         myTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
         
    }
 
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("filterring value ",filterring ? self.filtered.count : countries.count)
        
        return self.filterring ? self.filtered.count : countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.filterring ? self.filtered[indexPath.row] : self.countries[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filterring == true{
             print("did select row \(self.filtered[indexPath.row])")
        }else{
            print("did select row \(self.countries[indexPath.row])")
        }
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filtered = self.countries.filter({ (country) -> Bool in
                return country.lowercased().contains(text.lowercased())
            })
            self.filterring = true
        }
        else {
            self.filterring = false
            self.filtered = [String]()
        }
        self.myTableView.reloadData()
    }
}

