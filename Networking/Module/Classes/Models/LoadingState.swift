public enum LoadingState<T: Equatable, E: Equatable>: Equatable {

    case loading(Data)
    case ready(Data)

    public enum Data: Equatable {
        case empty
        case data(T)
        case error(E)
    }
}

// MARK: - Helper Methods

public extension LoadingState {

    var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }

    var data: T? {
        switch self {
        case let .loading(.data(payload)):
            return payload
        case let .ready(.data(payload)):
            return payload
        default:
            return nil
        }
    }

    static func skipFilter<T: Equatable, E: Equatable>(old: LoadingState<T, E>, new: LoadingState<T, E>) -> Bool {
        switch (old, new) {
        case (_, .ready(.data)), (.ready(.empty), _), (.ready(.error), _), (.loading, _):
            return old == new
        default:
            return true
        }
    }

}
