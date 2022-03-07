import ComposableArchitecture
import Services
import NumberCore
import IdentifiedCollections
import Analytics

public struct NumberListState: Equatable {
	var numbers: IdentifiedArrayOf<NumberState>

	public init(numbers: IdentifiedArrayOf<NumberState> = []) {
		self.numbers = numbers
	}
}

public enum NumberListAction: AnalyticsAction {
	case addButtonTapped
	case delete(IndexSet)
	case onAppear

	case numberAction(id: NumberState.ID, NumberAction)

	public var event: Event {
		switch self {
		case .addButtonTapped:
			return .event(name: "add_button_tapped", parameters: nil)

		case .delete(_):
			return .event(name: "delete_button_tapped", parameters: nil)

		case .onAppear:
			return .screen(screenName: "Number list", className: "")

		case let .numberAction(id: _, action):
			return action.event
		}
	}
}

public struct NumberListEnvironment {
	let numberClient: NumberClient
	let main: AnySchedulerOf<DispatchQueue>
	let uuid: () -> UUID
}

public extension NumberListEnvironment {
	static var live: Self = .init(
		numberClient: .live,
		main: .main,
		uuid: UUID.init
	)
}

let numberListReducer = Reducer<NumberListState, NumberListAction, NumberListEnvironment> {
	state, action, environment in

	switch action {
	case .addButtonTapped:
		state.numbers.append(
			NumberState(id: environment.uuid())
		)
		return .none

	case let .delete(indexSet):
		state.numbers.remove(atOffsets: indexSet)
		return .none

	case .numberAction(id: let id, _):
		return .none

	case .onAppear:
		return .none
	}
}

public let appReducer = Reducer<NumberListState, NumberListAction, NumberListEnvironment>.combine(
	numberReducer.forEach(
		state: \.numbers,
		action: /NumberListAction.numberAction,
		environment: { _ in .live }
	),
	numberListReducer
)
	.debug()
	.analytics()
