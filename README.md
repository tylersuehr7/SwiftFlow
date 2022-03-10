# SwiftFlow

Simplistic hot and cold flow-based reactive observer pattern for Swift… ideal for MVVM architectures!

### Using a cold-flow (emits value only when active observers)
```swift
let value = Flow<String>("")
value.emit("Hello, World!")

value.observe { print($0) }

value.emit("Hello, World 2!")
value.emit("Hello, World 3!")

// Output:
// Hello, World 2!
// Hello, World 3!
```

### Using a hot-flow (emits value even when no active observers)
```swift
let value = StateFlow<String>("")
value.emit("Hello, World!")

value.observe { print($0) }

value.emit("Hello, World 2!")
value.emit("Hello, World 3!")

// Output:
// Hello, World!
// Hello, World 2!
// Hello, World 3!
```
