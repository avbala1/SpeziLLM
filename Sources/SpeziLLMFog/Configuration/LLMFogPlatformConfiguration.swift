//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import GeneratedOpenAIClient


/// Represents the configuration of the Spezi ``LLMFogPlatform``.
public struct LLMFogPlatformConfiguration: Sendable {
    /// The connection type to the fog node.
    public enum ConnectionType: Hashable, Sendable {
        /// HTTP connection without any encryption.
        case http
        /// HTTPS connection with encrypted traffic via TLS. The root CA certificate that should be trusted must be passed as a `URL`. The host certificate must be signed via the CA certificate.
        case https(caCertificate: URL)


        /// The mDNS service type to be discovered based on the connection type.
        var mDnsServiceType: String {
            switch self {
            case .http:
                return "_http._tcp"
            case .https:
                return "_https._tcp"
            }
        }
    }

    /// Name of the to-be-discovered service within the local network.
    public let host: String
    /// The connection type to the fog node.
    public let connectionType: ConnectionType
    /// Token to authenticate with the fog node (such as a Firebase Token).
    public let authToken: RemoteLLMInferenceAuthToken
    /// Task priority of the initiated LLM inference tasks.
    public let taskPriority: TaskPriority
    /// Number of concurrent streams to the Fog LLM.
    public let concurrentStreams: Int
    /// Maximum network timeout of Fog LLM requests in seconds.
    public let timeout: TimeInterval
    /// The retry policy that should be used.
    public let retryPolicy: RetryPolicy
    /// Duration of mDNS browsing for Fog LLM services.
    public let mDnsBrowsingTimeout: Duration
    
    
    /// Creates the ``LLMFogPlatformConfiguration`` which configures the Spezi ``LLMFogPlatform``.
    ///
    /// - Parameters:
    ///   - host: The name of the to-be-discovered service within the local network via mDNS. The hostname must match the issued TLS certificate of the fog node. Defaults to `spezillmfog.local` which is used for the mDNS advertisements as well as the TLS certificate.
    ///   - connectionType: The connection type to the fog node.
    ///   - authToken: Token to authenticate with the fog node (such as a Firebase Token).
    ///   - taskPriority: The task priority of the initiated LLM inference tasks, defaults to `.userInitiated`.
    ///   - concurrentStreams: Indicates the number of concurrent streams to the Fog LLM, defaults to `5`.
    ///   - timeout: Indicates the maximum network timeout of Fog LLM requests in seconds. defaults to `60`.
    ///   - retryPolicy: The retry policy that should be used, defaults to `3` retry attempts.
    ///   - mDnsBrowsingTimeout: Duration of mDNS browsing for Fog LLM services, default to `100ms`.
    public init(
        host: String = "spezillmfog.local",     // swiftlint:disable:this function_default_parameter_at_end
        connectionType: ConnectionType,
        authToken: RemoteLLMInferenceAuthToken,
        taskPriority: TaskPriority = .userInitiated,
        concurrentStreams: Int = 5,
        timeout: TimeInterval = 60,
        retryPolicy: RetryPolicy = .attempts(3),
        mDnsBrowsingTimeout: Duration = .milliseconds(100)
    ) {
        self.host = host
        self.connectionType = connectionType
        self.authToken = authToken
        self.taskPriority = taskPriority
        self.concurrentStreams = concurrentStreams
        self.timeout = timeout
        self.retryPolicy = retryPolicy
        self.mDnsBrowsingTimeout = mDnsBrowsingTimeout
    }
}
