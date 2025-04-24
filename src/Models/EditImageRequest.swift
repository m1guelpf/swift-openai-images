import Foundation

public struct EditImageRequest: Sendable {
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

	/// The quality of the image that will be generated.
	public var quality: ImageQuality?

	/// The size of the generated images.
	public var size: ImageSize?

	/// A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse.
	///
	/// [Learn more](https://platform.openai.com/docs/guides/safety-best-practices#end-user-ids)
	public var user: String?

	/// Creates a new `EditImageRequest` instance.
	///
	/// - Parameter images: The images to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		images: [Image],
		prompt: String,
		mask: Image? = nil,
		n: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) {
		self.n = n
		self.size = size
		self.user = user
		self.mask = mask
		model = .gptImage
		self.images = images
		self.prompt = prompt
		self.quality = quality
	}

	// Creates a new `EditImageRequest` instance.
	///
	/// - Parameter image: The image to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter user: A unique identifier representing your end-user.
	public init(
		image: Image,
		prompt: String,
		mask: Image? = nil,
		n: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) {
		self.init(images: [image], prompt: prompt, mask: mask, n: n, quality: quality, size: size, user: user)
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
		if let size { entries.append(.string(paramName: "size", value: size.rawValue)) }
		if let quality { entries.append(.string(paramName: "quality", value: quality.rawValue)) }
		if let mask { entries.append(.file(paramName: "mask", fileName: mask.fileName, fileData: mask.data, contentType: mask.format.rawValue)) }

		return entries
	}
}
