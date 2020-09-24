//
//  AnyRef.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//

import Foundation


///A generic reference with customizable semantics.
@propertyWrapper
public struct AnyRef<Value> : Reference{
    
    ///Describes how to read the referenced value.
    fileprivate let _read : () -> Value
    
    ///Initializes the reference by specifying how to read the referenced value.
    /// - Parameters:
    ///     - read: Specifies how to read the value.
    public init(_ read: @escaping () -> Value){
        self._read = read
    }
    
    ///Initializes the reference with a constant value.
    /// - Parameters:
    ///     - value: The constant value that can't be changed.
    public init(wrappedValue: Value){
        self = AnyRef{wrappedValue}
    }
    
    //See documentation of Reference protocol
    public func read() -> Value {
        _read()
    }
    
    //property wrapper requirement
    public var wrappedValue: Value{
        self._read()
    }
    
    //property wrapper option
    public var projectedValue : AnyRef<Value>{
        self
    }
    
    
    //See documentation of Reference protocol
    public func asAnyRef() -> AnyRef<Value> {
        self
    }
    
}


///A generic mutable reference with customizable semantics.
@propertyWrapper 
public struct AnyMutableRef<Value> : MutableReference{
    
    ///Describes how to read the referenced value.
    fileprivate let _read : () -> Value
    ///Describes how to change the referenced value.
    private let _mutate : (@escaping (inout Value) -> Void) -> Void
    
    ///Initializes the reference by specifying how to read and change the referenced value.
    /// - Parameters:
    ///     - read: Specifies how to read the value.
    ///     - mutate: Describes how to change the referenced value.
    ///     - change: The change to apply.
    public init(_ read: @escaping () -> Value,
                _ mutate: @escaping (_ change: @escaping (inout Value) -> Void) -> Void){
        self._read = read
        self._mutate = mutate
    }
    
    
    ///Initializes the reference with a constant value.
    /// - Parameters:
    ///     - value: The constant value that can't be changed.
    public init(wrappedValue: Value){
        var mutable = wrappedValue
        self = AnyMutableRef({mutable},
                             {change in change(&mutable)})
    }
    
    //See documentation of Reference protocol
    public func read() -> Value {
        _read()
    }
    
    //See documentation of MutableReference protocol
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        _mutate(change)
    }
    
    //property wrapper requirement
    public var wrappedValue: Value{
        get{
            self._read()
        }
        set{
            self._mutate{$0 = newValue}
        }
    }
    
    //property wrapper option
    public var projectedValue : AnyMutableRef<Value>{
        self
    }
    
    //See documentation of MutableReference protocol
    public func asAnyMutableRef() -> AnyMutableRef<Value> {
        self
    }
    
}
