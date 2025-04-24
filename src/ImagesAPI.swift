import Foundation

/// A Swift client for the OpenAI Images API.
public final class ImagesAPI: Sendable {
	public enum Error: Swift.Error {
		/// The provided request is invalid.
		case invalidRequest(URLRequest)

		/// The response was not a 200 or 400 status
		case invalidResponse(URLResponse)
	}

	private let request: URLRequest

	private let encoder = {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}()

	private let decoder = {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()

	/// Creates a new `ImagesAPI` instance using the provided `URLRequest`.
	///
	/// You can use this initializer to use a custom base URL or custom headers.
	///
	/// - Parameter request: The `URLRequest` to use for the API.
	public init(connectingTo request: URLRequest) throws {
		guard let url = request.url else { throw Error.invalidRequest(request) }

		var request = request
		if url.lastPathComponent != "/" {
			request.url = url.appendingPathComponent("/")
		}

		self.request = request
	}

	/// Creates a new `ImagesAPI` instance using the provided `authToken`.
	///
	/// You can optionally provide an `organizationId` and/or `projectId` to use with the API.
	///
	/// - Parameter authToken: The OpenAI API key to use for authentication.
	/// - Parameter organizationId: The [organization](https://platform.openai.com/docs/guides/production-best-practices#setting-up-your-organization) associated with the request.
	/// - Parameter projectId: The project associated with the request.
	public convenience init(authToken: String, organizationId: String? = nil, projectId: String? = nil) {
		var request = URLRequest(url: URL(string: "https://api.openai.com/")!)

		request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
		if let projectId { request.addValue(projectId, forHTTPHeaderField: "OpenAI-Project") }
		if let organizationId { request.addValue(organizationId, forHTTPHeaderField: "OpenAI-Organization") }

		try! self.init(connectingTo: request)
	}

	/// Creates an image given a prompt.
	///
	/// - Parameter request: The request containing the parameters for image generation.
	public func create(_ request: CreateImageRequest) async throws -> ImageGenerationResponse {
		var req = self.request
		req.httpMethod = "POST"
		req.httpBody = try encoder.encode(request)
		req.url!.append(path: "v1/images/generations")
		req.setValue("application/json", forHTTPHeaderField: "Content-Type")

		let data = try await send(request: req)

		return try decoder.decode(ImageGenerationResponse.self, from: data)
	}

	/// Creates an image given a prompt.
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
	public func create(
		prompt: String,
		background: CreateImageRequest.Background? = nil,
		moderation: CreateImageRequest.ModerationLevel? = nil,
		n: Int? = nil,
		outputCompression: Int? = nil,
		outputFormat: CreateImageRequest.OutputFormat? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) async throws -> ImageGenerationResponse {
		try await create(CreateImageRequest(
			prompt: prompt,
			background: background,
			moderation: moderation,
			n: n,
			outputCompression: outputCompression,
			outputFormat: outputFormat,
			quality: quality,
			size: size,
			user: user
		))
	}

	/// Creates an edited or extended image given one or more source images and a prompt.
	///
	/// - Parameter request: The request containing the parameters for image editing.
	public func edit(_ request: EditImageRequest) async throws -> ImageGenerationResponse {
		var req = self.request
		req.httpMethod = "POST"
		req.url!.append(path: "v1/images/edits")
		req.attach(formData: try! FormData(from: request))

		let data = try await send(request: req)

		return try decoder.decode(ImageGenerationResponse.self, from: data)
	}

	/// Creates an edited or extended image given one or more source images and a prompt.
	///
	/// - Parameter images: The image(s) to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter user: A unique identifier representing your end-user.
	public func edit(
		images: [EditImageRequest.Image],
		prompt: String,
		mask: EditImageRequest.Image? = nil,
		n: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) async throws -> ImageGenerationResponse {
		try await edit(EditImageRequest(
			images: images,
			prompt: prompt,
			mask: mask,
			n: n,
			quality: quality,
			size: size,
			user: user
		))
	}

	/// Creates an edited or extended image given a source image and a prompt.
	///
	/// - Parameter image: The image to edit.
	/// - Parameter prompt: A text description of the desired image(s).
	/// - Parameter mask: An additional image whose fully transparent areas indicate where `image` should be edited.
	/// - Parameter n: The number of images to generate.
	/// - Parameter quality: The quality of the image that will be generated.
	/// - Parameter size: The size of the generated images.
	/// - Parameter user: A unique identifier representing your end-user.
	public func edit(
		image: EditImageRequest.Image,
		prompt: String,
		mask: EditImageRequest.Image? = nil,
		n: Int? = nil,
		quality: ImageQuality? = nil,
		size: ImageSize? = nil,
		user: String? = nil
	) async throws -> ImageGenerationResponse {
		try await edit(EditImageRequest(
			image: image,
			prompt: prompt,
			mask: mask,
			n: n,
			quality: quality,
			size: size,
			user: user
		))
	}
}

private extension ImagesAPI {
	/// Sends an URLRequest and returns the response data.
	///
	/// - Throws: If the request fails to send or has a non-200 status code.
	func send(request: URLRequest, expects statusCode: Int = 200) async throws -> Data {
		let (data, res) = try await URLSession.shared.data(for: request)

		guard let res = res as? HTTPURLResponse else { throw Error.invalidResponse(res) }
		guard res.statusCode != statusCode else { return data }

		if let response = try? decoder.decode(ErrorResponse.self, from: data) {
			throw response.error
		}

		throw Error.invalidResponse(res)
	}
}
