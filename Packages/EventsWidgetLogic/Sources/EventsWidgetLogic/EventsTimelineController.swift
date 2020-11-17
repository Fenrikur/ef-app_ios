import Foundation.NSDate

public struct EventsTimelineController {
    
    private let repository: EventRepository
    private let viewModelFactory: EventViewModelFactory
    
    public init(repository: EventRepository, eventTimeFormatter: EventTimeFormatter) {
        self.repository = repository
        viewModelFactory = EventViewModelFactory(eventTimeFormatter: eventTimeFormatter)
    }
    
}

// MARK: - Timeline

public struct EventsTimeline: Equatable {
    
    public var entries: [EventTimelineEntry]
    
    public var snapshot: EventTimelineEntry {
        entries.first ?? EventTimelineEntry(date: Date(), events: [], additionalEventsCount: 0)
    }
    
    public init(entries: [EventTimelineEntry]) {
        self.entries = entries
    }
    
}

extension EventsTimelineController {
    
    public struct TimelineOptions {
        
        let maximumEventsPerEntry: Int
        let timelineStartDate: Date
        
        public init(maximumEventsPerEntry: Int, timelineStartDate: Date) {
            self.maximumEventsPerEntry = maximumEventsPerEntry
            self.timelineStartDate = timelineStartDate
        }
        
    }
    
    public func makeTimeline(options: TimelineOptions, completionHandler: @escaping (EventsTimeline) -> Void) {
        ResolveTimelineEntriesTask(
            repository: repository,
            maximumEventsPerEntry: options.maximumEventsPerEntry,
            timelineStartDate: options.timelineStartDate,
            viewModelFactory: viewModelFactory,
            completionHandler: completionHandler
        ).resolveEntries()
    }
    
}
