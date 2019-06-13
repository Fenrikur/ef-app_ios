public typealias KnowledgeEntryIdentifier = Identifier<KnowledgeEntry>

public struct KnowledgeEntry {

    public var identifier: KnowledgeEntryIdentifier
    public var title: String
    public var order: Int
    public var contents: String
    public var links: [Link]

    public init(identifier: KnowledgeEntryIdentifier, title: String, order: Int, contents: String, links: [Link]) {
        self.identifier = identifier
        self.title = title
        self.order = order
        self.contents = contents
        self.links = links
    }

}

extension KnowledgeEntry {

    static func fromServerModel(_ entry: KnowledgeEntryCharacteristics) -> KnowledgeEntry {
        let links: [Link] = Link.fromServerModels(entry.links)

        return KnowledgeEntry(identifier: KnowledgeEntryIdentifier(entry.identifier),
                              title: entry.title,
                              order: entry.order,
                              contents: entry.text,
                              links: links)
    }

}