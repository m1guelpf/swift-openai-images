public struct CreateImageRequest: Equatable, Hashable, Codable, Sendable {
	public enum ModerationLevel: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
		case low
		case auto
	}

	/// A text description of the desired image(s).
	///
	/// The maximum length is 32000 characters.
	public var prompt: String

	/// Allows to set transparency for the background of the generated image(s).
	///
	/// When `auto` is used, the model will automatically determine the best background for the image.
	/// If `transparent`, the output format needs to support transparency, so it should be set to either `png` (default value) or `webp`.
	public var background: ImageBackground?

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
	public var outputFormat: ImageOutputFormat?

	/// The number of partial images to generate.
	///
	/// This parameter is used for streaming responses that return partial images.
	///
	/// Value must be between 0 and 3. When set to 0, the response will be a single image sent in one streaming event.
	public var partialImages: Int?

	/// The quality of the image(s) that will be generated.
	///
	/// Defaults to `auto`.
	public var quality: ImageQuality?

	/// The dimensions of the generated image(s).
	///
	/// Defaults to `auto`
	public var size: ImageSize?

	/// Generate the image in streaming mode.
	///
	/// See the [Image generation guide](https://platform.openai.com/docs/guides/image-generation) for more information.
	public var stream: Bool?

	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	///
	/// [Learn more](https://platform.openai.com/docs/guides/safety-best-practices#end-user-ids)
	public var user: String?

	/// Creates a new `CreateImageRequest` instance.
	///
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter background: Allows to set transparency for the background of the generated image(s).
	/// - Parameter inputFidelity: Control how much effort the model will exert to match the style and features, especially facial features, of input images.
	/// - Parameter moderation: Control the content-moderation level of generated images.
	/// - Parameter n: The number of images to generate. Must be between `1` and `10`.
	/// - Parameter outputCompression: The compression level (0-100%) for the generated image(s).
	/// - Parameter outputFormat: The format in which the generated image(s) are returned.
	/// - Parameter partialImages: The number of partial images to generate.
	/// - Parameter quality: The quality of the image(s) that will be generated.
	/// - Parameter size: The dimensions of the generated image(s).
	/// - Parameter stream: Generate the image in streaming mode.
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		prompt: String,
		background: ImageBackground? = nil,
		moderation: ModerationLevel? = nil,
		n: Int? = nil,
		outputCompression: Int? = nil,
		outputFormat: ImageOutputFormat? = nil,
		partialImages: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		stream: Bool? = nil,
		user: String? = nil
	) {
		self.n = n
		self.size = size
		self.user = user
		model = .gptImage
		self.stream = stream
		self.prompt = prompt
		self.quality = quality
		self.background = background
		self.moderation = moderation
		self.outputFormat = outputFormat
		self.partialImages = partialImages
		self.outputCompression = outputCompression
	}
}
