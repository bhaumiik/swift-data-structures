//
//  BinarySearchTree.swift
//  BinarySearchTreeTests
//
//  Created by Bhaumik on 2020-07-11.
//  Copyright © 2020 Bhaumik. All rights reserved.
//

import Foundation

public class BinarySearchTree<T: Comparable> {
    // all left adjacent children <= n <= all right adjacent children
    var value: T
    var parent: BinarySearchTree?
    var left: BinarySearchTree?
    var right: BinarySearchTree?
    
    public var isRootNode: Bool {
        return self.parent == nil
    }
    
    public var isLeftChild: Bool {
      return parent?.left === self
    }

    public var isRightChild: Bool {
      return parent?.right === self
    }
    
    public var isLeaf: Bool {
        return self.left == nil && self.right == nil
    }
    
    init(value: T) {
        self.value = value
    }
    
    convenience init(array: [T]) {
        assert(array.count > 0)
        self.init(value: array.first!)
        for value in array.dropFirst() {
            self.insert(value: value)
        }
    }
    
    /// Inserts node in the tree.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    public func insert(value: T) {
        if value < self.value {
            if let left = self.left {
                left.insert(value: value)
            } else {
                self.left = BinarySearchTree(value: value)
                self.left?.parent = self
            }
        } else {
            if let right = self.right {
                right.insert(value: value)
            } else {
                self.right = BinarySearchTree(value: value)
                self.right?.parent = self
            }
        }
    }
    
    /// - Returns: Finds the node with specified value.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    public func search(value: T) -> BinarySearchTree? {
        if self.value == value {
            return self
        }
        
        if value < self.value {
            if let foundLeft = self.left?.search(value: value) {
                return foundLeft
            }
        } else {
            if let foundRight = self.right?.search(value: value) {
                return foundRight
            }
        }
        return nil
    }
    
    /// Deletes node in the tree.
    /// - Returns: Returns the deleted node.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    @discardableResult public func delete() -> BinarySearchTree? {
        var replacement: BinarySearchTree?
        if let left = self.left {
            replacement = left.findMaximum()
        } else if let right = self.right {
            replacement = right.findMinimum()
        } else {
            replacement = nil
        }
        
        replacement?.delete()
        
        // update reference for children
        replacement?.left = self.left
        replacement?.right = self.right
        self.left?.parent = replacement
        self.right?.parent = replacement
        
        // update reference for parent
        if self.isLeftChild {
            self.parent?.left = replacement
        } else if self.isRightChild {
            self.parent?.right = replacement
        }
        replacement?.parent = self.parent
        
        self.parent = nil
        self.left = nil
        self.right = nil
        
        return replacement
    }
    
    /// - Returns: Returns the leftmost descendent.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    public func findMinimum() -> BinarySearchTree {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    /// - Returns: Returns the rightmost descendent.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    public func findMaximum() -> BinarySearchTree {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }
    
    /// Calculates the height of this node.
    /// - Complexity: O(*n*), where *n* is the number of nodes in tree.
    public func getHeight() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.getHeight() ?? 0, right?.getHeight() ?? 0)
        }
    }
    
    /// Calculates depth of this node.
    /// - Complexity: O(*h*), where *h* is the height of the tree.
    public func getDepth() -> Int {
        var node = self
        var depth: Int = 0
        while node.parent != nil {
            node = node.parent!
            depth += 1
        }
        return depth
    }
}

// MARK: - Traversal
extension BinarySearchTree {
    public func traverseInOrder(process: (T) -> Void) {
        self.left?.traverseInOrder(process: process)
        process(self.value)
        self.right?.traverseInOrder(process: process)
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        process(self.value)
        self.left?.traversePreOrder(process: process)
        self.right?.traversePreOrder(process: process)
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        self.left?.traversePostOrder(process: process)
        self.right?.traversePostOrder(process: process)
        process(value)
    }
}

// MARK: - Debugging
extension BinarySearchTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}
