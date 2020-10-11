

struct RootClass : Codable {
    let title : String?
    var rows : [Rows]?
    let error : String?
}

struct Rows : Codable {
    
    let title : String?
    let description : String?
    let imageHref : String?
    
    enum RowsResponseKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case imageHref = "imageHref"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RowsResponseKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.imageHref = try container.decodeIfPresent(String.self, forKey: .imageHref)
    }
}

