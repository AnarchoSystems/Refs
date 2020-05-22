//
//  IndirectRef.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//

import Foundation


///An indirect reference is a reference to some part of a value already referenced elsewhere.
@propertyWrapper
public struct IndirectRef<Underlying : Reference, Value> : Reference {
    
    ///The type of the backing value.
    public typealias Backing = Underlying.Value
    
    ///The underlying storage.
    private let underlying : Underlying
    ///Specifies how to read from the underlying value.
    private let _read : (Backing) -> Value
    
    
    ///Initializes the indirect reference with the underlying environment and a way to read the value from there.
    /// - Parameters:
    ///     - underlying: The underlying storage.
    ///     - read: The way how to read from the environment.
    ///     - environment: The environment backing the value.
    public init(underlying: Underlying,
                read: @escaping (_ environment: Backing) -> Value){
        self.underlying = underlying
        self._read = read
    }
    
    //See documentation of the Reference protocol
    public func read() -> Value {
        _read(underlying.read())
    }
    
    //property wrapper requirement
    public var wrappedValue : Value{
        read()
    }
    
}



///An indirect mutable reference is a reference to some mutable part of a value already referenced elsewhere.
@propertyWrapper
public struct IndirectMutableRef<Underlying: MutableReference, Value> : MutableReference{
    
    ///The type of the backing value.
    public typealias Backing = Underlying.Value
    
    ///The underlying storage.
    private let underlying : Underlying
    ///Specifies how to read from the underlying value.
    private let _read : (Backing) -> Value
    ///Specifies how a change to the referenced value changes the backing value.
    private let _mutate : (@escaping (inout Value) -> Void) -> ((inout Backing) -> Void)
    
    
    ///Initializes the indirect reference with the underlying environment and a way to read/manipulate the value in the environment.
    /// - Parameters:
    ///     - underlying: The underlying storage.
    ///     - read: The way how to read from the environment.
    ///     - environment: The environment backing the value.
    ///     - mutate: Specifies how a change to the referenced value changes the backing value.
    ///     - localChange: The change to be applied to the referenced value.
    public init(underlying: Underlying,
                read: @escaping (_ environment: Backing) -> Value,
                mutate: @escaping (_ localChange: @escaping (inout Value) -> Void) -> ((inout Backing) -> Void)){
        self.underlying = underlying
        self._read = read
        self._mutate = mutate
    }
    
    
    ///Initializes the indirect reference with the underlying environment and a way to read/manipulate the value in the environment.
    /// - Parameters:
    ///     - underlying: The underlying storage.
    ///     - keypath: A writable key path for reading and writing the value given the environment.
    public init(underlying: Underlying,
                keypath: WritableKeyPath<Backing, Value>){
        self.underlying = underlying
        self._read = {$0[keyPath: keypath]}
        self._mutate = {change in {change(&$0[keyPath: keypath])}}
    }
    
    
    //See documentation of the Reference protocol
    public func read() -> Value {
        _read(underlying.read())
    }
    
    //property wrapper requirement
    public var wrappedValue : Value{
        read()
    }
    
    //See documentation of the MutableReference protocol
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        underlying.mutate(_mutate(change))
    }
    
    
}
