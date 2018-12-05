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
	
	/**
	Gets the Element at the index if it exists.
	- parameters:
		- index: the index of the LinkedListValueNode
	- returns: the LinkedListValueNode at index
	*/
	func getElement(at index: Index) -> Element? {
		guard inBounds(index) else { return nil }
		return _getListNode(at: index).value
	}
	
	/**
	Gets the LinkedListValueNode at the index if it exists.
	- parameters:
		- index: the index of the LinkedListValueNode
	- returns: the LinkedListValueNode at index
	*/
	func getNode(at index: Index) -> LinkedListValueNode? {
		guard inBounds(index) else { return nil }
		return _getListNode(at: index)
	}
	
	func insert(node: LinkedListValueNode, at index: Index) -> LinkedListValueNode? {
		guard isOrphan(node) && (inBounds(index) || index == size)else { return nil }
		_insert(node: node, at: index)
		return node
	}
	
	/// Adds an item to the end of the list
	/// - parameters:
	/// 	- item: the value to add
	/// - returns: the LinkedListValueNode inserted
	@discardableResult func append(_ item: T) -> LinkedListValueNode {
		let node = LinkedListValueNode(item)
		if size == 0 {
			_addOnlyNode(node: node)
		} else {
			_appendSingle(node: node, after: tail!)
		}
		return node
	}
	
	/// Adds an item to the start of the list
	/// - parameters:
	/// 	- item: the value to add
	/// - returns: the LinkedListValueNode inserted
	@discardableResult func addFirst(_ item: T) -> LinkedListValueNode {
		let node = LinkedListValueNode(item)
		if size == 0 {
			_addOnlyNode(node: node)
		} else {
			_prependSingle(node: node, before: head!)
		}
		return node
	}
	
	/**
	Pop off the head of the list.
	- returns: The linkedListValueNode, head, an optional.
	*/
	func popHeadNode() -> LinkedListValueNode? {
		guard let head = head else { return nil }
		return _detachNode(head)
	}
	
	/**
	Pop off the tail of the list.
	- returns: The linkedListValueNode, tail, an optional.
	*/
	func popTailNode() -> LinkedListValueNode? {
		guard let tail = tail else { return nil }
		return _detachNode(tail)
	}
	
	/**
	Pop off the first item in the list with the node.
	- returns: The Element, at the head, an optional.
	*/
	func popFirst() -> T? {
		return popHeadNode()?.value
	}
	
	/**
	Pop off the last item in the list with the node.
	- returns: The Element, at the tail, an optional.
	*/
	func popLast() -> T? {
		return popTailNode()?.value
	}
	
	@discardableResult func removeElement(at index: Index) -> T {
		precondition(inBounds(index), "Removing an element out of bounds")
		return _detachNode(getNode(at: index)!).value
	}
	
	@discardableResult func removeNode(at index: Index) -> LinkedListValueNode {
		precondition(inBounds(index), "Removing an node out of bounds")
		return _detachNode(getNode(at: index)!)
	}
	
	func inBounds(_ index: Index) -> Bool {
		return index >= 0 && index < size
	}
	
	func isOrphan(_ node: LinkedListValueNode) -> Bool {
		return node._next == nil && node._prev == nil
	}
	
	func setNodeBefore(node: LinkedListValueNode, before: LinkedListValueNode) {
		_prependSingle(node: node, before: before)
	}
	
	func setNodeAfter(node: LinkedListValueNode, after: LinkedListValueNode) {
		_appendSingle(node: node, after: after)
	}
	
	func checkLinkedList() -> LinkedListError? {
		if size == 0 {
			return (head == nil && tail == nil) ? nil : LinkedListError.Message("Size said zero but not.")
		}
		if head == nil {
			return LinkedListError.Message("Non empty list with nil head")
		}
		if tail == nil {
			return LinkedListError.Message("Non empty list with nil tail")
		}
		if size == 1 && tail! != head! {
			return LinkedListError.Message("Size one list with non-matching head and tail.")
		}
		var visitedNodes = Set<LinkedListValueNode>()
		var actualSize = 0
		var currentNode: LinkedListValueNode? = head!
		var prevNode: LinkedListValueNode? = nil
		while let curr = currentNode {
			guard !visitedNodes.contains(curr) else {
				return .Message("There is a loop involving \(curr)")
			}
			guard actualSize < size else {
				return .Message("Actual size exceeds \(size)")
			}
			guard curr._prev == prevNode else {
				return .Message("Node \(curr)'s prev doesn't match it's prev's next.")
			}
			guard let prev = curr.prev else {
				return .Message("Node \(curr) doesn't have a prev")
			}
			prevNode = prev
			visitedNodes.insert(curr)
			currentNode = curr._next
			actualSize += 1
		}
		guard prevNode! == tail! else {
			return .Message("End node of the list: \(prevNode!) doesn't correspond to the tail")
		}
		return nil
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
		
		init(_ value: T, prev: LinkedListValueNode, next: LinkedListValueNode? = nil) {
			self.value = value
			super.init(next, prev)
		}
		init(_ value: T) {
			self.value = value
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
		get {
			precondition(inBounds(index))
			return getElement(at: index)!
		}
		set {
			precondition(inBounds(index))
			_insert(node: LinkedListValueNode(newValue), at: index)
		}
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

extension LinkedList {
	
	class LinkedListNodeIterator: IteratorProtocol {
		
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

// Subscript extension
extension LinkedList {
	
	subscript(index: Index) -> LinkedListValueNode {
		get {
			precondition(inBounds(index))
			return _getListNode(at: index)
		}
		set {
			precondition(isOrphan(newValue))
			precondition(inBounds(index))
			_replaceNode(node: _getListNode(at: index), with: newValue)
		}
	}
	
	subscript(safe index: Index) -> Iterator.Element? {
		get {
			return getElement(at: index)
		}
	}
}

enum LinkedListError: Error {
	case IndexOutOfBounds(i: Int)
	case SizeInaccurate
	case Looped
	case Message(String)
}

// Private utility functions
extension LinkedList {
	/// Replaces a node with its replacement. Assumes node is an orphan.
	private func _replaceNode(node: LinkedListValueNode, with replacement: LinkedListValueNode) {
		if head == node {
			head = replacement
		} else if let prev = node._prev {
			prev._next = replacement
			replacement._prev = node
		}
		if tail == node {
			tail = replacement
		} else if let next = node._next {
			next._prev = replacement
			replacement._next = node
		}
	}
	
	/// Get the LinkedListValue at index.
	/// Assumes index in bound
	private func _getListNode(at index: Index) -> LinkedListValueNode {
		var cur: LinkedListValueNode!
		var i = index
		if index < size / 2 {
			cur = head!
			while i > 0 {
				cur = cur.next!
				i -= 1
			}
			return cur
		}
		i = size - index - 1
		cur = tail!
		while i > 0 {
			cur = cur.prev!
			i -= 1
		}
		return cur
	}
	
	/// Detach the LinkedListValue at index.
	@discardableResult private func _detachNode(_ node: LinkedListValueNode) -> LinkedListValueNode {
		if size == 1 {
			head = nil
			tail = nil
		} else if node == head! {
			head = node._next
			node._next!._prev = nil
		} else if node == tail! {
			tail = node._prev
			node._prev!._next = nil
		} else {
			node._next!._prev = node._prev!
			node._prev!._next = node._next!
			node._next = nil
			node._prev = nil
		}
		size -= 1
		return node
	}
	
	/// Appends a single orphan node as the only node in list.
	/// This Set the LinkedList to have only this node.
	private func _addOnlyNode(node: LinkedListValueNode) {
		head = node
		tail = node
		size += 1
	}
	
	/// Appends a single orphan node at beginning of the index.
	/// important:
	/// * node is an orphan since we may or may not strip it
	func _insert(node: LinkedListValueNode, at index: Index) {
		if size == 0 {
			_addOnlyNode(node: node)
		}
		if index == 0 {
			_prependSingle(node: node, before: head!)
		}
		_appendSingle(node: node, after: _getListNode(at: index))
	}
	
	/// Appends a single orphan node, doesn't check for same LinkedList<T>
	private func _appendSingle(node: LinkedListValueNode, after: LinkedListValueNode) {
		node._prev = after
		if let preNext = after._next {
			node._next = preNext
			preNext._prev = node
		} else {
			tail = node
		}
		after._next = node
		size += 1
	}
	
	/// Appends a single orphan node, doesn't check for same LinkedList<T>
	private func _prependSingle(node: LinkedListValueNode, before: LinkedListValueNode) {
		node._next = before
		if let prePrev = before._prev {
			node._prev = prePrev
			prePrev._next = node
		} else {
			head = node
		}
		before._prev = node
		size += 1
	}
}
