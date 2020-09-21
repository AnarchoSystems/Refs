//
//  Lens.swift
//  
//
//  Created by Markus Pfeifer on 21.09.20.
//

import Foundation



public struct Lens<Whole, Part> {
    
    
    private let _read : (Whole) -> Part
    private let _write : (@escaping (inout Part) -> Void) -> (inout Whole) -> Void
    
    
    public init(read: @escaping (Whole) -> Part,
                write: @escaping (@escaping (inout Part) -> Void) -> (inout Whole) -> Void) {
        self._read = read
        self._write = write
    }
    
    
    public init(get: @escaping (Whole) -> Part,
                set: @escaping (Whole, Part) -> Whole) {
        self = Lens(read: get,
                    write: {change in {whole in
                        var part = get(whole)
                        change(&part)
                        whole = set(whole, part)
                        }})
    }
    
    
    public func get(from whole : Whole) -> Part {
        _read(whole)
    }
    
    
    public func change(whole: inout Whole, closure: @escaping (inout Part) -> Void) {
        _write(closure)(&whole)
    }
    
    
    public func set(newValue: Part, into whole: inout Whole) {
        change(whole: &whole, closure: {$0 = newValue})
    }
    
    
    public func send(newValue: Part, to whole: Whole) -> Whole {
        var out = whole
        set(newValue: newValue, into: &out)
        return out
    }
    
    
}



extension Lens : MutableRefArrow {
    
    
    public static func compose<Ref>(ref: Ref, arrow: Lens<Whole, Part>) -> IndirectMutableRef<Ref, Part> where Ref : MutableReference, Self.Whole == Ref.Value {
        IndirectMutableRef(underlying: ref,
                           read: arrow._read,
                           mutate: arrow._write)
    }
    
    
}
