import Foundation

struct ImagesCache: EventConsumer {

    // MARK: Properties

    private let imageRepository: ImageRepository

    // MARK: Initialization

    init(eventBus: EventBus, imageRepository: ImageRepository) {
        self.imageRepository = imageRepository
        eventBus.subscribe(consumer: self)
    }

    // MARK: Functions

    func cachedImageData(for identifier: String) -> Data? {
        return imageRepository.loadImage(identifier: identifier)?.pngImageData
    }

    func deleteImage(identifier: String) {
        imageRepository.deleteEntity(identifier: identifier)
    }

    // MARK: EventConsumer

    func consume(event: ImageDownloadedEvent) {
        let entity = ImageEntity(identifier: event.identifier, pngImageData: event.pngImageData)
        imageRepository.save(entity)
    }

}
