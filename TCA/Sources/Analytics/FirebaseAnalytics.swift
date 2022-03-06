import ComposableArchitecture
import FirebaseAnalytics

extension Reducer where Action: AnalyticsAction {
	func firebaseAnalytics() -> Reducer {
		return .init { state, action, environment in
			let effects = self.run(&state, action, environment)

			return .merge(
				.fireAndForget {
					switch action.event {
					case let .event(name: name, parameters: parameters):
						Analytics.logEvent(name, parameters: parameters)
					case let .screen(screenName: screenName, className: className):
						Analytics.logEvent(
							AnalyticsEventScreenView,
							parameters: [
								AnalyticsParameterScreenName: screenName,
								AnalyticsParameterScreenClass: className
							]
						)
					}
				},
				effects
			)
		}
	}
}
