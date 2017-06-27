//
//  NavigationResolver.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation

class NavigationResolver: INavigationResolver {
	func resolve(dataContext: IDataContext) {
		// TODO: Resolve links to MapEntry
		print("\(#function): Resolving Dealers")
		dataContext.Dealers.modify({ value in
			for e in value {
				e.ArtistImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistImageId })
				e.ArtistThumbnailImage = dataContext.Images.value.first(where: { $0.Id == e.ArtistThumbnailImageId })
				e.ArtPreviewImage = dataContext.Images.value.first(where: { $0.Id == e.ArtPreviewImageId })
			}
		})
		
		print("\(#function): Resolving EventConferenceDays")
		dataContext.EventConferenceDays.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving EventConferenceRooms")
		dataContext.EventConferenceRooms.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving EventConferenceTracks")
		dataContext.EventConferenceTracks.modify({ value in
			for e in value {
				e.Events.removeAll()
			}
		})
		print("\(#function): Resolving Events")
		dataContext.Events.modify({ value in
			for e in value {
				e.ConferenceDay = dataContext.EventConferenceDays.value.first(where: { $0.Id == e.ConferenceDayId })
				e.ConferenceRoom = dataContext.EventConferenceRooms.value.first(where: { $0.Id == e.ConferenceRoomId })
				e.ConferenceTrack = dataContext.EventConferenceTracks.value.first(where: { $0.Id == e.ConferenceTrackId })

				e.ConferenceDay?.Events.append(e)
				e.ConferenceRoom?.Events.append(e)
				e.ConferenceTrack?.Events.append(e)
			}
		})

		
		print("\(#function): Resolving KnowledgeGroups")
		dataContext.KnowledgeGroups.modify({ value in
			for e in value {
				e.KnowledgeEntries.removeAll()
			}
		})
		print("\(#function): Resolving KnowledgeEntries")
		dataContext.KnowledgeEntries.modify({ value in
			for e in value {
				e.KnowledgeGroup = dataContext.KnowledgeGroups.value.first(where: { $0.Id == e.KnowledgeGroupId })
				e.KnowledgeGroup?.KnowledgeEntries.append(e)
			}
		})
		
		print("\(#function): Resolving Maps")
		dataContext.Maps.modify({ value in
			for e in value {
				e.Image = dataContext.Images.value.first(where: { $0.Id == e.ImageId })

				for mapEntry in e.Entries {
					mapEntry.Map = e
				}
			}
		})
	}
}
