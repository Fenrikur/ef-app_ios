//
//  DealerImpl.swift
//  EurofurenceModel
//
//  Created by Thomas Sherwood on 15/02/2019.
//  Copyright © 2019 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

struct DealerImpl: Dealer {
    
    private let eventBus: EventBus
    private let dataStore: DataStore
    private let imageCache: ImagesCache
    private let mapCoordinateRender: MapCoordinateRender?

    var identifier: DealerIdentifier

    var preferredName: String
    var alternateName: String?

    var isAttendingOnThursday: Bool
    var isAttendingOnFriday: Bool
    var isAttendingOnSaturday: Bool

    var isAfterDark: Bool

    init(eventBus: EventBus,
         dataStore: DataStore,
         imageCache: ImagesCache,
         mapCoordinateRender: MapCoordinateRender?,
         identifier: DealerIdentifier,
         preferredName: String,
         alternateName: String?,
         isAttendingOnThursday: Bool,
         isAttendingOnFriday: Bool,
         isAttendingOnSaturday: Bool,
         isAfterDark: Bool) {
        self.eventBus = eventBus
        self.dataStore = dataStore
        self.imageCache = imageCache
        self.mapCoordinateRender = mapCoordinateRender
        
        self.identifier = identifier
        self.preferredName = preferredName
        self.alternateName = alternateName
        self.isAttendingOnThursday = isAttendingOnThursday
        self.isAttendingOnFriday = isAttendingOnFriday
        self.isAttendingOnSaturday = isAttendingOnSaturday
        self.isAfterDark = isAfterDark
    }
    
    func openWebsite() {
        guard let model = dataStore.fetchDealers()?.first(where: { $0.identifier == identifier.rawValue }) else { return }
        guard let externalLink = model.links?.first(where: { $0.fragmentType == .WebExternal }) else { return }
        guard let url = URL(string: externalLink.target) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func openTwitter() {
        guard let model = dataStore.fetchDealers()?.first(where: { $0.identifier == identifier.rawValue }),
              model.twitterHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://twitter.com/")?.appendingPathComponent(model.twitterHandle) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func openTelegram() {
        guard let model = dataStore.fetchDealers()?.first(where: { $0.identifier == identifier.rawValue }),
              model.telegramHandle.isEmpty == false else { return }
        guard let url = URL(string: "https://t.me/")?.appendingPathComponent(model.twitterHandle) else { return }
        
        eventBus.post(DomainEvent.OpenURL(url: url))
    }
    
    func fetchExtendedDealerData(completionHandler: @escaping (ExtendedDealerData) -> Void) {
        guard let model = dataStore.fetchDealers()?.first(where: { $0.identifier == identifier.rawValue }) else { return }
        
        var dealerMapLocationData: Data?
        if let (map, entry) = fetchMapData(), let mapData = imageCache.cachedImageData(for: map.imageIdentifier) {
            dealerMapLocationData = mapCoordinateRender?.render(x: entry.x, y: entry.y, radius: entry.tapRadius, onto: mapData)
        }
        
        var artistImagePNGData: Data?
        if let artistImageId = model.artistImageId {
            artistImagePNGData = imageCache.cachedImageData(for: artistImageId)
        }
        
        var artPreviewImagePNGData: Data?
        if let artPreviewImageId = model.artPreviewImageId {
            artPreviewImagePNGData = imageCache.cachedImageData(for: artPreviewImageId)
        }
        
        let convertEmptyStringsIntoNil: (String) -> String? = { $0.isEmpty ? nil : $0 }
        
        let extendedData = ExtendedDealerData(artistImagePNGData: artistImagePNGData,
                                              dealersDenMapLocationGraphicPNGData: dealerMapLocationData,
                                              preferredName: preferredName,
                                              alternateName: alternateName,
                                              categories: model.categories.sorted(),
                                              dealerShortDescription: model.shortDescription,
                                              isAttendingOnThursday: isAttendingOnThursday,
                                              isAttendingOnFriday: isAttendingOnFriday,
                                              isAttendingOnSaturday: isAttendingOnSaturday,
                                              isAfterDark: model.isAfterDark,
                                              websiteName: model.links?.first(where: { $0.fragmentType == .WebExternal })?.target,
                                              twitterUsername: convertEmptyStringsIntoNil(model.twitterHandle),
                                              telegramUsername: convertEmptyStringsIntoNil(model.telegramHandle),
                                              aboutTheArtist: convertEmptyStringsIntoNil(model.aboutTheArtistText),
                                              aboutTheArt: convertEmptyStringsIntoNil(model.aboutTheArtText),
                                              artPreviewImagePNGData: artPreviewImagePNGData,
                                              artPreviewCaption: convertEmptyStringsIntoNil(model.artPreviewCaption))
        completionHandler(extendedData)
    }
    
    func fetchIconPNGData(completionHandler: @escaping (Data?) -> Void) {
        guard let model = dataStore.fetchDealers()?.first(where: { $0.identifier == identifier.rawValue }) else { return }
        
        var iconData: Data?
        if let iconIdentifier = model.artistThumbnailImageId {
            iconData = imageCache.cachedImageData(for: iconIdentifier)
        }
        
        completionHandler(iconData)
    }
    
    private func fetchMapData() -> (map: MapCharacteristics, entry: MapCharacteristics.Entry)? {
        guard let maps = dataStore.fetchMaps() else { return nil }
        
        for map in maps {
            guard let entry = map.entries.first(where: { (entry) -> Bool in
                return entry.links.contains(where: { $0.target == identifier.rawValue })
            }) else { continue }
            
            return (map: map, entry: entry)
        }
        
        return nil
    }

}
