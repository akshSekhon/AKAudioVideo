//
//  FilterClass.swift
//  AsafVideoIMG
//
//  Created by Mobile on 02/09/22.
//

import MetalPetal


extension AnyIOPort {
    class UnaryFilterGroup<T: Sequence> where T.Element == MTIUnaryFilter {
        var filters: T
        var inputImage: MTIImage?
        var outputImage: MTIImage? {
            filters.reduce(inputImage) { (result, filter) -> MTIImage? in
                filter.inputImage = result
                return filter.outputImage
            }
        }
        init(_ filters: T) {
            self.filters = filters
        }
        struct Port: InputPort, OutputPort {
            public let object: UnaryFilterGroup<T>
            public let keyPath: KeyPath<UnaryFilterGroup<T>, MTIImage?> = \.outputImage
            public let writableKeyPath: ReferenceWritableKeyPath<UnaryFilterGroup<T>, MTIImage?> = \.inputImage
        }
    }
    public init<T: Sequence>(sequence: T) where T.Element == MTIUnaryFilter, Value == MTIImage? {
        self.init(UnaryFilterGroup.Port(object: UnaryFilterGroup(sequence)))
    }
}
