import Cocoa

class QosThreadTest{
    func test(){
            let thread = Thread {
                print("Hello")
                print(qos_class_self())
            }
        thread.qualityOfService = .userInteractive
        thread.start()
        print(qos_class_main())
    }
}


