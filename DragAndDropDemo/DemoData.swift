//
//  DemoData.swift
//  DragAndDropDemo
//
//  Created by gentle on 2017/07/21.
//  Copyright © 2017年 gentlesoft. All rights reserved.
//

import Foundation

class DemoData {
    struct Element {
        var text: String
        var children: [Element]
        
        init(text: String, children: [Element] = []) {
            self.text = text
            self.children = children
        }
    }
    
    private init() {}
    
    static let shared = DemoData()

    var data: [Element] = [
        Element(text: "Alpha", children: [
            Element(text: "One"),
            Element(text: "Twe"),
            Element(text: "Three"),
        ]),
        Element(text: "Bravo", children: [
            Element(text: "uno"),
            Element(text: "dos"),
            Element(text: "tres"),
            Element(text: "cuatro"),
        ]),
        Element(text: "Charlie", children: [
        ]),
    ]
    
    func count(indexes: [Int]) -> Int {
        var res = 0
        self.perfomData(data: &data, parents: indexes) { (data) in
            res = data.count
        }
        return res
    }
    
    func text(indexes: [Int]) -> String {
        var text = ""
        self.perfomData(data: &data, parents: Array<Int>(indexes.prefix(indexes.count - 1))) { (elements) in
            text = elements[indexes.last!].text
        }
        return text
    }
    
    func append(text: String, parents: [Int]) {
        self.perfomData(data: &data, parents: parents) { (elements) in
            elements.append(Element(text: text))
        }
    }
    
    func insert(text: String, at index: Int, parents: [Int]) {
        self.perfomData(data: &data, parents: parents) { (elements) in
            elements.insert(Element(text: text), at: index)
        }
    }
    
    func remove(at indexes: [Int]) {
        self.perfomData(data: &data, parents: Array<Int>(indexes.prefix(indexes.count - 1))) { (elements) in
            elements.remove(at: indexes.last!)
        }
    }
}

fileprivate extension DemoData {
    func perfomData(data: inout [Element], parents: [Int], exec: (inout [Element]) -> Void) {
        if let index = parents.first {
            self.perfomData(data: &data[index].children,
                            parents: Array<Int>(parents.suffix(from: 1)),
                            exec: exec)
        } else {
            exec(&data)
        }
    }
}
