---
module: application
version: 1
status: draft
files:
  - Sources/AppState/Application/Application.swift
  - Sources/AppState/Application/Application+public.swift
  - Sources/AppState/Application/Application+internal.swift

db_tables: []
depends_on: []
---

# Application

## Purpose

The Application singleton manages global app state, dependencies, and scoped state containers. It provides a centralized registry for state values, secure state (Keychain), stored state (UserDefaults), synced state (iCloud), and file-backed state. It also manages dependency injection via the Dependency and DependencySlice types.

## Public API

### Exported Functions

| Export | Description |
|--------|-------------|
| Application.state(_:) | Retrieve or define a State value |
| Application.storedState(_:) | Retrieve or define a UserDefaults-backed state |
| Application.secureState(_:) | Retrieve or define a Keychain-backed state |
| Application.syncState(_:) | Retrieve or define an iCloud-backed state |
| Application.fileState(_:) | Retrieve or define a file-backed state |
| Application.dependency(_:) | Retrieve or define a dependency |
| Application.promote(_:) | Promote a preview Application to the shared instance |

### Structs & Enums

| Type | Description |
|------|-------------|
| Application | Singleton managing all app-wide state and dependencies |
| Application.Scope | Scoped state container for preview/testing isolation |
| ApplicationLogger | Logging utility for state changes |

### Traits

| Trait | Description |
|-------|-------------|
| MutableApplicationState | Protocol for types that can modify application state |

### Functions

| Function | Signature | Description |
|----------|-----------|-------------|
| state | `static func state<Value>(_: KeyPath<Application, State<Value>>) -> State<Value>` | Access a state value by keypath |
| dependency | `static func dependency<Value>(_: KeyPath<Application, Dependency<Value>>) -> Dependency<Value>` | Access a dependency by keypath |

## Invariants

1. Application must always be a singleton; only one shared instance exists at runtime.
2. State values must be thread-safe (Sendable conformance required by Swift 6 concurrency).
3. Dependency resolution must never cause retain cycles.

## Behavioral Examples

```
Given an Application extension defining a state property
When accessing that state via @AppState property wrapper
Then the singleton value is returned and mutations propagate
```

## Error Cases

| Error | When | Behavior |
|-------|------|----------|
| Keychain unavailable | SecureState accessed without entitlements | Graceful fallback or error logged |
| iCloud unavailable | SyncState accessed without iCloud capability | Falls back to local value |

## Dependencies

- Cache (0xLeif/Cache) — underlying caching layer

## Change Log

| Version | Date | Changes |
|---------|------|---------|
| 1 | 2026-04-21 | Initial spec |
