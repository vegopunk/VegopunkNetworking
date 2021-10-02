import Moya

public protocol StandardRoute: NetworkRoute {}

extension StandardRoute {
    
    public var urlType: BaseUrlType {
        .standard
    }
    
    public var method: Moya.Method {
        .get
    }
    
    public var sampleData: Data {
        Data()
    }
    
    public var parameters: [String: Any] {
        [:]
    }
    
    public var task: Task {
        .requestPlain
    }
    
    public var validationType: ValidationType {
        .successCodes
    }
    
    public var headers: [String : String]? {
        nil
    }
}
