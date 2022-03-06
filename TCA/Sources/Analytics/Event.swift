import FirebaseAnalytics

//public struct Event {
//	let name: String
//	let parameters: [String: Any]?
//
//	public init(
//		name: String,
//		parameters: [String: Any]?
//	) {
//		self.name = name
//		self.parameters = parameters
//	}
//
//	public static func screenView(screenName: String, screenClass: String = "") -> Self {
//		.init(name: AnalyticsEventScreenView, parameters: [
//			AnalyticsParameterScreenName: screenName,
//			AnalyticsParameterScreenClass: screenClass
//		])
//	}
//}

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
