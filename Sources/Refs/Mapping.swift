//
//  Mapping.swift
//  
//
//  Created by Markus Pfeifer on 22.05.20.
//

import Foundation



public extension Reference{
    
    
    ///Computes a reference to some new value given a way to transform the receiver's referenced value to the new value.
    /// - Parameters:
    ///     - transform: A transformation to be applied to the referenced value.
    /// - Returns: A reference to a transformed value.
    func map<T>(_ transform: @escaping (Value) -> T) -> IndirectRef<Self, T>{
        IndirectRef(underlying: self,
                    read: transform)
    }
    
    
    ///Computes a reference to some new value given a way to transform the receiver's referenced value to the new value.
    /// - Parameters:
    ///     - transform: A transformation to be applied to the referenced value.
    /// - Returns: A reference to a transformed value.
    func map<Arrow : RefArrow>(_ transform: Arrow) -> IndirectRef<Self, Arrow.Part> where Arrow.Whole == Value{
        Arrow.compose(ref: self, arrow: transform)
    }
    
    
}


public extension MutableReference{
    
    
    ///Computes a mutable reference to some new value given a way to transform the receiver's referenced value to the new value and a way to mutate the receiver's referenced value, whenever the new value is mutated.
    /// - Parameters:
    ///     - read: A transformation to be applied to the referenced value.
    ///     - mutate: Describes how a change to the new value affects the underlying value.
    /// - Returns: A reference to a transformed value.
    func map<T>(_ read: @escaping (Value) -> T,
                _ mutate: @escaping (@escaping (inout T) -> Void) -> (inout Value) -> Void) -> IndirectMutableRef<Self, T>{
        IndirectMutableRef(underlying: self,
                           read: read,
                           mutate: mutate)
    }
    
    
    func map<Arrow : MutableRefArrow>(mutating arrow: Arrow) -> IndirectMutableRef<Self, Arrow.Part> where Arrow.Whole == Value {
        Arrow.compose(ref: self, arrow: arrow)
    }
    
    
}


extension WritableKeyPath : MutableRefArrow {
   
    public typealias Whole = Root
    public typealias Part = Value
    
    public static func compose<Ref>(ref: Ref, arrow: WritableKeyPath<Root, Value>) -> IndirectMutableRef<Ref, Value> where Ref : MutableReference, Root == Ref.Value {
        IndirectMutableRef<Ref, Value>(underlying: ref,
                                       keypath: arrow)
      }
    
}
