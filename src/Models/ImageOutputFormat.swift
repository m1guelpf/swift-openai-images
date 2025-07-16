import Foundation

/// The format in which the generated image(s) are returned.
public enum ImageOutputFormat: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
	case png
	case webp
	case jpeg
}
