public struct NumberFact: Decodable, Equatable {
	public enum FactType: String, Decodable {
		case trivia
		case math
		case date
		case year
	}

	public let text: String
	public let number: Int
	public let found: Bool
	public let type: FactType
	
	public init(text: String, number: Int, found: Bool, type: NumberFact.FactType) {
		self.text = text
		self.number = number
		self.found = found
		self.type = type
	}
}
