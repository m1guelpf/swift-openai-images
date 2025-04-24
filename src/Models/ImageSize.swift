/// The size of the generated images.
public enum ImageSize: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
	case auto
	case square = "1024x1024"
	case portrait = "1024x1536"
	case landscape = "1536x1024"
}
