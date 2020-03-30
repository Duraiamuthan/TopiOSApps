//
//  AppDetailViewController.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import UIKit

class AppDetailViewController: UIViewController {

   var detailText: String?=nil
   @IBOutlet weak var textVuAppDetail: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // title name
        self.navigationItem.title=AppConstants.secondaryViewControllerTitle
        // setting content of label
        textVuAppDetail.text=detailText
        // Do any additional setup after loading the view.
    }

}
