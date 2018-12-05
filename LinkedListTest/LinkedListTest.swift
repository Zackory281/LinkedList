//
//  LinkedListTest.swift
//  LinkedListTest
//
//  Created by Zackory Cramer on 12/4/18.
//  Copyright © 2018 Aoil Applications. All rights reserved.
//

import XCTest

class LinkedListTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        let linkedList = LinkedList<O>()
		for i in 0...9 {
			linkedList.append(O(i))
		}
		XCTAssertEqual(linkedList.size, 10)
		var i = 0
		for element in linkedList {
			XCTAssertEqual(element.i, i)
			i += 1
		}
		
		i = 0
		while i < linkedList.size {
			XCTAssertEqual(linkedList[i].i, i)
			i += 1
		}
		linkedList.removeNode(at: 9)
		linkedList.removeNode(at: 8)
		i = 0
		while i < linkedList.size {
			XCTAssertEqual(linkedList[i].i, i)
			i += 1
		}
    }
	
	func testSegmentation1() {
		let linkedList = LinkedList<O>()
		linkedList.addFirst(O(3))
		linkedList.addFirst(O(2))
		linkedList.addFirst(O(1))
		linkedList.addFirst(O(0))
		XCTAssertEqual(linkedList.size, 4)
		for i in 0...3 {
			XCTAssertEqual(linkedList[i].i, i)
		}
		let node = linkedList.removeNode(at: 2)
		XCTAssertEqual(linkedList.size, 3)
		XCTAssertEqual(linkedList[1].i, 1)
		linkedList.setNodeAfter(node: node, after: linkedList.tail!)
		XCTAssertEqual(linkedList.size, 4)
		XCTAssertEqual(linkedList[0].i, 0)
		XCTAssertEqual(linkedList[1].i, 1)
		XCTAssertEqual(linkedList[2].i, 3)
		XCTAssertEqual(linkedList[3].i, 2)
	}
	
	func testSegmentation2() {
		let linkedList = LinkedList<O>()
		linkedList.addFirst(O(3))
		linkedList.addFirst(O(2))
		linkedList.addFirst(O(1))
		linkedList.addFirst(O(0))
		XCTAssertEqual(linkedList.size, 4)
		let head = linkedList.popHeadNode()!
		let tail = linkedList.popTailNode()!
		XCTAssertEqual(linkedList.size, 2)
		XCTAssertEqual(tail, linkedList.insert(node: tail, at: 0))
		print(linkedList.checkLinkedList())
		XCTAssertEqual(linkedList.size, 3)
		print(linkedList.checkLinkedList())
		XCTAssertEqual(linkedList.tail, linkedList[0])
		print(linkedList.checkLinkedList())
		XCTAssertEqual(head, linkedList.insert(node: head, at: 3))
		XCTAssertEqual(linkedList.size, 4)
		XCTAssertEqual(linkedList.head, linkedList[3])
	}
	
	class O {
		let i: Int
		init(_ i: Int) {
			self.i = i
		}
	}
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
