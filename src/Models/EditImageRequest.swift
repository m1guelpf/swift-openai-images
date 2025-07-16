import Foundation

public struct EditImageRequest: Sendable {
	/// Control how much effort the model will exert to match the style and features, especially facial features, of input images.
	public enum ImageFidelity: String, CaseIterable, Equatable, Hashable, Codable, Sendable {
		case high
		case low
	}

	public struct Image: Equatable, Hashable, Sendable {
		public enum Format: String, CaseIterable, Sendable {
			case png = "image/png"
			case jpg = "image/jpeg"
			case webp = "image/webp"
		}

		/// The name of the image
		public var fileName: String

		/// The contents of the image
		public var data: Data

		/// The format of the image
		public var format: Format

		/// Creates a new `Image` instance.
		///
		/// - Parameter fileName: The name of the image
		/// - Parameter contents: The contents of the image
		/// - Parameter format: The format of the image
		public init(fileName: String, data: Data, format: Format) {
			self.data = data
			self.format = format
			self.fileName = fileName
		}
	}

	/// The image(s) to edit.
	///
	/// Each image should be a `png`, `webp`, or `jpg` file less than 25MB.
	public var images: [Image]

	/// A text description of the desired image(s).
	///
	/// The maximum length is 32000 characters.
	public var prompt: String

	/// Allows to set transparency for the background of the generated image(s).
	///
	/// When `auto` is used, the model will automatically determine the best background for the image.
	/// If `transparent`, the output format needs to support transparency, so it should be set to either `png` (default value) or `webp`.
	public var background: ImageBackground?

	/// Control how much effort the model will exert to match the style and features, especially facial features, of input images.
	public var inputFidelity: ImageFidelity?

	/// An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where `image` should be edited.
	///
	/// If there are multiple images provided, the mask will be applied on the first image.
	///
	/// Must be a valid PNG file, less than 4MB, and have the same dimensions as `image`.
	public var mask: Image?

	/// The model to use for image generation.
	public var model: ImageModel

	/// The number of images to generate.
	///
	/// Must be between 1 and 10.
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

	/// The quality of the image that will be generated.
	public var quality: ImageQuality?

	/// The size of the generated images.
	public var size: ImageSize?

	/// Edit the image in streaming mode.
	public var stream: Bool?

	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	///
	/// [Learn more](https://platform.openai.com/docs/guides/safety-best-practices#end-user-ids)
	public var user: String?

	/// Creates a new `EditImageRequest` instance.
	///
	/// - Parameter images: The images to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter background: Allows to set transparency for the background of the generated image(s).
	/// - Parameter inputFidelity: Control how much effort the model will exert to match the style and features, especially facial features, of input images.
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter outputCompression: The compression level (0-100%) for the generated image(s).
	/// - Parameter outputFormat: The format in which the generated image(s) are returned.
	/// - Parameter partialImages: The number of partial images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter stream: Generate the image in streaming mode.
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		images: [Image],
		prompt: String,
		background: ImageBackground? = nil,
		inputFidelity: ImageFidelity? = nil,
		mask: Image? = nil,
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
		self.mask = mask
		model = .gptImage
		self.images = images
		self.prompt = prompt
		self.stream = stream
		self.quality = quality
		self.background = background
		self.outputFormat = outputFormat
		self.inputFidelity = inputFidelity
		self.partialImages = partialImages
		self.outputCompression = outputCompression
	}

	// Creates a new `EditImageRequest` instance.
	///
	/// - Parameter image: The image to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter background: Allows to set transparency for the background of the generated image(s).
	/// - Parameter inputFidelity: Control how much effort the model will exert to match the style and features, especially facial features, of input images.
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter outputCompression: The compression level (0-100%) for the generated image(s).
	/// - Parameter outputFormat: The format in which the generated image(s) are returned.
	/// - Parameter partialImages: The number of partial images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter stream: Generate the image in streaming mode.
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		image: Image,
		prompt: String,
		background: ImageBackground? = nil,
		inputFidelity: ImageFidelity? = nil,
		mask: Image? = nil,
		n: Int? = nil,
		outputCompression: Int? = nil,
		outputFormat: ImageOutputFormat? = nil,
		partialImages: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		stream: Bool? = nil,
		user: String? = nil
	) {
		self.init(
			images: [image],
			prompt: prompt,
			background: background,
			inputFidelity: inputFidelity,
			mask: mask,
			n: n,
			outputCompression: outputCompression,
			outputFormat: outputFormat,
			partialImages: partialImages,
			quality: quality,
			size: size,
			stream: stream,
			user: user
		)
	}
}

public extension EditImageRequest.Image {
	/// Creates an `Image` instance from a local file or URL.
	///
	/// - Parameter url: The URL of the image to upload.
	/// - Parameter fileName: The name of the image.
	/// - Parameter format: The format of the image.
	static func url(_ url: URL, fileName: String? = nil, format: EditImageRequest.Image.Format) async throws -> EditImageRequest.Image {
		let fileName = fileName ?? url.lastPathComponent == "/" ? "unknown_file" : url.lastPathComponent

		return try EditImageRequest.Image(fileName: fileName, data: Data(contentsOf: url), format: format)
	}

	/// Creates an `Image` instance from the given data.
	///
	/// - Parameter fileName: The name of the file.
	/// - Parameter data: The contents of the file.
	/// - Parameter format: The format of the image.
	static func image(fileName: String, data: Data, format: EditImageRequest.Image.Format) -> EditImageRequest.Image {
		return EditImageRequest.Image(fileName: fileName, data: data, format: format)
	}
}

extension EditImageRequest: FormDataEncodable {
	func encode() throws -> [FormData.Entry] {
		var entries: [FormData.Entry] = images.map { image in
			.file(paramName: "image[]", fileName: image.fileName, fileData: image.data, contentType: image.format.rawValue)
		}

		entries.append(.string(paramName: "prompt", value: prompt))
		if let n { entries.append(.string(paramName: "n", value: n)) }
		entries.append(.string(paramName: "model", value: model.rawValue))
		if let user { entries.append(.string(paramName: "user", value: user)) }
		if let stream { entries.append(.string(paramName: "stream", value: stream)) }
		if let size { entries.append(.string(paramName: "size", value: size.rawValue)) }
		if let quality { entries.append(.string(paramName: "quality", value: quality.rawValue)) }
		if let background { entries.append(.string(paramName: "background", value: background.rawValue)) }
		if let partialImages { entries.append(.string(paramName: "partial_images", value: partialImages)) }
		if let outputFormat { entries.append(.string(paramName: "output_format", value: outputFormat.rawValue)) }
		if let inputFidelity { entries.append(.string(paramName: "input_fidelity", value: inputFidelity.rawValue)) }
		if let outputCompression { entries.append(.string(paramName: "output_compression", value: outputCompression)) }
		if let mask { entries.append(.file(paramName: "mask", fileName: mask.fileName, fileData: mask.data, contentType: mask.format.rawValue)) }

		return entries
	}
}
