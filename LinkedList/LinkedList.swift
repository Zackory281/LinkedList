//
//  LinkedList.swift
//  LinkedList
//
//  Created by Zackory Cramer on 12/4/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import Foundation

class LinkedList<T> {
	
	let sentinel: LinkedListHeadNode
	var head: LinkedListValueNode? { get { return sentinel._next } set { sentinel._next = newValue}}
	var tail: LinkedListValueNode? { get { return sentinel._prev } set { sentinel._prev = newValue}}
	var size: Int
	
	init() {
		self.sentinel = LinkedListHeadNode()
		self.size = 0
	}
	
	func getItem(at index: Index) -> Element {
		precondition(index < size, "Getting an item out of bounds")
		var cur: LinkedListValueNode!
		var i = index
		if index < size / 2 {
			cur = head!
			while i > 0 {
				cur = cur.next!
				i -= 1
			}
			return cur.value
		}
		i = size - index
		cur = tail!
		while i > 0 {
			cur = cur.prev!
			i -= 1
		}
		return cur.value
	}
	
	/// Adds an item to the end of the list
	/// - parameters:
	/// 	- item: the value to add
	/// - returns: the LinkedListValueNode inserted
	func append(_ item: T) -> LinkedListValueNode {
		let node = LinkedListValueNode(linkedList: self, item)
		if size == 0 {
			head = node
			tail = node
			size += 1
		} else {
			appendSingle(node: node, after: tail!)
		}
		return node
	}
	
	/// Adds an item to the start of the list
	/// - parameters:
	/// 	- item: the value to add
	/// - returns: the LinkedListValueNode inserted
	func addFirst(_ item: T) -> LinkedListValueNode {
		let node = LinkedListValueNode(linkedList: self, item)
		if size == 0 {
			head = node
			tail = node
			size += 1
		} else {
			prependSingle(node: node, before: head!)
		}
		return node
	}
	
	func remove(node: LinkedListValueNode) {
		guard let
	}
	
	private func detachNode(_ node: LinkedListValueNode) {
		if let next = node._next {
			next._prev = nil
		}
		if let prev = node._prev {
			prev._next = nil
		}
		node.next = nil
		node.prev = nil
		size -= 1
	}
	
	private func addNo(_ item: T) -> LinkedListValueNode {
		let node = LinkedListValueNode(linkedList: self, item)
		if size == 0 {
			head = node
			tail = node
			size += 1
		} else {
			prependSingle(node: node, before: head!)
		}
		return node
	}
	
	/// Appends a single orphan node, doesn't check for same LinkedListObj
	private func appendSingle(node: LinkedListValueNode, after: LinkedListValueNode) {
		node._prev = after
		after._next = node
		if let preNext = after._next {
			node._next = preNext
			preNext._prev = node
		} else {
			tail = node
		}
		size += 1
	}
	
	/// Appends a single orphan node, doesn't check for same LinkedListObj
	private func prependSingle(node: LinkedListValueNode, before: LinkedListValueNode) {
		node._next = before
		before._prev = node
		if let prePrev = before._prev {
			node._prev = prePrev
			prePrev._next = node
		} else {
			head = node
		}
		size += 1
	}
	
	@discardableResult
	func setNext(of node: LinkedListValueNode, to targetNode: LinkedListValueNode?) -> Bool {
		guard node.linkedList === self else {
			print("SetNext node of same parent.")
			return false
		}
		guard let targetNode = targetNode, targetNode.linkedList === self else {
			print("SetNext target of same parent.")
			return false
		}
		print("SetNext dont work")
		return false
	}
	
	@discardableResult
	func setPrev(of node: LinkedListValueNode, to targetNode: LinkedListValueNode?) -> Bool {
		guard node.linkedList === self else {
			print("setPrev node of same parent.")
			return false
		}
		guard let targetNode = targetNode, targetNode.linkedList === self else {
			print("setPrev target of same parent.")
			return false
		}
		print("setPrev dont work")
		return false
	}
	
	class LinkedListHeadNode {
		fileprivate var _next: LinkedListValueNode?
		fileprivate weak var _prev: LinkedListValueNode?
		
		init(_ next: LinkedListValueNode? = nil, _ prev: LinkedListValueNode? = nil) {
			self._next = next
			self._prev = prev
		}
	}
	
	class LinkedListValueNode: LinkedListHeadNode, Hashable {
		
		var prev: LinkedListValueNode? {get{return _prev}}
		var next: LinkedListValueNode? {get{return _next}}
		var value: T
		unowned let linkedList: LinkedList<T>
		
		init(linkedList: LinkedList<T>, _ value: T, prev: LinkedListValueNode, next: LinkedListValueNode? = nil) {
			self.value = value
			self.linkedList = linkedList
			super.init(next, prev)
		}
		init(linkedList: LinkedList<T>, _ value: T) {
			self.value = value
			self.linkedList = linkedList
			super.init()
		}
		
		func hash(into hasher: inout Hasher) {
			hasher.combine(ObjectIdentifier(self))
		}
		
		static func == (lhs: LinkedList<T>.LinkedListValueNode, rhs: LinkedList<T>.LinkedListValueNode) -> Bool {
			return lhs === rhs
		}
	}
}

extension LinkedList: Collection {
	
	typealias Index = Int
	typealias Element = T
	
	var startIndex: Index { return 0 }
	var endIndex: Index { return size }
	
	subscript(index: Index) -> Iterator.Element {
		get { return getItem(at: index) }
	}
	
	func index(after i: Index) -> Index {
		return i + 1
	}
	
	typealias Iterator = LinkedListIterator
	
	func makeIterator() -> Iterator {
		return LinkedListIterator(start: head)
	}
	
	class LinkedListIterator: IteratorProtocol {
		
		weak var currentNode: LinkedListValueNode?
		
		init(start: LinkedListValueNode?) {
			currentNode = start
		}
		
		func next() -> T? {
			guard let cnode = currentNode?.value else { return nil }
			currentNode = currentNode!._next
			return cnode
		}
	}
}

enum LinkedListError: Error {
	case IndexOutOfBounds(i: Int)
}
