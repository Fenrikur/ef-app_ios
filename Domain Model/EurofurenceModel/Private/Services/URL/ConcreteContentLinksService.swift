import EventBus
import Foundation

class ConcreteContentLinksService: ContentLinksService, EventConsumer {

    private let urlOpener: URLOpener?
    private let urlEntityProcessor: URLEntityProcessor

    init(eventBus: EventBus, urlOpener: URLOpener?, urlEntityProcessor: URLEntityProcessor) {
        self.urlOpener = urlOpener
        self.urlEntityProcessor = urlEntityProcessor
        
        eventBus.subscribe(consumer: self)
    }

    func consume(event: DomainEvent.OpenURL) {
        urlOpener?.open(event.url)
    }

    func lookupContent(for link: Link) -> LinkContentLookupResult? {
        guard let urlString = link.contents as? String, let url = URL(string: urlString) else { return nil }

        if let scheme = url.scheme, scheme == "https" || scheme == "http" {
            return .web(url)
        }

        return .externalURL(url)
    }
    
    func describeContent(in url: URL, toVisitor visitor: URLContentVisitor) {
        urlEntityProcessor.process(url, visitor: visitor)
    }

}