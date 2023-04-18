
#if os(OSX)
import AppKit

open class ZTreeNode: NSTreeNode {
    
    open var identifier: String = ""
    
    private var representedObj: Any?
    
    override open var representedObject: Any? {
        get{
            return representedObj
        }
        set(newValue){
            representedObj = newValue
        }
    }
    
    open func objectFor(identifier: String) -> ZTreeNode? {
        guard let children = self.children as? [ZTreeNode] else { return nil }
        return ZTreeNode.objectFor(identifier: identifier, nodes: children)
    }
    
    public static func objectFor(identifier: String, nodes: [ZTreeNode]) -> ZTreeNode? {
        let result = ZTreeNode.objectsFor(identifier: identifier, nodes: nodes, firstFind: true)
        return result.first
    }
    
    public static func objectsFor(identifier: String, nodes: [ZTreeNode]) -> [ZTreeNode] {
        return ZTreeNode.objectsFor(identifier: identifier, nodes: nodes, firstFind: false)
    }
    
    private static func objectsFor(identifier: String, nodes: [ZTreeNode], firstFind: Bool) -> [ZTreeNode] {
        var objects: [ZTreeNode] = []
        
        for node in nodes {
            
            if identifier == node.identifier {
                objects.append(node)
                if firstFind { break }
            }
            
            if let children = node.children as? [ZTreeNode] {
                let result = objectsFor(identifier: identifier, nodes: children, firstFind: firstFind)
                objects.append(contentsOf: result)
                if firstFind, !result.isEmpty { break }
            }
        }
        return objects
    }
}

extension NSTreeNode {
    
    open func isChildOrDescendentChild(childNode: NSTreeNode) -> Bool {
        guard let childNodes = children else { return false }
        if childNodes.contains(childNode) {
            return true
        } else {
            for node in childNodes {
                if node.isChildOrDescendentChild(childNode: childNode) {
                    return true
                }
            }
        }
        return false
    }
    
    public func getNextNode(ignoreChildren: Bool = false) -> ZTreeNode? {
        var nextNode: ZTreeNode? = nil
        if ignoreChildren { //this indicates we have already checked for a child node
            let nextLeafIndex = (indexPath.last ?? 0) + 1
            if let parentNode = parent as? ZTreeNode, let children = parentNode.children {
                if children.count > nextLeafIndex {
                    nextNode = children[nextLeafIndex] as? ZTreeNode //next node is the sibling of current node
                } else {
                    nextNode = parentNode.getNextNode(ignoreChildren: true) //backtracking to find the nextNode - which maybe a sibling of an ancestor
                }
            }
        } else {
            if let children = children, children.count > 0 {
                return children[0] as? ZTreeNode //nextNode will be the first child of the current node
            } else {
                nextNode = getNextNode(ignoreChildren: true) //backtracking to find the nextNode - which maybe a sibling of an ancestor
            }
        }
        return nextNode
    }
    
    public func noOfDescendents() -> Int {
        var count: Int = 0
        guard let childNodes = children else { return count }
        for node in childNodes {
            count = count + node.noOfDescendents() + 1 // +1 is for counting the visited childNode
        }
        return count
    }
}
#endif
