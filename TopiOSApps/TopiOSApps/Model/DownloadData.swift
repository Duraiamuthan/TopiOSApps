//
//  Download.swift
//  AppCatalog
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import Foundation

class DownloadData: NSObject {
    
    //gets JSON data
    static func getData(completion:@escaping (Data?) -> ()) {
        let url = URL(string:AppConstants.dataURL)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            if(error != nil){
               let documentsData = DownloadData.getDataDocumentsDirectory()
                let bundleData = DownloadData.getDataBundle()
                if(documentsData != nil){
                    completion(documentsData)
                }
                else if(bundleData != nil){
                    completion(bundleData)
                }
                else{
                    completion(nil);
                }
           }else{
                DownloadData .saveToJsonFile(jsonData: data!);
                completion(data);
            }
       }
       task.resume()
    }
    
    // Gets JSON data from application bundle
    static func getDataBundle() -> Data?{

        if let path = Bundle.main.path(forResource: "topApps", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return data
              } catch {
                return nil
            }
        }
        return nil
    }
    
    // Gets JSON data from Document directory(Sandbox)
    static func getDataDocumentsDirectory() -> Data?{

        // Get the url of Persons.json in document directory
        let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileUrl = documentDirectoryUrl?.appendingPathComponent("topApps.json") as NSURL?
                do {
                    let data = try Data(contentsOf: fileUrl as! URL, options: .mappedIfSafe)
                   return data
                 } catch {
                   return nil
               }
      }
 
    // Saves JSON fetched from server here
    static func saveToJsonFile(jsonData:Data){
            // Get the url of Persons.json in document directory
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = documentDirectoryUrl.appendingPathComponent("topApps.json")
            do {
                try jsonData.write(to: fileUrl, options: [])
            } catch {
                print(error)
            }
    }
}
