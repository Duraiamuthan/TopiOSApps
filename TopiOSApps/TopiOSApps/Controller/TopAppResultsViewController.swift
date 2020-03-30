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
    var apps:[Entry]?,appsOriginal:[Entry]?
    
    
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
        
        //Notification center
        let nc = NotificationCenter.default
        
        //Adding observer for server related connection error
        nc.addObserver(self, selector: #selector(onErrorFetchingServerData(_:)), name: Notification.Name(AppConstants.errorFetchingServerDataNotificationName), object: nil)
        
        //Adding observer for data error
        nc.addObserver(self, selector: #selector(onDataError(_:)), name: Notification.Name(AppConstants.errorWithDataNotificationName), object: nil)

    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tblViewiOSAppFilterResults.indexPathForSelectedRow {
             let object:Entry? = self.apps?[indexPath.row]
            let appDetailVC = segue.destination as? AppDetailViewController
            appDetailVC?.detailText = object?.summary.label
        }
    }
    
    // MARK: - Notification center receipient methods
    
    // For handling network related error
    @objc func onErrorFetchingServerData(_ notification:Notification) {
        let err:Error? =  notification.object as? Error
        
        let errorCode = (err as NSError?)?.code
        
        print("ErrorCode:\(String(describing: errorCode))")
        
        let alert = UIAlertController(title: AppConstants.errorAlertTitle, message: AppConstants.errorMessageNetwork, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: AppConstants.errorAlertButton, style: UIAlertAction.Style.default, handler: nil))
        
         DispatchQueue.main.async() {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //For handling data related error
    @objc func onDataError(_ notification:Notification) {
        let alert = UIAlertController(title: AppConstants.errorAlertTitle, message: AppConstants.errorMessageData, preferredStyle: .alert)
               
               alert.addAction(UIAlertAction(title: AppConstants.errorAlertButton, style: UIAlertAction.Style.default, handler: nil))
               
                DispatchQueue.main.async() {
                   self.present(alert, animated: true, completion: nil)
               }
    }

   
    // MARK: - Data for tableview
    
    // It brings the app related data
    func getData(refersh:Bool) {
        //Show spinner
        if (refersh == false){
            self.showSpinner(onView: self.view)
        }
        
        GetAppCatalog.GetListOfApps { Entries in
             self.apps=Entries;
             self.appsOriginal=Entries;
             DispatchQueue.main.async() {
                self.view.endEditing(true)
                // if pull to refresh is enabled stop it
                if refersh {
                    self.refreshControl?.endRefreshing()
                }
                else {
                //Hide Spinner
                self.removeSpinner()
                }
                //reload the table view
                self.tblViewiOSAppFilterResults.reloadData()
             }
         };
    }
    
    // It filters the data based on searcy key
    func filter(searchKey:String) -> () {
        if segmentControlTopApps.selectedSegmentIndex == 0 {
            apps = self.appsOriginal?.filter({$0.imName.label.localizedCaseInsensitiveContains(searchKey)})
        }
        else{
            apps = self.appsOriginal?.filter({$0.category.attributes.label.localizedCaseInsensitiveContains(searchKey)})
        }
        self.tblViewiOSAppFilterResults.reloadData()
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
        if let key = searchBar.text {
            self.filter(searchKey: key)
            searchBar.resignFirstResponder()
        }
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
        // Bringing the customised cell
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.customTableViewCellId, for: indexPath) as! AppDetailTableViewCell
        
        // Bring the data for the particular index
        let appMeta:Entry? = self.apps?[indexPath.row]
        
        // Setting app name
        cell.lblAppName!.text = appMeta?.imName.label

        // Setting placeholder image for lazing loading of images
        let placeholderImage: UIImage = UIImage(named: AppConstants.lazyLoadingDefaultImageName)!
        
        cell.imgAppIcon.image = placeholderImage

        // Download the image
        cell.imgAppIcon.downloadImageFrom(link: appMeta?.imImage[0].label, contentMode: UIView.ContentMode.scaleAspectFit)
        // Dark mode support
        if traitCollection.userInterfaceStyle == .dark {
          cell.lblAppName.backgroundColor = .black
        } else {
          cell.lblAppName.backgroundColor = .white
          cell.backgroundColor = .white
        }
    
        return cell
    }

}
