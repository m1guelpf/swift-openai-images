public struct CreateImageRequest: Equatable, Hashable, Codable, Sendable {
	public enum Background: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
		case auto
		case opaque
		case transparent
	}

	public enum ModerationLevel: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
		case low
		case auto
	}

	public enum OutputFormat: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
		case png
		case webp
		case jpeg
	}

	/// A text description of the desired image(s).
	///
	/// The maximum length is 32000 characters.
	public var prompt: String

	/// Allows to set transparency for the background of the generated image(s).
	///
	/// When `auto` is used, the model will automatically determine the best background for the image.
	/// If `transparent`, the output format needs to support transparency, so it should be set to either `png` (default value) or `webp`.
	public var background: Background?

	/// The model to use for image generation.
	///
	/// This library only supports the `gpt-image-1` model.
	public var model: ImageModel

	/// Control the content-moderation level of generated images.
	public var moderation: ModerationLevel?

	/// The number of images to generate. Must be between `1` and `10`.
	public var n: Int?

	/// The compression level (0-100%) for the generated image(s).
	///
	/// Only supported for the `webp` or `jpeg` output formats, and defaults to `100`.
	public var outputCompression: Int?

	/// The format in which the generated image(s) are returned.
	///
	/// Defaults to `png`.
	public var outputFormat: OutputFormat?

	/// The quality of the image(s) that will be generated.
	///
	/// Defaults to `auto`.
	public var quality: ImageQuality?

	/// The dimensions of the generated image(s).
	///
	/// Defaults to `auto`
	public var size: ImageSize?

	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	///
	/// [Learn more](https://platform.openai.com/docs/guides/safety-best-practices#end-user-ids)
	public var user: String?

	/// Creates a new `CreateImageRequest` instance.
	///
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter background: Allows to set transparency for the background of the generated image(s).
	/// - Parameter moderation: Control the content-moderation level of generated images.
	/// - Parameter n: The number of images to generate. Must be between `1` and `10`.
	/// - Parameter outputCompression: The compression level (0-100%) for the generated image(s).
	/// - Parameter outputFormat: The format in which the generated image(s) are returned.
	/// - Parameter quality: The quality of the image(s) that will be generated.
	/// - Parameter size: The dimensions of the generated image(s).
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		prompt: String,
		background: Background? = nil,
		moderation: ModerationLevel? = nil,
		n: Int? = nil,
		outputCompression: Int? = nil,
		outputFormat: OutputFormat? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) {
		self.n = n
		self.size = size
		self.user = user
		model = .gptImage
		self.prompt = prompt
		self.quality = quality
		self.background = background
		self.moderation = moderation
		self.outputFormat = outputFormat
		self.outputCompression = outputCompression
	}
}
