import Cocoa

var str = "Hello, playground"


class QosThreads{
    
    func test(){
        let thread = Thread{
            print("Test")
            print(qos_class_self())
        }
        thread.qualityOfService = .userInteractive // userInteractive, user Initiated, Utility, Background
        thread.start()
        print(qos_class_main())
    }
    
}

// Mutex - Только поток обратиться к ресурсу.
public class NSLockTest {
    private let lock = NSLock()
    
    func test(i: Int){
        lock.lock()
        //do smth
        lock.unlock()
    }
}

// Recursive Mutex
/*
Позволяет много раз захватывать поток.
Если не будет unlock будет использовать ресурс до того момента, пока сам не закончит использование
*/

 class RecursiveMutex {
    private let lock = NSRecursiveLock()
    
    public func test1(){
        lock.lock()
        test2()
        lock.unlock() // освобождение ресурса
    }
    
   public func test2(){
        lock.lock()
        print("It's test2 Recursive in RecursiveMutex")
        lock.unlock()
    }
}

// Lection 1.6

class MutexConditionTest {
    private var condition = pthread_cond_t()
    private var mutex = pthread_mutex_t()
    private var check = false
    
    init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    func test1() {
        print("MutexConditionTest - start")
        pthread_mutex_lock(&mutex)
        print("MutexConditionTest - lock")
        while !check {
            print("MutexConditionTest -> !check -> cycle loop")
            pthread_cond_wait(&condition, &mutex)
        }
        
        print("MutexConditionTest - DO SOME WORK")
        pthread_mutex_unlock(&mutex)
        print("MutexConditionTest - unlock")
    }
    
    /// это должно выполняться из другого потока !!!
    func test2() {
        print("MutexConditionTest - test2() - start")
        pthread_mutex_lock(&mutex)
        print("MutexConditionTest - test2() - locked mutex")
        check = true
        pthread_cond_signal(&condition)
        print("MutexConditionTest - test2() - unlocking mutex")
        pthread_mutex_unlock(&mutex)
        print("MutexConditionTest - test2() - end")
    }
}

//Done: Тут какая-то бага

let mutexConditionTest = MutexConditionTest()

let thread1 = Thread {
    mutexConditionTest.test1()
}
thread1.start()

let thread2 = Thread {
    mutexConditionTest.test2()
}
thread2.start()
