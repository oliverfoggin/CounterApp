public struct NumberFact: Decodable, Equatable {
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
