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
            imageContentHashSha1 = characteristics.contentHashSha1.base64EncodedString
        }
    }

    func downloadImages(
        requests: [DownloadRequest],
        parentProgress: Progress,
        completionHandler: @escaping () -> Void
    ) {
        guard !requests.isEmpty else {
            completionHandler()
            return
        }

        var pendingImageIdentifiers = requests

        for request in requests {
            let identifier = request.imageIdentifier
            let sha1 = request.imageContentHashSha1
            
            api.fetchImage(identifier: identifier, contentHashSha1: sha1) { (data) in
                guard let idx = pendingImageIdentifiers.firstIndex(of: request) else { return }
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
