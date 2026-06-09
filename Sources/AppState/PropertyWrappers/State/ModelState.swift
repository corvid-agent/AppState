#if canImport(SwiftData)
import Combine
import SwiftData
import SwiftUI

/// `ModelState` is a property wrapper that exposes the SwiftData `@Model` objects matching a
/// `FetchDescriptor` from the `Application`'s scope. The models are read from and written to a
/// `ModelContainer` dependency.
///
/// The wrapped value is **read-only** and performs a live fetch on access. Mutate the store through
/// the projected value, which exposes the underlying ``Application/ModelState`` and its
/// ``Application/ModelState/insert(_:)``, ``Application/ModelState/delete(_:)``,
/// ``Application/ModelState/save()``, and ``Application/ModelState/deleteAll()`` operations.
///
/// - Note: Mutations made through `ModelState` are not automatically broadcast to SwiftUI. For
///   reactive views, use SwiftData's `@Query` together with the AppState-provided `ModelContainer`.
///   `ModelState` is best suited to view models, services, and other non-view code.
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
@propertyWrapper public struct ModelState<Model: PersistentModel> {
    /// Holds the singleton instance of `Application`.
    @ObservedObject private var app: Application = Application.shared

    /// Path for accessing `ModelState` from Application.
    private let keyPath: KeyPath<Application, Application.ModelState<Model>>

    private let fileID: StaticString
    private let function: StaticString
    private let line: Int
    private let column: Int

    /// The models currently matching this state's `FetchDescriptor`.
    ///
    /// Reading this performs a live SwiftData fetch. To mutate the store, use the projected value
    /// (`$model.insert(_:)`, `$model.delete(_:)`, `$model.save()`, `$model.deleteAll()`).
    @MainActor
    public var wrappedValue: [Model] {
        Application.modelState(
            keyPath,
            fileID,
            function,
            line,
            column
        ).models
    }

    /// The underlying ``Application/ModelState``, exposing `insert`, `delete`, `save`, and `deleteAll`.
    @MainActor
    public var projectedValue: Application.ModelState<Model> {
        Application.modelState(
            keyPath,
            fileID,
            function,
            line,
            column
        )
    }

    /**
     Initializes the ModelState with a `keyPath` for accessing `ModelState` in Application.

     - Parameter keyPath: The `KeyPath` for accessing `ModelState` in Application.
     */
    @MainActor
    public init(
        _ keyPath: KeyPath<Application, Application.ModelState<Model>>,
        _ fileID: StaticString = #fileID,
        _ function: StaticString = #function,
        _ line: Int = #line,
        _ column: Int = #column
    ) {
        self.keyPath = keyPath
        self.fileID = fileID
        self.function = function
        self.line = line
        self.column = column
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
extension ModelState: DynamicProperty { }
#endif
