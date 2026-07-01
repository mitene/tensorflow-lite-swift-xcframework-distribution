import Foundation
import TensorFlowLiteC

/// A TensorFlow Lite model used by the `Interpreter` to perform inference.
final class Model {
    /// The `TfLiteModel` C pointer type represented as an `UnsafePointer<TfLiteModel>`.
    typealias CModel = OpaquePointer

    /// The underlying `TfLiteModel` C pointer.
    let cModel: CModel?

    /// The underlying data if data init is used
    /// From c_api.h: The caller retains ownership of the `model_data` and should ensure that
    // the lifetime of the `model_data` must be at least as long as the lifetime
    // of the `TfLiteModel`.
    let data: Data?

    /// Creates a new instance with the given `filePath`.
    ///
    /// - Precondition: Initialization can fail if the given `filePath` is invalid.
    /// - Parameters:
    ///   - filePath: The local file path to a TensorFlow Lite model.
    init?(filePath: String) {
        guard !filePath.isEmpty, let cModel = TfLiteModelCreateFromFile(filePath) else { return nil }
        self.cModel = cModel
        data = nil
    }

    /// Creates a new instance with the given `modelData`.
    ///
    /// - Precondition: Initialization can fail if the given `modelData` is invalid.
    /// - Parameters:
    ///   - modelData: Binary data representing a TensorFlow Lite model.
    init?(modelData: Data) {
        data = modelData
        cModel = modelData.withUnsafeBytes { TfLiteModelCreate($0, modelData.count) }
    }

    deinit {
        TfLiteModelDelete(cModel)
    }
}
