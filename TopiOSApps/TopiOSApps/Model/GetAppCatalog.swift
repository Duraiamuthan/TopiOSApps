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
    static func GetListOfApps(completionSuccessHandler:@escaping ([Entry]?) -> (),completionErrorHandler:@escaping (Error?) -> ()) {
        DownloadData.getData(completionSuccessHandler: { (Data) in
                            do{
                               guard let dataApps = Data else{
                                   completionErrorHandler(nil)
                                   return
                               }
                               let model =  try JSONDecoder().decode(AppCatalogJSONResponseModel.self, from: dataApps)
                               completionSuccessHandler(model.feed.entry)
                            }
                            catch{
                             completionErrorHandler(nil)
                            }
            
        }) {(Error) in
            completionErrorHandler(Error);
        }
    }
}
