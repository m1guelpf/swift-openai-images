# OpenAI Images API

[![Swift Version](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fm1guelpf%2Fswift-openai-images%2Fbadge%3Ftype%3Dswift-versions&color=brightgreen)](https://swiftpackageindex.com/m1guelpf/swift-openai-images)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/m1guelpf/swift-openai-images/main/LICENSE)

An unofficial Swift SDK for the [new GPT Image Generation API](https://platform.openai.com/docs/guides/image-generation?image-generation-model=gpt-image-1).

## Installation

<details>

<summary>
Swift Package Manager
</summary>

Add the following to your `Package.swift`:

```swift
dependencies: [
	.package(url: "https://github.com/m1guelpf/swift-openai-images.git", .branch("main"))
]
```

</details>
<details>

<summary>Installing through XCode</summary>

-   File > Swift Packages > Add Package Dependency
-   Add https://github.com/m1guelpf/swift-openai-images.git
-   Select "Branch" with "main"

</details>

<details>

<summary>CocoaPods</summary>

Ask ChatGPT to help you migrate away from CocoaPods.

</details>

## Getting started 🚀

```swift
import OpenAIImages

let client = ImagesAPI(authToken: OPENAI_API_KEY)

let response = try await client.create(prompt: "A cat playing chess")

let response = try await client.edit(
    image: .url(Bundle.main.url(forResource: "myImage", withExtension: "png"), format: .png),
    prompt: "Change the color of the sky"
)
```

## Architecture

### Creating a new instance

To interact with the Images API, create a new instance of `ImagesAPI` with your API key:

```swift
let client = ImagesAPI(authToken: YOUR_OPENAI_API_TOKEN)
```

Optionally, you can provide an Organization ID and/or project ID:

```swift
let client = ImagesAPI(
	authToken: YOUR_OPENAI_API_KEY,
	organizationId: YOUR_ORGANIZATION_ID,
	projectId: YOUR_PROJECT_ID
)
```

For more advanced use cases like connecting to a custom server, you can customize the `URLRequest` used to connect to the API:

``` swift
let urlRequest = URLRequest(url: MY_CUSTOM_ENDPOINT)
urlRequest.addValue("Bearer \(YOUR_API_KEY)", forHTTPHeaderField: "Authorization")

let client = ImagesAPI(connectingTo: urlRequest)
```

### Creating Images

To generate new images, call the `create` method with a `CreateImageRequest` instance:

```swift
let response = try await client.create(CreateImageRequest(
	prompt: "A children's book drawing of a veterinarian using a stethoscope to listen to the heartbeat of a baby otter.",
))
```

Alternatively, you can pass the parameters directly to the `create` method:

```swift
let response = try await client.create(
	prompt: "A children's book drawing of a veterinarian using a stethoscope to listen to the heartbeat of a baby otter."
    size: .landscape
)
```

### Editing Images

To edit an existing image, call the `edit` method with an `EditImageRequest` instance:

```swift
let response = try await client.edit(EditImageRequest(
    images: [.image(name: "image.png", data: imageData, format: .png)],
    prompt: "Change the background to a beach."
)
```

Alternatively, you can pass the parameters directly to the `edit` method:

```swift
let response = try await client.edit(
    images: [.url(URL(string: "https://example.com/image.webp"), format: .webp)],
    prompt: "Change the background to a beach."
)
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
