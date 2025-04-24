import Foundation

public struct ImageGenerationResponse: Sendable {
	public struct Usage: Decodable, Sendable {
		public struct InputTokenDetails: Decodable, Sendable {
			/// The number of image tokens in the input prompt.
			public var imageTokens: Int

			/// The number of text tokens in the input prompt.
			public var textTokens: Int
		}

		/// The number of tokens (images and text) in the input prompt.
		public var inputTokens: Int

		/// The input tokens detailed information for the image generation.
		public var inputTokensDetails: InputTokenDetails

		/// The number of image tokens in the output image.
		public var outputTokens: Int

		/// The total number of tokens (images and text) used for the image generation.
		public var totalTokens: Int
	}

	public var usage: Usage
	public var images: [Data]
	public var createdAt: Date
}

extension ImageGenerationResponse: Decodable {
	private enum CodingKeys: String, CodingKey {
		case data
		case usage
		case created
	}

	private struct ImageData: Decodable {
		/// The base64-encoded JSON of the generated image.
		var b64Json: String
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		usage = try container.decode(Usage.self, forKey: .usage)
		createdAt = try Date(timeIntervalSince1970: container.decode(TimeInterval.self, forKey: .created))
		images = try container.decode([ImageData].self, forKey: .data).map { imageData in
			guard let image = Data(base64Encoded: imageData.b64Json) else {
				throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "Invalid base64-encoded image data")
			}

			return image
		}
	}
}
