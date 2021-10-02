import Moya

public protocol NetworkRoute: TargetType, CustomStringConvertible {
    
    associatedtype DecodeType: Decodable
    
    var urlType: BaseUrlType { get }
    
    var responseType: DecodeType.Type { get }
    
    var parameters: [String: Any] { get }
}

extension NetworkRoute {
    public var description: String {
        
        let urlString = urlType.urlString
        let parametersString = parameters.description
        let pathString = path
        let methodString = method.rawValue
        let sampleDataString = sampleData.description
        let headersString = headers?.description ?? "empty headers"
        
        let result = urlString +
            parametersString +
            pathString +
            methodString +
            sampleDataString +
            headersString
        
        return result
    }
}

extension NetworkRoute {
    
    public var baseURL: URL {
        urlType.url
    }
    
    public var responseType: DecodeType.Type {
        DecodeType.self
    }
}
