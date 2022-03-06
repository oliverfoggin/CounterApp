//
//  NumberState.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation
import ComposableArchitecture

enum Remote<T> {
	case notAsked
	case loading
	case success(T)
	case failed
}

extension Remote: Equatable where T: Equatable {}

struct NumberFact: Decodable, Equatable {
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

struct NumberState: Equatable {
	var number: Int = 0
	var numberFact: Remote<NumberFact> = .notAsked

	var factAlertState: AlertState<NumberAction>? {
		guard case let .success(fact) = numberFact else {
			return nil
		}

		return AlertState<NumberAction>(
			title: TextState("Number Fact"),
			message: TextState(fact.text),
			primaryButton: .default(TextState("OK"), action: .send(.dismissAlertTapped)),
			secondaryButton: .cancel(TextState("Cancel"), action: .send(.dismissAlertTapped))
		)
	}
}

enum NumberAction: AnalyticsAction {
	case dismissAlertTapped

	case onAppear
	case incrementTapped
	case decrementTapped
	case getRandomNumberTapped
	case randomNumberReceived(Result<Int?, Never>)
	case getFactTapped
	case factReceived(Result<NumberFact?, Never>)

	var event: Event {
		switch self {
		case let .randomNumberReceived(.success(number?)):
			return .init(name: "randomNumberReceived", parameters: ["number": number])
		case let .factReceived(.success(fact?)):
			return .init(
				name: "factReceived",
				parameters: [
					"number": fact.number,
					"fact": fact.text
				]
			)
		case .onAppear:
			return .screenView(screenName: "Number App View", screenClass: "ContentView")
		default:
			return .init(name: "\(self)", parameters: nil)
		}
	}
}

struct NumberEnvironment {
	let numberClient: NumberClient
	let main: AnySchedulerOf<DispatchQueue>
}

extension NumberEnvironment {
	static var live: Self = .init(
		numberClient: .live,
		main: .main
	)
}

let numberReducer = Reducer<NumberState, NumberAction, NumberEnvironment> {
	state, action, environment in

	struct FactRequestId: Hashable {}
	struct RandomNumberRequestId: Hashable {}

	switch action {
	case .incrementTapped:
		state.number += 1
		return .none

	case .decrementTapped:
		state.number -= 1
		return .none

	case .getRandomNumberTapped:
		return environment.numberClient.getRandomNumber()
			.receive(on: environment.main)
			.catchToEffect(NumberAction.randomNumberReceived)
			.cancellable(id: FactRequestId())

	case let .randomNumberReceived(.success(number?)):
		state.number = number
		return .none

	case .randomNumberReceived:
		return .none

	case .getFactTapped:
		state.numberFact = .loading
		return environment.numberClient.getFact(state.number)
			.receive(on: environment.main)
			.catchToEffect(NumberAction.factReceived)
			.cancellable(id: FactRequestId())


	case let .factReceived(.success(numberFact?)):
		state.numberFact = .success(numberFact)
		return .none

	case .factReceived:
		state.numberFact = .failed
		return .none

	case .dismissAlertTapped:
		state.numberFact = .notAsked
		return .none

	case .onAppear:
		return .none
	}
}
	.debug()
	.firebaseAnalytics()
