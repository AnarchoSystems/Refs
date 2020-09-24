//
//  Atomic.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//

import Foundation


///An Atomic reference is a threadsafe shared memory pointer with non-blocking writes.
@propertyWrapper
public struct Atomic<Underlying : Reference> : Reference {
    
    ///The value that can be read.
    public typealias Value = Underlying.Value
    
    ///The underlying, possibly non-threadsafe storage.
    private let underlying : Underlying
    ///The queue used for synchronization.
    private let queue : DispatchQueue
    
    ///Initializes the atomic reference with the given underlying storage.
    /// - Parameters:
    ///     - underlying: The underlying storage.
    public init(_ underlying: Underlying) {
        self.underlying = underlying
        self.queue = DispatchQueue(label: "Atomic")
    }
    
    //see documentation of Reference protocol
    public func read() -> Value {
        queue.sync{
        underlying.read()
        }
    }
    
    //property wrapper requirement
    public var wrappedValue : Value{
        get{
            read()
        }
    }
    
}


extension Atomic : MutableReference where Underlying : MutableReference{
    
    ///Initializes atomically accessed shared mutable memory.
    /// - Parameters:
    ///     - value: The initial value in memory.
    public init<Value>(value: Value) where Underlying == AnyMutableRef<Value>{
        self = Atomic(AnyMutableRef(wrappedValue: value))
    }
    
    //See documentation of MutableReference protocol
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        queue.async {
            self.underlying.mutate(change)
        }
    }
    
    //property wrapper requirement
    public var projectedValue : AnyMutableRef<Value> {
        AnyMutableRef(read,
                      mutate)
    }
}



///A BlockingAtomic reference is a threadsafe shared memory pointer with blocking writes.
@propertyWrapper
public struct BlockingAtomic<Underlying : Reference> : Reference {
    
    ///The value that can be read.
    public typealias Value = Underlying.Value
    
    ///The underlying, possibly non-threadsafe storage.
    private let underlying : Underlying
    ///The queue used for synchronization.
    private let queue : DispatchQueue
    
    ///Initializes the atomic reference with the given underlying storage.
    /// - Parameters:
    ///     - underlying: The underlying storage.
    public init(_ underlying: Underlying) {
        self.underlying = underlying
        self.queue = DispatchQueue(label: "Atomic")
    }
    
    //see documentation of Reference protocol
    public func read() -> Value {
        queue.sync{
        underlying.read()
        }
    }
    
    //property wrapper requirement
    public var wrappedValue : Value{
        get{
            read()
        }
    }
    
}


extension BlockingAtomic : MutableReference where Underlying : MutableReference{
    
    ///Initializes atomically accessed shared mutable memory.
    /// - Parameters:
    ///     - value: The initial value in memory.
    public init<Value>(value: Value) where Underlying == AnyMutableRef<Value>{
        self = BlockingAtomic(AnyMutableRef(wrappedValue: value))
    }
    
    //See documentation of MutableReference protocol
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        queue.async {
            self.underlying.mutate(change)
        }
    }
    
    //property wrapper requirement
    public var projectedValue : AnyMutableRef<Value> {
        AnyMutableRef(read,
                      mutate)
    }
}
