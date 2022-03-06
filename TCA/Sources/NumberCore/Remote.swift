public enum Remote<T> {
	case notAsked
	case loading
	case success(T)
	case failed
}

extension Remote: Equatable where T: Equatable {}
