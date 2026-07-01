import Foundation

/// Errors thrown by the TensorFlow Lite `Interpreter`.
public enum InterpreterError: Error, Equatable, Hashable {
    case invalidTensorIndex(index: Int, maxIndex: Int)
    case invalidTensorDataCount(provided: Int, required: Int)
    case invalidTensorDataType
    case failedToLoadModel
    case failedToCreateInterpreter
    case failedToResizeInputTensor(index: Int)
    case failedToCopyDataToInputTensor
    case failedToAllocateTensors
    case allocateTensorsRequired
    case invokeInterpreterRequired
    case tensorFlowLiteError(String)
}

extension InterpreterError: LocalizedError {
    /// A localized description of the interpreter error.
    public var errorDescription: String? {
        switch self {
        case let .invalidTensorIndex(index, maxIndex):
            "Invalid tensor index \(index), max index is \(maxIndex)."
        case let .invalidTensorDataCount(provided, required):
            "Provided data count \(provided) must match the required count \(required)."
        case .invalidTensorDataType:
            "Tensor data type is unsupported or could not be determined due to a model error."
        case .failedToLoadModel:
            "Failed to load the given model."
        case .failedToCreateInterpreter:
            "Failed to create the interpreter."
        case let .failedToResizeInputTensor(index):
            "Failed to resize input tensor at index \(index)."
        case .failedToCopyDataToInputTensor:
            "Failed to copy data to input tensor."
        case .failedToAllocateTensors:
            "Failed to allocate memory for input tensors."
        case .allocateTensorsRequired:
            "Must call allocateTensors()."
        case .invokeInterpreterRequired:
            "Must call invoke()."
        case let .tensorFlowLiteError(message):
            "TensorFlow Lite Error: \(message)"
        }
    }
}

extension InterpreterError: CustomStringConvertible {
    /// A textual representation of the TensorFlow Lite interpreter error.
    public var description: String { errorDescription ?? "Unknown error." }
}
