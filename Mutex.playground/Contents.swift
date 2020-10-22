import Cocoa
//MARK: - Creating Simple Mutex
public class NSLockTest{
    private let lock = NSLock()
    
    func test(i: Int){
        lock.lock()
        print("Ordinary Mutex")
        lock.unlock()
    }
}

class RecursiveMutexLock{
    private let lock = NSRecursiveLock()
    
    public func test(){
        lock.lock()
        test2()
        lock.unlock()
    }
    public func test2(){
        lock.lock()
        print("Recursive Mutex")
        lock.unlock()
    }
}


class ConditionTest{
    private let condition = NSCondition()
    private var check : Bool = false
    
    func test(){
        condition.lock()
        while(!check){
            condition.wait()
        }
    // Все полезные действия здесь
        condition.unlock()
    }
    
    func test2(){
        condition.lock()
        check = true
        condition.signal()
    // Как только check = true и метод вызывается signal, можно выполнять работу
        condition.unlock()
    }
}
