@testable import Eurofurence
import EurofurenceModel
import EurofurenceModelTestDoubles

class EventDetailInteractorTestBuilder {

    struct Context {
        var event: Event
        var dateRangeFormatter: FakeDateRangeFormatter
        var interactor: DefaultEventDetailInteractor
        var viewModel: EventDetailViewModel
        var eventsService: FakeEventsService
		var markdownRenderer: StubMarkdownRenderer
    }

    private var eventsService: FakeEventsService

    init() {
        eventsService = FakeEventsService()
    }

    @discardableResult
    func with(_ eventsService: FakeEventsService) -> EventDetailInteractorTestBuilder {
        self.eventsService = eventsService
        return self
    }

    func build(for event: Event = FakeEvent.randomStandardEvent) -> Context {
        let dateRangeFormatter = FakeDateRangeFormatter()
		let markdownRenderer = StubMarkdownRenderer()
        eventsService.events = [event]
		let interactor = DefaultEventDetailInteractor(dateRangeFormatter: dateRangeFormatter, eventsService: eventsService, markdownRenderer: markdownRenderer)
        var viewModel: EventDetailViewModel!
        interactor.makeViewModel(for: event.identifier) { viewModel = $0 }
        
        assert(viewModel != nil)

        return Context(event: event,
                       dateRangeFormatter: dateRangeFormatter,
                       interactor: interactor,
                       viewModel: viewModel,
                       eventsService: eventsService,
					   markdownRenderer: markdownRenderer)
    }

}

extension EventDetailInteractorTestBuilder.Context {

    func makeExpectedEventSummaryViewModel() -> EventSummaryViewModel {
        return EventSummaryViewModel(title: event.title,
                                     subtitle: event.subtitle,
                                     abstract: markdownRenderer.stubbedContents(for: event.abstract),
                                     eventStartEndTime: dateRangeFormatter.string(from: event.startDate, to: event.endDate),
                                     location: event.room.name,
                                     trackName: event.track.name,
                                     eventHosts: event.hosts)
    }

    func makeExpectedEventGraphicViewModel() -> EventGraphicViewModel {
        guard let data = event.posterGraphicPNGData ?? event.bannerGraphicPNGData else {
            fatalError("Event used in test isn't stubbed with image data")
        }

        return EventGraphicViewModel(pngGraphicData: data)
    }

    func makeExpectedEventDescriptionViewModel() -> EventDescriptionViewModel {
        return EventDescriptionViewModel(contents: markdownRenderer.stubbedContents(for: event.eventDescription))
    }
    
    func prepareVisitorForTesting() -> CapturingEventDetailViewModelVisitor {
        let visitor = CapturingEventDetailViewModelVisitor()
        visitor.consume(contentsOf: viewModel)
        
        return visitor
    }

}
