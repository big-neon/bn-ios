
import UIKit
import CoreData
import Foundation

extension Film {

//    @NSManaged var director: String
//    @NSManaged var episodeId: NSNumber
//    @NSManaged var openingCrawl: String
//    @NSManaged var producer: String
//    @NSManaged var releaseDate: Date
//    @NSManaged var title: String

    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd"
        return df
    }()

    public func update(with jsonDictionary: [String: Any]) throws {
        guard let director = jsonDictionary["director"] as? String,
            let episodeId = jsonDictionary["episode_id"] as? Int,
            let openingCrawl = jsonDictionary["opening_crawl"] as? String,
            let producer = jsonDictionary["producer"] as? String,
            let releaseDate = jsonDictionary["release_date"] as? String,
            let title = jsonDictionary["title"] as? String
            else {
                throw NSError(domain: "", code: 100, userInfo: nil)
        }

        self.director = director
        self.episodeId = Int32.init(exactly: NSNumber(value: episodeId)) //  (value: Int(episodeId))
        self.openingCrawl = openingCrawl
        self.producer = producer
        self.releaseDate = Film.dateFormatter.date(from: releaseDate)! //    ?? Date(timeIntervalSince1970: 0)
        self.title = title
    }

}


