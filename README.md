# Refs

One of the astonishingly intricate parts of development is the management of shared state. Most non-trivial applications have it, but often managing it in a maintainable and concise way is neglected.

One of the patterns that emerged is to create dedicated generic wrappers that turn innocent and tame value types into references. This has been extensively used by SwiftUI with Bindings and State (although Binding and State themselves are structs).

In this Swift repo, I made References a protocol. Essentially this allows you to decorate your shared environment values with semantics like threadsafety. You are also able to map references.

Another important aspect is that you can distinguish at the type level if a reference is mutable or not. That way, you can ensure that you hand write access only to places in your code that you trust while freely sharing write access.

Note: Don't use references as implemented here to reference remote values! References are synchronous by design, remote actions are in most cases better represented with asynchronous wrappers like Promises.

Also notice that references typically don't notify you when they are changed (except if they are specifically designed to do so like those in SwiftUI/Combine).

The use cases that plain old references are really good for are mostly a) dependency injection without copying data or doing IO all the time or b) mutating something in a threadsafe way.

If you find more usecases that can be implemented with this small library, please let me know!
