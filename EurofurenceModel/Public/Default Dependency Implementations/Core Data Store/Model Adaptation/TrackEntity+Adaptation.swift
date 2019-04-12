import Foundation

extension TrackEntity: EntityAdapting {

    typealias AdaptedType = TrackCharacteristics

    static func makeIdentifyingPredicate(for model: TrackCharacteristics) -> NSPredicate {
        return NSPredicate(format: "identifier == %@", model.identifier)
    }

    func asAdaptedType() -> TrackCharacteristics {
        return TrackCharacteristics(identifier: identifier!, name: name!)
    }

    func consumeAttributes(from value: TrackCharacteristics) {
        identifier = value.identifier
        name = value.name
    }

}
