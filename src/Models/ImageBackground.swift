import Foundation

/// Allows to set transparency for the background of the generated image(s).
public enum ImageBackground: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
	case auto
	case opaque
	case transparent
}
