//
//  Arrow.swift
//  
//
//  Created by Markus Pfeifer on 21.09.20.
//

import Foundation



public protocol RefArrow {
    
    associatedtype Whole
    associatedtype Part
    
    static func compose<Ref : Reference>(ref: Ref, arrow: Self) -> IndirectRef<Ref, Part> where Ref.Value == Whole
    
}



public protocol MutableRefArrow {
    
    associatedtype Whole
    associatedtype Part
    
    static func compose<Ref : MutableReference>(ref: Ref, arrow: Self) -> IndirectMutableRef<Ref, Part> where Ref.Value == Whole
    
}
