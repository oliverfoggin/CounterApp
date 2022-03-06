import ComposableArchitecture

public extension Reducer where Action: AnalyticsAction {
	func analytics() -> Self {
		return self
			.firebaseAnalytics()
			.adjustAnalytics()
	}
}
