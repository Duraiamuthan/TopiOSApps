//
//  ImageExtension.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 30/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // Help in lazy loading
    func downloadImageFrom(link:String!, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
