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
                    guard let dataApps = Data else{
                        let nc = NotificationCenter.default
                        nc.post(name: Notification.Name(AppConstants.errorFetchingServerDataNotificationName), object: nil)
                        completion(nil)
                        return
                    }
                    let model =  try JSONDecoder().decode(AppCatalogJSONResponseModel.self, from: dataApps)
                    completion(model.feed.entry)
                 }
                 catch{
                    // Send notification for data error
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name(AppConstants.errorWithDataNotificationName), object: nil)
                    
                    completion(nil)
                 }
             };
    }
}
