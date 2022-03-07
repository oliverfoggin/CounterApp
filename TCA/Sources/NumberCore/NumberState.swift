//
//  NumberState.swift
//  NumberAppTCA
//
//  Created by Oliver Foggin on 06/03/2022.
//

import Foundation
import Analytics
import ComposableArchitecture
import Services

public struct NumberState: Equatable, Identifiable {
	public let id: UUID
	public var number: Int
	public var numberFact: Remote<NumberFact>

	public init(
		number: Int = 0,
		numberFact: Remote<NumberFact> = .notAsked,
		id: UUID = .init()
	) {
		self.number = number
		self.numberFact = numberFact
		self.id = id
	}

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

public enum NumberAction: Equatable, AnalyticsAction {
	case dismissAlertTapped

	case onAppear
	case incrementTapped
	case decrementTapped
	case getRandomNumberTapped
	case randomNumberReceived(Result<Int?, Never>)
	case getFactTapped
	case factReceived(Result<NumberFact?, Never>)

	public var event: Event {
		switch self {
		case let .randomNumberReceived(.success(number?)):
			return .event(name: "randomNumberReceived", parameters: ["number": number])
		case let .factReceived(.success(fact?)):
			return .event(
				name: "factReceived",
				parameters: [
					"number": fact.number,
					"fact": fact.text
				]
			)
		case .onAppear:
			return .screen(screenName: "Number App View", className: "ContentView")
		default:
			return .event(name: "\(self)", parameters: nil)
		}
	}
}

public struct NumberEnvironment {
	let numberClient: NumberClient
	let main: AnySchedulerOf<DispatchQueue>
}

public extension NumberEnvironment {
	static var live: Self = .init(
		numberClient: .live,
		main: .main
	)
}

public let numberReducer = Reducer<NumberState, NumberAction, NumberEnvironment> {
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
