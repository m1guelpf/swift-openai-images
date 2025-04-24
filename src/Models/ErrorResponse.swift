public struct ErrorResponse: Decodable, Sendable {
	public struct Error: Swift.Error, Decodable, Sendable {
		/// The type of error.
		public var type: String

		/// A human-readable description of the error.
		public var message: String

		/// The error code for the response.
		public var code: String?

		/// The parameter that caused the error.
		public var param: String?
	}

	public var error: Error
}
