//
//  GetAppCatalog.swift
//  AppCatalog
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import Foundation

class GetAppCatalog: NSObject {
    
    // Gets List of apps from json
    static func GetListOfApps(completion:@escaping ([Entry]?) -> ()) {
        DownloadData.getData { (Data) in
                 do{
                            if Data != nil{
                             let model =  try JSONDecoder().decode(AppCatalogJSONResponseModel.self, from: Data!)
                                completion(model.feed.entry)
                            }
                 }
                 catch{
                    completion(nil)
                 }
             };
    }
}
