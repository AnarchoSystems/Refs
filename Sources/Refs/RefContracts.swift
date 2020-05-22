//
//  RefContracts.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//


import Foundation


///A Reference is a value that can be read from everywhere in your code.
public protocol Reference{
    
    ///The type of value that can be read.
    associatedtype Value
    
    ///Looks up the value from the environment.
    /// - Returns: The referenced value.
    func read() -> Value
    
    ///Type erases the Reference.
    /// - Returns: A reference behaving exactly like self, but with generic AnyRef type.
    func asAnyRef() -> AnyRef<Value>
    
}


public extension Reference{
    
    ///The current value that is referenced by read().
    var value : Value{
        read()
    }
    
    //See above
    func asAnyRef() -> AnyRef<Value>{
        AnyRef{self.read()}
    }
    
}



///A MutableReference is a value that can be read and written from everywhere in your code.
public protocol MutableReference : Reference{
    
    ///Changes the underlying value using the given closure.
    /// - Parameters:
    ///     - change: The change to apply to the value.
    ///     - value: A mutable representation of the value to change.
    func mutate(_ change: @escaping (_ value: inout Value) -> Void)
    
    ///Type erases the Reference.
    /// - Returns: A reference behaving exactly like self, but with generic AnyMutableRef type.
    func asAnyMutableRef() -> AnyMutableRef<Value>
    
}


public extension MutableReference{
    
    ///Changes the underlying value using the given closure.
    /// - Parameters:
    ///     - change: The change to apply to the value.
    ///     - value: A mutable representation of the value to change.
    func callAsFunction(_ change: @escaping (inout Value) -> Void){
        mutate(change)
    }
    
    ///Changes the underlying value using the given closure.
    /// - Parameters:
    ///     - change: The change to apply to the value.
    ///     - value: A representation of the value to change.
    func change(_ change: @escaping (_ value: Value) -> Value){
        self{$0 = change($0)}
    }
    
    //See above
    func asAnyMutableRef() -> AnyMutableRef<Value>{
        AnyMutableRef(read,
                      mutate)
    }
    
}
