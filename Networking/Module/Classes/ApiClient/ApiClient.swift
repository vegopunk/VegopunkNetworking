import Moya

public enum NetworkLayerError: Error {
    case failedToDecode
}

final class TasksStorage {
    static let shared = TasksStorage()
    
    private(set) var tasks = [String: Any]()
    private let recursiveBlock = NSRecursiveLock()
    
    init() {}
    
    func append(_ key: String, value: Any) {
        tasks[key] = value
    }
    
    func remove(_ key: String) {
        recursiveBlock.lock()
        defer {
            recursiveBlock.unlock()
        }
        tasks[key] = nil
    }
    
}

public final class ApiClient {
    
    private static let username = "esports"
    private static let password = "esportsupass!=test"
    
    private let storage = TasksStorage.shared
    
    private let plugins: [PluginType] = [
        NetworkLoggerPlugin(),
        AccessTokenPlugin(tokenClosure: { type -> String in
            switch type {
            case .basic:
                guard
                    let loginData = String(format: "\(username):\(password)").data(using: .utf8)
                else {
                    return ""
                }
                return loginData.base64EncodedString()
            default:
                return ""
            }
        })
    ]
    
    public init() {}
    
    public func request<T: NetworkRoute>(
        _ route: T,
        completion: ((T.DecodeType) -> Void)? = nil,
        failure: ((Error) -> Void)? = nil
    ) {
        guard storage.tasks[route.description] == nil else { return }
        storage.append(route.description, value: route)
        let provider = MoyaProvider<T>(plugins: plugins)
        provider.request(route, callbackQueue: .global(qos: .background)) { [weak self] result in
            self?.storage.remove(route.description)
            switch result {
            case let .success(response):
                guard
                    let wat = try? JSONDecoder().decode(route.responseType, from: response.data)
                else {
                    assertionFailure("Failed to decode response")
                    failure?(NetworkLayerError.failedToDecode)
                    return
                }
                completion?(wat)
            case let .failure(error):
                failure?(error)
            }
        }
    }
}
