//
//  AppConstants.swift
//  TopiOSApps
//
//  Created by duraiamuthan harikrishnan on 30/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import Foundation

struct AppConstants {
    static let dataURL = "https://itunes.apple.com/us/rss/toppaidapplications/limit=200/json"
    static let rootViewControllerTitle = "Top iOS Apps"
    static let secondaryViewControllerTitle = "App Details"
    static let segmentOneName = "App name"
    static let segmentSecondName = "App category"
    static let searchPlaceHolderOne = "Look up using app name"
    static let searchPlaceHolderTwo = "Look up using category name"
    static let searchPlaceHolderDefault = "Look up"
    static let customTableViewCellId = "AppDetailTableViewCell"
    static let lazyLoadingDefaultImageName = "ImageLazyLoadingPlaceHolder"
    static let errorFetchingServerDataNotificationName = "ErrorFetchingServerData"
    static let errorWithDataNotificationName = "ErrorWithServerData"
    static let errorAlertTitle = "Error"
    static let errorMessageNetwork = "There seems to be some issue getting the data from server so data is loaded from local cache"
    static let errorMessageData = "There seems to be some problem with Data retrieved. Please contact administrator."
    static let errorAlertButton = "Ok"
}
