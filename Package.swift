// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TensorFlowLite",
    platforms: [
        // TensorFlowLiteC.xcframework has MinimumOSVersion 12.0
        .iOS(.v12),
    ],
    products: [
        .library(name: "TensorFlowLite", targets: ["TensorFlowLite"]),
    ],
    targets: [
        // Swift wrapper: tensorflow/lite/swift/Sources/*.swift from
        // github.com/tensorflow/tensorflow @ ad6d8cc (CoreML/Metal delegates excluded).
        .target(
            name: "TensorFlowLite",
            dependencies: ["TensorFlowLiteC"],
            path: "Sources/TensorFlowLite",
            resources: [.copy("PrivacyInfo.xcprivacy")],
            linkerSettings: [.linkedLibrary("c++")]
        ),
        // TensorFlowLiteC: Google official prebuilt (Core slice only),
        // referenced as a Release asset zip via url + checksum.
        .binaryTarget(
            name: "TensorFlowLiteC",
            url: "https://github.com/mitene/tensorflow-lite-swift-xcframework-distribution/releases/download/v2.17.0/TensorFlowLiteC.xcframework.zip",
            checksum: "8da2a4112bd0c65ab08fa037ffee61d96f265290e885413e61cd41d190b37587"
        ),
    ]
)
