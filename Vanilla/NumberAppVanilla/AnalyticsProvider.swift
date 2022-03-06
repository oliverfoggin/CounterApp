//
//  AnalyticsProvider.swift
//  NumberAppVanilla
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation
import FirebaseAnalytics

protocol AnalyticsProviderType {
	func trackEvent(event: String)
}

struct FirebaseAnalyticsProvider: AnalyticsProviderType {
	func trackEvent(event: String) {
		Analytics.logEvent(event, parameters: nil)
	}
}
