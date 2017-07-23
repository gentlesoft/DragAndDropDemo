//
//  TodoData.swift
//  TodoDemo
//
//  Created by gentle on 2017/07/21.
//  Copyright © 2017年 gentlesoft. All rights reserved.
//

import Foundation

class TodoData {
    struct Element {
        var text: String
        var children: [Element]
        
        init(text: String, children: [Element] = []) {
            self.text = text
            self.children = children
        }
    }
    
    private init() {}
    
    static let shared = TodoData()

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
        return self.count(data: data, indexes: indexes)
    }
    
    func text(indexes: [Int]) -> String {
        return self.text(data: data, indexes: indexes)
    }
    
    func append(text: String, parents: [Int]) {
        return self.append(data: &data, text: text, indexes: parents)
    }
    
    func insert(text: String, at index: Int, parents: [Int]) {
        return self.insert(data: &data, text: text, at: index, indexes: parents)
    }
    
    func remove(at indexes: [Int]) {
        return self.remove(data: &data, at: indexes)
    }
}

fileprivate extension TodoData {
    func insert(data: inout [Element], text: String, at index: Int, indexes: [Int]) {
        if let i = indexes.first {
            self.insert(data: &data[i].children, text: text, at: index, indexes: Array<Int>(indexes.suffix(from: 1)))
        } else {
            data.insert(Element(text: text), at: index)
        }
    }
    
    func count(data: [Element], indexes: [Int]) -> Int {
        guard let index = indexes.first else { return data.count }
        
        return self.count(data: data[index].children, indexes: Array<Int>(indexes.suffix(from: 1)))
    }
    
    func text(data: [Element], indexes: [Int]) -> String {
        let element = data[indexes[0]]
        guard indexes.count > 1 else { return element.text }
        
        return self.text(data: element.children, indexes: Array<Int>(indexes.suffix(from: 1)))
    }
    
    func append(data: inout [Element], text: String, indexes: [Int]) {
        if let index = indexes.first {
            self.append(data: &data[index].children, text: text, indexes: Array<Int>(indexes.suffix(from: 1)))
        } else {
            data.append(Element(text: text))
        }
    }
    
    func remove(data: inout [Element], at indexes: [Int]) {
        if indexes.count > 1 {
            self.remove(data: &data[indexes[0]].children, at: Array<Int>(indexes.suffix(from: 1)))
        } else {
            data.remove(at: indexes[0])
        }
    }
}
