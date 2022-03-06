//
//  ContentViewModel.swift
//  NumberAppVanilla
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation

enum Remote<T> {
	case notAsked
	case loading
	case success(T)
	case failed
}

class ViewModel: ObservableObject {
	@Published var number: Int
	let numbersAPI: NumbersAPIType
	@Published var numberFact: Remote<NumberFact> = .notAsked
	let analytics: AnalyticsProviderType

	init(
		number: Int = 0,
		numbersAPI: NumbersAPIType = NumbersAPI(),
		analytics: AnalyticsProviderType = FirebaseAnalyticsProvider()
	) {
		self.number = number
		self.numbersAPI = numbersAPI
		self.analytics = analytics
	}

	func increment() {
		analytics.trackEvent(event: "increment_tapped")
		number += 1
	}

	func decrement() {
		analytics.trackEvent(event: "decrement_tapped")
		number -= 1
	}

	func getRandomNumber() {
		analytics.trackEvent(event: "get_random_number_tapped")
		numbersAPI.getRandomNumber { [weak self] number in
			DispatchQueue.main.async {
				guard let number = number else {
					return
				}

				self?.analytics.trackEvent(event: "number_received")

				self?.number = number
			}
		}
	}

	func getFact() {
		analytics.trackEvent(event: "get_fact_tapped")
		if case .loading = numberFact {
			return
		}

		numberFact = .loading
		numbersAPI.getFact(number: number) { [weak self] numberFact in
			DispatchQueue.main.async {
				guard let numberFact = numberFact else {
					self?.numberFact = .failed
					return
				}

				self?.analytics.trackEvent(event: "fact_received")

				self?.numberFact = .success(numberFact)
			}
		}
	}
}
