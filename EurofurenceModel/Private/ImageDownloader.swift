//
//  ImageDownloader.swift
//  Eurofurence
//
//  Created by Thomas Sherwood on 10/06/2018.
//  Copyright © 2018 Eurofurence. All rights reserved.
//

import EventBus
import Foundation

class ImageDownloader {

    private let eventBus: EventBus
    private let api: API
    private let imageRepository: ImageRepository

    init(eventBus: EventBus, api: API, imageRepository: ImageRepository) {
        self.eventBus = eventBus
        self.api = api
        self.imageRepository = imageRepository
    }
    
    struct DownloadRequest: Equatable {
        var imageIdentifier: String
        var imageContentHashSha1: String
        
        init(characteristics: ImageCharacteristics) {
            imageIdentifier = characteristics.identifier
            imageContentHashSha1 = characteristics.contentHashSha1
        }
    }

    func downloadImages(requests: [DownloadRequest], parentProgress: Progress, completionHandler: @escaping () -> Void) {
        guard !requests.isEmpty else {
            completionHandler()
            return
        }

        var pendingImageIdentifiers = requests
        let imagesToDownload = pendingImageIdentifiers

        guard !imagesToDownload.isEmpty else {
            parentProgress.totalUnitCount = 1
            parentProgress.completedUnitCount = 1
            completionHandler()
            return
        }

        imagesToDownload.forEach { (request) in
            api.fetchImage(identifier: request.imageIdentifier, contentHashSha1: request.imageContentHashSha1) { (data) in
                guard let idx = pendingImageIdentifiers.index(of: request) else { return }
                pendingImageIdentifiers.remove(at: idx)

                var completedUnitCount = parentProgress.completedUnitCount
                completedUnitCount += 1
                parentProgress.completedUnitCount = completedUnitCount

                if let data = data {
                    let event = ImageDownloadedEvent(identifier: request.imageIdentifier, pngImageData: data)
                    self.eventBus.post(event)
                }

                if pendingImageIdentifiers.isEmpty {
                    completionHandler()
                }
            }
        }
    }

}
