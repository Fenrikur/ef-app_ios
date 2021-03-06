public struct ContextualCommands {
    
    private let commands: [ContextualCommand]
    
    public init(commands: [ContextualCommand]) {
        self.commands = commands
    }
    
    public func command(titled title: String) -> ContextualCommand? {
        commands.first(where: { $0.title == title })
    }
    
    public func map<T>(_ transform: (ContextualCommand) -> T) -> [T] {
        commands.map(transform)
    }
    
}
