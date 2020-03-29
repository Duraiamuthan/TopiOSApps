//
//  ViewController.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var searchBariOSAppFilter: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         searchBariOSAppFilter.delegate=self
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("search buton clicked:\(String(describing: searchBar.text))")
    }

}

