import XCTest
import ComposableArchitecture
import Services
@testable import NumberCore

class NumberAppTCATests: XCTestCase {
	func testStuff() {
		var numberClient = NumberClient.failing

		let numberFact = NumberFact(
			text: "This is an interesting number",
			number: 10,
			found: true,
			type: .trivia
		)

		numberClient.getFact = { _ in
			.init(value: numberFact)
		}

		let store = TestStore(
			initialState: NumberState(),
			reducer: numberReducer,
			environment: .init(
				numberClient: numberClient,
				main: .immediate
			)
		)

		store.send(.incrementTapped) {
			$0.number = 1
		}

		store.send(.decrementTapped) {
			$0.number = 0
		}

		store.send(.getFactTapped) {
			$0.numberFact = .loading
		}

		store.receive(.factReceived(.success(numberFact))) {
			$0.numberFact = .success(numberFact)
		}
	}
}
