import Cocoa
class ReadWriteLock{
    private var lock = pthread_rwlock_t()
    private var attr = pthread_rwlockattr_t()
    
    private var test : Int = 0
    
    init(){
        pthread_rwlock_init(&lock, &attr)
    }
    
    var testProperty : Int{
        get{
            pthread_rwlock_rdlock(&lock)
            let temp = test
            pthread_rwlock_unlock(&lock)
            return temp
        }
        set{
            pthread_rwlock_wrlock(&lock)
            test = 10 // Any value
            pthread_rwlock_unlock(&lock)
        }
    }
}



/*
 
Read lock
 При чтении нельзя сделать запись.
 только после того, как все процессы завершатся.
Write lock
 блокируются read lock
 
 */


class SpinLockTest{ // похож на цикл while проверяя каждый раз освободился ли ресурс. Не эффективный, ресурсозатратный,но быстродейтсвующий
    private var lock = OS_SPINLOCK_INIT
    
    func test(){
        OSSpinLockLock(&lock)
        //Do something
        OSSpinLockUnlock(&lock)
    }
}

class UnfairLockTest{ // Работает по другому, приоритет идет кто больше обращается к ресурсу вне зависимости от очереди
    private var lock = os_unfair_lock_s()
    
    func test(){
        os_unfair_lock_lock(&lock)
        // Do smth
        os_unfair_lock_unlock(&lock)
    }
}

//MARK: - Главные проблемы потоков

/*
 DeadLock - Потоки пытаются обратиться к уже захваченным ресурсам, в следствие чего программа зависает
 LiveLock -  Оба потока выполняют бесполезную работу
 Priority inversion -  Низкоприоритетный поток захватывает ресурс, остальные потоки ждут
 
 */
