import FirebaseAnalytics

public enum Event {
	case event(name: String, parameters: [String: Any]?)
	case screen(screenName: String, className: String)
}

public protocol AnalyticsAction {
	var event: Event { get }
}

public extension AnalyticsAction {
	var event: Event {
		.event(name: "\(self)", parameters: nil)
	}
}
