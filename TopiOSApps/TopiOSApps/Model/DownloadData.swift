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
    static func getData(completionSuccessHandler:@escaping (Data?) -> (),completionErrorHandler:@escaping(NSError?) -> ()){
        let url = URL(string:AppConstants.dataURL)
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            guard error != nil else{
                DownloadData .saveToJsonFile(jsonData: data!);
                completionSuccessHandler(data);
                return
            }
               
                
                // latest copy of data stored in Documents directory
                if let documentsData = DownloadData.getDataDocumentsDirectory() {
                    completionSuccessHandler(documentsData)
                }
                // Backup copy from app bundle
                else if let bundleData = DownloadData.getDataBundle() {
                    completionSuccessHandler(bundleData)
                }
                completionErrorHandler(error as NSError?)
       }
       task.resume()
    }
    
    // Gets JSON data from application bundle
    static func getDataBundle() -> Data?{

        if let path = Bundle.main.path(forResource: AppConstants.jsonbackupCopyName, ofType: AppConstants.dataBackupExtension) {
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
        let fileUrl = documentDirectoryUrl?.appendingPathComponent(AppConstants.jsonbackupCopyName+"."+AppConstants.dataBackupExtension) as NSURL?
                do {
                    let data = try Data(contentsOf: fileUrl! as URL, options: .mappedIfSafe)
                   return data
                 } catch {
                   return nil
               }
      }
 
    // Saves JSON fetched from server here
    static func saveToJsonFile(jsonData:Data){
            // Get the url of Persons.json in document directory
            guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileUrl = documentDirectoryUrl.appendingPathComponent(AppConstants.jsonbackupCopyName+"."+AppConstants.dataBackupExtension)
            do {
                try jsonData.write(to: fileUrl, options: [])
            } catch {
                print(error)
            }
    }
}
