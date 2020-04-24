//
//  SearchResultModel.swift
//  KakaoBankTest
//
//  Created by Hwangho Kim on 2020/04/23.
//  Copyright © 2020 lge. All rights reserved.
//

import UIKit

final class SearchResult: Decodable {
    var artistId: Int?
    var trackCensoredName: String?
    var artistName: String?
    var artistViewUrl: String?
    var artworkUrl100: String?
    var artworkUrl512: String?
    var artworkUrl60: String?
    var averageUserRating: Double?
    var averageUserRatingForCurrentVersion: Double?
    var contentAdvisoryRating: String?
    var description: String?
    var currentVersionReleaseDate: String?
    var genres: [String]?
    var primaryGenreName: String?
    var releaseDate: String?
    var releaseNotes: String?
    var screenshotUrls: [String]?
    var sellerName: String?
    var sellerUrl: String?
    var supportedDevices: [String]?
    var trackContentRating: String?
    var version: String?
    var userRatingCount: Int?
    var userRatingCountForCurrentVersion: Int?

    convenience init(from decoder: Decoder) throws {
        self.init()

        enum DecodingKey: String, CodingKey {
            case artistId
            case artistName
            case artistViewUrl
            case trackCensoredName
            case artworkUrl100
            case artworkUrl512
            case artworkUrl60
            case averageUserRating
            case averageUserRatingForCurrentVersion
            case contentAdvisoryRating
            case description
            case currentVersionReleaseDate
            case genres
            case primaryGenreName
            case releaseDate
            case releaseNotes
            case screenshotUrls
            case sellerName
            case sellerUrl
            case supportedDevices
            case trackContentRating
            case version
            case userRatingCount
            case userRatingCountForCurrentVersion
        }

        do {
            let container = try decoder.container(keyedBy: DecodingKey.self)
            self.trackCensoredName = try container.decodeIfPresent(String.self, forKey: .trackCensoredName)
            self.artistId = try container.decodeIfPresent(Int.self, forKey: .artistId)
            self.artistName = try container.decodeIfPresent(String.self, forKey: .artistName)
            self.artistViewUrl = try container.decodeIfPresent(String.self, forKey: .artistViewUrl)
            self.screenshotUrls = try container.decodeIfPresent([String].self, forKey: .screenshotUrls)
            self.supportedDevices = try container.decodeIfPresent([String].self, forKey: .supportedDevices)
            self.userRatingCountForCurrentVersion = try container.decodeIfPresent(Int.self, forKey: .userRatingCountForCurrentVersion)
            self.userRatingCount = try container.decodeIfPresent(Int.self, forKey: .userRatingCount)
            self.trackContentRating = try container.decodeIfPresent(String.self, forKey: .trackContentRating)
            self.sellerUrl = try container.decodeIfPresent(String.self, forKey: .sellerUrl)
            self.sellerName = try container.decodeIfPresent(String.self, forKey: .sellerName)
            self.releaseNotes = try container.decodeIfPresent(String.self, forKey: .releaseNotes)
            self.primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName)
            self.genres = try container.decodeIfPresent([String].self, forKey: .genres)
            self.currentVersionReleaseDate = try container.decodeIfPresent(String.self, forKey: .currentVersionReleaseDate)
            self.description = try container.decodeIfPresent(String.self, forKey: .description)
            self.contentAdvisoryRating = try container.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
            self.averageUserRatingForCurrentVersion = try container.decodeIfPresent(Double.self, forKey: .averageUserRatingForCurrentVersion)
            self.averageUserRating = try container.decodeIfPresent(Double.self, forKey: .averageUserRating)
            self.artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60)
            self.artworkUrl512 = try container.decodeIfPresent(String.self, forKey: .artworkUrl512)
            self.artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100)

        } catch {
            print(error)
        }
    }
}

final class SearchResultModel: Decodable {

    var resultCount: Int = 0
    var results: [SearchResult]?

    convenience init(from decoder: Decoder) throws {
        self.init()

        enum DecodingKey: String, CodingKey {
            case resultCount
            case results
        }

        do {
            let container = try decoder.container(keyedBy: DecodingKey.self)
            self.resultCount = try container.decode(Int.self, forKey: .resultCount)
            self.results = try container.decodeIfPresent([SearchResult].self, forKey: .results)
        } catch {
            print(error)
        }
    }
}
