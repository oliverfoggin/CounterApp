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

public struct Event {
	let name: String
	let parameters: [String: Any]?

	public init(
		name: String,
		parameters: [String: Any]?
	) {
		self.name = name
		self.parameters = parameters
	}

	public static func screenView(screenName: String, screenClass: String = "") -> Self {
		.init(name: AnalyticsEventScreenView, parameters: [
			AnalyticsParameterScreenName: screenName,
			AnalyticsParameterScreenClass: screenClass
		])
	}
}

public protocol AnalyticsAction {
	var event: Event { get }
}

public extension AnalyticsAction {
	var event: Event {
		.init(name: "\(self)", parameters: nil)
	}
}

public extension Reducer where Action: AnalyticsAction {
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
