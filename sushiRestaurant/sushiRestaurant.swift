//
//  sushiRestaurant.swift
//  AlgorithmsDataStructures
//
//  Created by Adriano Gaiotto de Oliveira on 2021-04-01.
//

import Foundation

public final class Stack<E> : Sequence {
    
    /// beginning of stack
    private var first: Node<E>? = nil
    
    /// number of elements in stack
    private(set) var count: Int = 0
    
    /// Initializes an empty stack.
    public init() {}
    
    
    /// add an item
    /// - Parameter item: the item to add to this stack
    public func push(item: E) {
        let oldFirst = first
        first = Node<E>(item: item, next: oldFirst)
        count += 1
    }
    
    /// removes and returns the item least recently added to the stack
    /// - Returns: the item removed of this stack
    public func pop() -> E? {
        if first != nil {
            let temp = first
            first = first?.next
            count -= 1
            return temp?.item
        }
        return nil
    }
    
    /// returns the item least recently added to the stack
    /// - Returns: the item least recently added to this stack
    public func peek() -> E? {
        if first != nil {
            return first?.item
        }
        return nil
    }
    
    /// verify if this queue is empty?
    /// - Returns: true or false
    public func isEmpty() -> Bool {
        return first == nil
    }
    
    public func makeIterator() -> StackIterator<E> {
        return StackIterator<E>(first)
    }
}

extension Stack {
    /// helper linked list node class
    fileprivate class Node<E> {
      fileprivate var item: E
      fileprivate var next: Node<E>?
      fileprivate init(item: E, next: Node<E>? = nil) {
        self.item = item
        self.next = next
      }
    }
}

extension Stack {
    public struct StackIterator<E> : IteratorProtocol {
        public typealias Element = E
        
        private var current: Node<E>?
        
        fileprivate init(_ first: Node<E>?) {
          self.current = first
        }
        
        public mutating func next() -> E? {
          if let item = current?.item {
            current = current?.next
            return item
          }
          return nil
        }
    }
    
}

struct Edge: Comparable {
    static func < (lhs: Edge, rhs: Edge) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    let to: Int
    let distance: Int
}

func bfsStack(node: Int, check: inout [Bool], distances: inout [Int], adjList: inout [[Edge]], sushiRestaurants: [Int]) {
    let q = Stack<Int>()
    var countRest = 1
    q.push(item: node)
    while !q.isEmpty(){
        let x = q.peek()!
        check[x] = true
        if adjList[x].count == 1 && check[adjList[x][0].to] && !sushiRestaurants.contains(x) {
            let _ = q.pop()!
            adjList[adjList[x][0].to].remove(at: findIndex(x, adjList[adjList[x][0].to]))
            adjList[x].remove(at: 0)
        } else if visitedEdges( &check, adjList[x]) {
            let _ = q.pop()!
        } else {
            
            for edge in adjList[x] {
                if !check[edge.to] {
                    distances[edge.to] = distances[x] + edge.distance
                    q.push(item: edge.to)
                    if sushiRestaurants.contains(edge.to) {
                        countRest += 1
                    }
                }
            }
            
            if countRest == sushiRestaurants.count  {
                
                while !q.isEmpty(){
                    if !check[q.peek()!] {
                        if sushiRestaurants.contains(q.peek()!) {
                            check[q.pop()!] = true
                        } else {
                            let _ = q.pop()!
                        }
                    } else {
                        let _ = q.pop()!
                    }
                }
                break
            }
            
        }
    }

    for x in 0..<check.count {
        if !check[x] {
            for i in adjList[x] {
                adjList[i.to].remove(at: findIndex(x, adjList[i.to]))
            }
            adjList[x].removeAll()
        }
    }
    
}

func solution() {
    
    let firstLine = readLine()!.split(separator: " ")
    
    let n = Int(firstLine[0])!
    let m = Int(firstLine[1])!
    
    let inputRestaurants = readLine()!.split(separator: " ")
    var sushiRestaurants = [Int]()
    
    var adjList = [[Edge]](repeating: [], count: n + 1)
    
    for r in 0..<m {
        sushiRestaurants.append(Int(inputRestaurants[r])!)
    }
    
    for _ in 0..<n - 1 {
        
        let edge = readLine()!.split(separator: " ")
        
        let u = Int(edge[0])!
        let v = Int(edge[1])!
        
        adjList[u].append(Edge(to: v, distance: 1))
        adjList[v].append(Edge(to: u, distance: 1))
        
    }
    
    var start = sushiRestaurants[0]
    
    var distances = [Int](repeating: 0, count: n + 1)
    var check = [Bool](repeating: false, count: n + 1)
    
    bfsStack(node: start, check: &check, distances: &distances, adjList: &adjList, sushiRestaurants: sushiRestaurants)
    
    for i in 0...n-1 {
        if distances[i] > distances[start] && sushiRestaurants.contains(i){
            start = i
        }
    }
    
    var tr = 0
    for i in adjList {
        tr += i.count
    }
    
    check = [Bool](repeating: false, count: n + 1)
    distances = [Int](repeating: 0, count: n + 1)
    
    bfsStack(node: start, check: &check, distances: &distances, adjList: &adjList, sushiRestaurants: sushiRestaurants)
    
    for i in 0...n-1 {
        if distances[i] > distances[start] && sushiRestaurants.contains(i){
            start = i
        }
    }
    
    print((tr/2) * 2 - distances[start])
}

func findIndex(_ node: Int, _ list: [Edge]) -> Int {
    
    for i in 0..<list.count {
        if list[i].to == node {
            return i
        }
    }
    return -1
}

func visitedEdges(_ check: inout [Bool], _ list: [Edge]) -> Bool {
    var countVisited = 0
    for i in 0..<list.count {
        if check[list[i].to]{
            countVisited += 1
        }
    }
    if list.count == countVisited {
        return true
    } else {
        return false
    }
}

solution()
