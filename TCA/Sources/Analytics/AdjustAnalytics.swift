import ComposableArchitecture

extension Reducer where Action: AnalyticsAction {
	func adjustAnalytics() -> Reducer {
		return .init { state, action, environment in
			let effects = self.run(&state, action, environment)

			return .merge(
				.fireAndForget {
					print("🍎 \(action.event)")
				},
				effects
			)
		}
	}
}
