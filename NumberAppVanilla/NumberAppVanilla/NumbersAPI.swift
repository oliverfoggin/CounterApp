//
//  NumbersAPI.swift
//  NumberAppVanilla
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation

protocol NumbersAPIType {
	func getFact(number: Int, completion: @escaping (_ numberFact: NumberFact?) -> Void)
	func getRandomNumber(completion: @escaping (_ number: Int?) -> Void)
}

struct NumberFact: Decodable {
	enum FactType: String, Decodable {
		case trivia
		case math
		case date
		case year
	}

	let text: String
	let number: Int
	let found: Bool
	let type: FactType
}

struct NumbersAPI: NumbersAPIType {
	func getFact(number: Int, completion: @escaping (NumberFact?) -> Void) {
		guard let url = URL(string: "http://numbersapi.com/\(number)?json") else {
			completion(nil)
			return
		}

		URLSession.shared.dataTask(with: url) { data, _, _ in
			guard let data = data,
						let fact = try? JSONDecoder().decode(NumberFact.self, from: data) else {
				completion(nil)
				return
			}

			completion(fact)
		}
		.resume()
	}

	func getRandomNumber(completion: @escaping (Int?) -> Void) {
		guard let url = URL(string: "http://numbersapi.com/random?json") else {
			completion(nil)
			return
		}

		URLSession.shared.dataTask(with: url) { data, _, _ in
			guard let data = data,
						let fact = try? JSONDecoder().decode(NumberFact.self, from: data) else {
				completion(nil)
				return
			}

			completion(fact.number)
		}
		.resume()
	}
}

