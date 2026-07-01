# TensorFlow Lite Swift XCFramework Distribution

A Swift Package Manager (SwiftPM) distribution of TensorFlow Lite (Swift), packaged from
the official Google prebuilt binary.

## Why This Repository?

TensorFlow Lite (Swift) has long been available only via CocoaPods, with no official SwiftPM
distribution ([google-ai-edge/LiteRT#125](https://github.com/google-ai-edge/LiteRT/issues/125)).
This repository re-packages the **same binary** that CocoaPods downloads, together with the
official Swift wrapper sources, as a SwiftPM package so it can be consumed through SwiftPM.

The approach mirrors
[`mitene/realm-swift-xcframework-distribution`](https://github.com/mitene/realm-swift-xcframework-distribution).

## Installation

### Swift Package Manager

Add the package as a dependency:

```swift
dependencies: [
    .package(url: "https://github.com/mitene/tensorflow-lite-swift-xcframework-distribution", from: "2.17.0"),
],
```

And add the product to your target:

```swift
.product(name: "TensorFlowLite", package: "tensorflow-lite-swift-xcframework-distribution")
```

```swift
import TensorFlowLite

let interpreter = try Interpreter(modelPath: modelPath)
```

`binaryTarget(url:)` downloads the zip once at package-resolution time and caches it locally
afterwards (not on every build).

## What's Included

```
.
├─ Package.swift                     # TensorFlowLite library (Swift wrapper + TensorFlowLiteC binaryTarget)
├─ Sources/TensorFlowLite/           # Swift wrapper + PrivacyInfo.xcprivacy
├─ LICENSE
└─ README.md

Release v2.17.0
└─ TensorFlowLiteC.xcframework.zip   # Google prebuilt (Core only); Release asset, not tracked in git
```

Only the **Core** framework is included; the CoreML and Metal delegates are excluded.

## Provenance

Because a re-packaged binary loses its trail back to the original, the origin of both
components is recorded here.

### TensorFlowLiteC (binary)

- **Origin**: the Google official prebuilt fetched by CocoaPods `TensorFlowLiteC` 2.17.0
  (a `dl.google.com` tar.gz, Apache-2.0).
- **Source URL**:
  ```
  https://dl.google.com/tflite-release/ios/prod/tensorflow/lite/release/ios/release/32/20240729-115310/TensorFlowLiteC/2.17.0/0c10b3543e01f547/TensorFlowLiteC-2.17.0.tar.gz
  ```
- **Modifications**: only a minimal `Info.plist` is added to each framework slice
  (`ios-arm64`, `ios-arm64_x86_64-simulator`) to avoid an embedding validation error.
  The mach-o binary, headers, module map, and `PrivacyInfo.xcprivacy` are unchanged from upstream.
- **Binary SHA-256** (verified identical to the Google prebuilt):
  | slice | SHA-256 |
  | --- | --- |
  | ios-arm64 | `0af9943357e8b94e16b28f807d9acf44f596954191e34b4f5dd46d0c49b29561` |
  | ios-arm64_x86_64-simulator | `26a2e0179f2899e2652a76890b98b56647462add7b4d70c9bb8124dc98e66def` |
- **Release zip SwiftPM checksum**: `8da2a4112bd0c65ab08fa037ffee61d96f265290e885413e61cd41d190b37587`

### TensorFlowLite (Swift sources)

- **Origin**: [`tensorflow/tensorflow`](https://github.com/tensorflow/tensorflow)
  @ commit `ad6d8cc177d0c868982e39e0823d0efbfb95f04c`,
  `tensorflow/lite/swift/Sources/*.swift`.
- **Excluded**: `CoreMLDelegate.swift` and `MetalDelegate.swift`.
- **Module name**: `TensorFlowLite`.

## Regenerating the Release Asset

The `TensorFlowLiteC.xcframework.zip` on the Release can be reproduced as follows:

```bash
# 1. Fetch the Google official tar.gz
curl -fL -o TensorFlowLiteC-2.17.0.tar.gz \
  "https://dl.google.com/tflite-release/ios/prod/tensorflow/lite/release/ios/release/32/20240729-115310/TensorFlowLiteC/2.17.0/0c10b3543e01f547/TensorFlowLiteC-2.17.0.tar.gz"
tar -xzf TensorFlowLiteC-2.17.0.tar.gz

# 2. Keep only the Core framework (drop CoreML / Metal)
cd TensorFlowLiteC-2.17.0/Frameworks

# 3. Add a minimal Info.plist to each slice
#    (CFBundleIdentifier=org.tensorflow.TensorFlowLiteC, CFBundleExecutable=TensorFlowLiteC,
#     CFBundlePackageType=FMWK, MinimumOSVersion=12.0, ...)

# 4. Zip and compute the checksum
zip -r -X TensorFlowLiteC.xcframework.zip TensorFlowLiteC.xcframework
swift package compute-checksum TensorFlowLiteC.xcframework.zip
```

## License

- TensorFlow Lite (both the binary and the Swift sources): Apache License 2.0.
  See [`LICENSE`](./LICENSE). Copyright belongs to The TensorFlow Authors and contributors.
