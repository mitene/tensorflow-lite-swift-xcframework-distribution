import Foundation

/// Errors thrown by the TensorFlow Lite `SignatureRunner`.
public enum SignatureRunnerError: Error, Equatable, Hashable {
    case invalidTensorDataCount(provided: Int, required: Int)
    case invalidTensorDataType
    case failedToCreateSignatureRunner(signatureKey: String)
    case failedToGetTensor(tensorType: String, nameInSignature: String)
    case failedToResizeInputTensor(inputName: String)
    case failedToCopyDataToInputTensor
    case failedToAllocateTensors
    case failedToInvokeSignature(signatureKey: String)
    case allocateTensorsRequired
}

extension SignatureRunnerError: LocalizedError {
    /// A localized description of the signature runner error.
    public var errorDescription: String? {
        switch self {
        case let .invalidTensorDataCount(provided, required):
            "Provided data count \(provided) must match the required count \(required)."
        case .invalidTensorDataType:
            "Tensor data type is unsupported or could not be determined due to a model error."
        case let .failedToCreateSignatureRunner(signatureKey):
            "Failed to create a signature runner. Signature with key (\(signatureKey)) not found."
        case let .failedToGetTensor(tensorType, nameInSignature):
            "Failed to get \(tensorType) tensor with \(tensorType) name (\(nameInSignature))."
        case let .failedToResizeInputTensor(inputName):
            "Failed to resize input tensor with input name (\(inputName))."
        case .failedToCopyDataToInputTensor:
            "Failed to copy data to input tensor."
        case .failedToAllocateTensors:
            "Failed to allocate memory for input tensors."
        case let .failedToInvokeSignature(signatureKey):
            "Failed to invoke the signature runner with key (\(signatureKey))."
        case .allocateTensorsRequired:
            "Must call allocateTensors()."
        }
    }
}

extension SignatureRunnerError: CustomStringConvertible {
    /// A textual representation of the TensorFlow Lite signature runner error.
    public var description: String { errorDescription ?? "Unknown error." }
}
