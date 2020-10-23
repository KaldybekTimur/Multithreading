import Cocoa

//MARK: - GCD


class QueueTest{
    
    private let serialQueue = DispatchQueue(label: "serialTest") // последовательно
    private let concurrentQueue = DispatchQueue(label: "concurrentTest", attributes: .concurrent) //параллельно
    
    
}



class QueueTest2{
    private let globalQueue = DispatchQueue.global() // системные задачи, не стоит нагружать большими задачаими, все являются concurrent - паралелльные
    private let mainQueue = DispatchQueue.main // основные задачи главный поток - serial последовательно
}


//MARK: - Async and Sync - методы взаимодействия с очередями

/*
 async - управление возращается вызывающему потоку
 sync - ожидает выполнения задачи

 async after
 */

class SyncVsAsync{ // Serial queue - по очереди
    private let serialQueue = DispatchQueue(label: "serialTest")
    
    func testSerial(){
        serialQueue.async {
            print("test1")
        }
        serialQueue.async {
            sleep(2)
            print("test2")
        }
        serialQueue.sync {
            print("test3")
        }
        serialQueue.sync {
            print("test4")
        }
    }
}
 // выведет: test3 ...(test1,test2)... test4

class AsyncVsSyncTest2{ // concurrent queue - одновременно
    private let concurrentQueue = DispatchQueue(label: "Concurrent queue" )
    
    func testConcurrent(){
        
        concurrentQueue.async {
            print("test1")
        }
        
        concurrentQueue.async {
            sleep(3)
            print("test2")
        }
        
        concurrentQueue.sync {
            print("test3")
        }
        
        concurrentQueue.sync {
            print("test4")
        }
        
    }
}





