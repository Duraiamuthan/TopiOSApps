//
//  jsonModelClass.swift
//  AppCatalog
//
//  Created by duraiamuthan harikrishnan on 29/03/2020.
//  Copyright © 2020 duraiamuthan harikrishnan. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct AppCatalogJSONResponseModel: Codable {
    let feed: Feed
}

// MARK: - Feed
struct Feed: Codable {
    let entry: [Entry]
}

// MARK: - Icon
struct PlainText: Codable {
    let label: String
}

// MARK: - Entry
struct Entry: Codable {
    let imName: PlainText
    let imImage: [ImageMeta]
    let summary: PlainText
    let category: Category

    enum CodingKeys: String, CodingKey {
        case imName = "im:name"
        case imImage = "im:image"
        case summary
        case category
    }
}

// MARK: - ImageMeta
struct ImageMeta: Codable {
    let label: String
    let attributes: ImageMetaAttributes
}

// MARK: - IMImageAttributes
struct ImageMetaAttributes: Codable {
    let height: String
}

// MARK: - Category
struct Category: Codable {
    let attributes: CategoryAttributes
}

// MARK: - CategoryAttributes
struct CategoryAttributes: Codable {
    let imID, term: String
    let scheme: String
    let label: String

    enum CodingKeys: String, CodingKey {
        case imID = "im:id"
        case term, scheme, label
    }
}
