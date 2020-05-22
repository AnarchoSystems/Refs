//
//  SwiftUI.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//

import SwiftUI



@available(OSX 10.15, *)
extension Binding : MutableReference{
    
    
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        change(&wrappedValue)
    }
    
    public func read() -> Value {
        wrappedValue
    }
    
    public init(_ read: @escaping () -> Value,
                _ mutate: @escaping (@escaping (inout Value) -> Void) -> Void) {
        self = Binding(get: read,
                       set: {newValue in mutate{$0 = newValue}})
    }
    
}


@available(OSX 10.15, *)
extension State : MutableReference{
    
    public func mutate(_ change: @escaping (inout Value) -> Void) {
        change(&wrappedValue)
    }
    
    public func read() -> Value {
        wrappedValue
    }
    
}


@available(OSX 10.15, *)
public extension MutableReference{
    
    func asBinding() -> Binding<Value>{
        Binding(get: read,
                set: {newValue in self.mutate{$0 = newValue}})
    }
    
}
