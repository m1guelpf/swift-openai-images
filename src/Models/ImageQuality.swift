/// The quality of the image that will be generated.
public enum ImageQuality: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
	case low
	case high
	case auto
	case medium
}
