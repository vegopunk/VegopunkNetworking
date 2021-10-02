public enum BaseUrlType {
    case standard
    
    var urlString: String {
        switch self {
        case .standard:
            return "http://ec2-52-57-144-137.eu-central-1.compute.amazonaws.com:3050"
        }
    }
    
    public var url: URL {
        switch self {
        case .standard:
            return URL(string: urlString)!
        }
    }
}
