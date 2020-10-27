import Cocoa


let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 1
operationQueue.addOperation {
     print("test1")
}
 
operationQueue.addOperation {
     print("test2")
}
