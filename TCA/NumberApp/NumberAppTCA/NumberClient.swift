//
//  NumberClient.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation
import ComposableArchitecture

struct NumberClient {
	var getFact: (_ number: Int) -> Effect<NumberFact?, Never>
	var getRandomNumber: () -> Effect<Int?, Never>
}

extension NumberClient {
	static var live: Self = .init(
		getFact: { number in
			Effect.task {
				do {
					let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)?json")!)
					return try JSONDecoder().decode(NumberFact.self, from: data)
				}
				catch {
					return nil
				}
			}
			.eraseToEffect()
		},
		getRandomNumber: {
			Effect.task {
				do {
					let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/random?json")!)
					let fact = try JSONDecoder().decode(NumberFact.self, from: data)
					return fact.number
				}
				catch {
					return nil
				}
			}
			.eraseToEffect()
		}
	)
}

#if DEBUG
	extension NumberClient {
		public static let failing = Self(
			getFact: { _ in .failing("NumberClient.getFact") },
			getRandomNumber: { .failing("NumberClient.getRandomNumber") }
		)
	}
#endif
