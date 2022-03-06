//
//  FirebaseAnalytics.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation
import CasePaths
import ComposableArchitecture
import FirebaseAnalytics

struct Event {
	let name: String
	let parameters: [String: Any]?

	static func screenView(screenName: String, screenClass: String = "") -> Self {
		.init(name: AnalyticsEventScreenView, parameters: [
			AnalyticsParameterScreenName: screenName,
			AnalyticsParameterScreenClass: screenClass
		])
	}
}

protocol AnalyticsAction {
	var event: Event { get }
}

extension AnalyticsAction {
	var event: Event {
		.init(name: "\(self)", parameters: nil)
	}
}

extension Reducer where Action: AnalyticsAction {
	func firebaseAnalytics() -> Reducer {
		return .init { state, action, environment in
			let effects = self.run(&state, action, environment)

			return .merge(
				.fireAndForget {
					Analytics.logEvent(action.event.name, parameters: action.event.parameters)
				},
				effects
			)
		}
	}
}
