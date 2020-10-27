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
// Очередь на выполнения (wait, signal)

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


//MARK: - Dispatch Group (используется если выполняются несколько задач)

/*class DispatchGroup{
  
    let group = DispatchGroup()
    let concurrentQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent)
     
    group.enter()
    concurrentQueue.async {
        print("test1")
        group.leave()
    }
     
    group.enter()
    concurrentQueue.async {
         print("test2")
         group.leave()
    }
     
    group.wait()
}
*/

//MARK: - Dispatch Barrier

class DispatchBarrierTest{
    
    private let queue = DispatchQueue(label: "DispatchBarrierTest", attributes: .concurrent)
    
    private var internalTest : Int = 0
    
    // setter
    func setTest(_ test: Int){
        queue.async(flags: .barrier) {
            self.internalTest = test
        }
    }
    //getter
    func getTest() -> Int{
        
        var tmp : Int = 0
        queue.sync {
            tmp = self.internalTest
        }
        return tmp
    }
}


//MARK: - Dispatch source
///Dispatch Source - Системный фундаментальный тип данных который позволяет взаимодействовать с системными событиями
///Timer Dispatch source - Тип Dispatch source, который генерирует периодические нотификации
///Signal Dispatch source - Тип Dispatch source, который взаимодействует с unix-сигналами
///Descriptor Dispatch source - Тип Dispatch source, который оповещает о том, что с файлом были произведены различные операции
///Process Dispatch source - Тип Dispatch source, который позволяет слушать события процесса


class timerDispatchSourceTest{
    private let source = DispatchSource.makeTimerSource()
    
    func test(){
        source.setEventHandler {
            print("Test")
        }
        source.schedule(deadline: .now(), repeating: 5)
        source.activate()
    }
}
// Output - test ... 5 sec ... test ... 5 sec ... test

//MARK: - Target Queue - сокращает context switch
