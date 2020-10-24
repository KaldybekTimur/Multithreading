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


//MARK: - Semaphore

class SemaphoreSimple{
    private let semaphore = DispatchSemaphore(value: 0) // value - кол-во потоков обращающихся к ресурсу.
    func test(){
        DispatchQueue.global().async { // глобальная очередь и метод asynс()
            sleep(1)
            print("1")
            self.semaphore.signal()
        }
        semaphore.wait()
        print("2")
    }
} // output: 1 2


class SemaphoreTest2{
    private let semaphore = DispatchSemaphore(value: 2) // 2 - кол-во потоков обращающихся к ресурсу
    
    func doWork(){
        semaphore.wait()
        sleep(3)
        print("Test")
        semaphore.signal()
    }
    
    func Test(){
        DispatchQueue.global().async {
            self.doWork()
        }
        DispatchQueue.global().async {
            self.doWork()
        }
        DispatchQueue.global().async {
            self.doWork()
        }
    }
}
// output - Test Test ... 3 seconds ... Test, потому что в начале стоит DispatchSemaphore(value: 2)







