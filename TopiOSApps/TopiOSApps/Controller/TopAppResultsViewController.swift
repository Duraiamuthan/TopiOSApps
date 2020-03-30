//
//  ViewController.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import UIKit

class TopAppResultsViewController: UIViewController,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var searchBariOSAppFilter: UISearchBar!
    @IBOutlet weak var tblViewiOSAppFilterResults: UITableView!
    @IBOutlet weak var segmentControlTopApps: UISegmentedControl!
    var refreshControl:UIRefreshControl!
    var apps:[Entry]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting the title
        self.navigationItem.title = AppConstants.rootViewControllerTitle
        
        // Setting search bar place holder text
        self.setPlaceHolderText()
        
        // Configure Pull to Refresh
        self.configurePullToRefresh()
        
        // setting delegate for search bar
         searchBariOSAppFilter.delegate=self
        
        // setting delegate for tableview
        tblViewiOSAppFilterResults.dataSource=self
        tblViewiOSAppFilterResults.delegate=self
        
        // get the app data
        self.getData(refersh: false)
        
        if traitCollection.userInterfaceStyle == .dark {
            self.tblViewiOSAppFilterResults.backgroundColor = .black
            self.view.backgroundColor = .black
        } else {
            self.tblViewiOSAppFilterResults.backgroundColor = .white
            self.view.backgroundColor = .white
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tblViewiOSAppFilterResults.indexPathForSelectedRow {
             let object:Entry? = self.apps?[indexPath.row]
            let appDetailVC = segue.destination as? AppDetailViewController
            appDetailVC?.detailText = object?.summary.label
        }
    }
   
    // MARK: - Data
    
    // It brings the app related data
    func getData(refersh:Bool) {
        GetAppCatalog.GetListOfApps { Entries in
             self.apps=Entries;
             DispatchQueue.main.async() {
                
                // if pull to refresh is enabled stop it
                if refersh {
                    self.refreshControl?.endRefreshing()
                }
                
                //reload the table view
                self.tblViewiOSAppFilterResults.reloadData()
             }
         };
    }
    
    // Mark:- Segment methods
    @IBAction func segmentSelection(sender:UISegmentedControl){
        self.setPlaceHolderText()
    }
    
    // Mark:- Pull to Refresh
    
    
    // to configure pulll to refresh for current table view
    func configurePullToRefresh(){
        self.refreshControl = UIRefreshControl()
         refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
         self.tblViewiOSAppFilterResults.addSubview(refreshControl!)
    }
    
    // pull to refresh target function
    @objc func refresh(sender:AnyObject) {
           self.getData(refersh: true)
    }
    
    // MARK: - Searchbar methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func setPlaceHolderText(){
        switch segmentControlTopApps.selectedSegmentIndex {
        case 0:
            searchBariOSAppFilter.placeholder=AppConstants.searchPlaceHolderOne
        case 1:
             searchBariOSAppFilter.placeholder=AppConstants.searchPlaceHolderTwo
        default:
            searchBariOSAppFilter.placeholder=AppConstants.searchPlaceHolderDefault
        }
    }
    
    // MARK: - Tableview methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.apps?.count ?? 0;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.customTableViewCellId, for: indexPath) as! AppDetailTableViewCell
        let appMeta:Entry? = self.apps?[indexPath.row]
        cell.lblAppName!.text = appMeta?.imName.label

        let placeholderImage: UIImage = UIImage(named: AppConstants.lazyLoadingDefaultImageName)!
        cell.imgAppIcon.image = placeholderImage

        cell.imgAppIcon.downloadImageFrom(link: appMeta?.imImage[0].label, contentMode: UIView.ContentMode.scaleAspectFit)
        
        if traitCollection.userInterfaceStyle == .dark {
          cell.lblAppName.backgroundColor = .black
        } else {
          cell.lblAppName.backgroundColor = .white
          cell.backgroundColor = .white
        }
        return cell
    }

}
