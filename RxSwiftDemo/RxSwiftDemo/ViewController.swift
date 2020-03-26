//
//  ViewController.swift
//  RxSwiftDemo
//
//  Created by 华惠友 on 2020/3/16.
//  Copyright © 2020 huayoyu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class ViewController: UIViewController {
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    
    @IBOutlet weak var lb1: UILabel!
    @IBOutlet weak var lb2: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate lazy var bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn1.rx.tap.subscribe { (event) in
            let vc = SecondViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }.disposed(by: bag)
//        test5()
        
    }
}


struct Student {
    var socre: BehaviorRelay<Double>
}

extension ViewController {
    
    func test5() {
        let behaviorSub = BehaviorSubject(value: "10")
        // 延迟销毁，跟vc一起销毁
        behaviorSub.subscribe { (event) in
            print("BehaviorSubject:\(event)")
        }.disposed(by: bag)
        // 调用完就销毁了，接收不到后面的事件了
        behaviorSub.subscribe { (event) in
            print("BehaviorSubject:\(event)")
        }.dispose()
        behaviorSub.onNext("d")
    }
    
    func test4() {
        // 1.Swift中使用map
        let array = [1, 2, 3, 4]
        let newArray = array.map { $0 * $0 }
        print(newArray)
        
        // 2.RxSwift中map函数的使用
        // 通过传入一个函数闭包把原来的sequence转变为一个新的sequence的操作
        Observable.from([1, 2, 3, 4])
            .map({ $0 * $0})
            .subscribe { (event) in
                print(event)
        }.disposed(by: bag)
        print("-------------------")
        
        // 3.flatmap使用
        // 将一个sequence转换为一个sequences，当你接收一个sequence的事件，你还想接收其他sequence发出的事件的话可以使用flatMap，她会将每一个sequence事件进行处理以后，然后再以一个sequence形式发出事件
        let stu1 = Student(socre: BehaviorRelay(value: 90.5))
        let stu2 = Student(socre: BehaviorRelay(value: 100.5))
        let stu3 = Student(socre: BehaviorRelay(value: 60.5))
        
        let stu1BehaviorRelay = BehaviorRelay(value: stu1)
        /**
         stu1BehaviorRelay.asObservable().flatMap { (student) -> Observable<Double> in
             return student.socre.asObservable()
         }.subscribe { (score) in
             print(score)
         }.disposed(by: bag)
         // 这里将stu2赋值给了stu1BehaviorRelay，但是出现的问题是，stu1和stu2都被订阅了
         // 可以使用flatMapLatest避免这个问题
         stu1BehaviorRelay.accept(stu2)
         stu1.socre.accept(10)
         stu2.socre.accept(20)
         */
        print("-------------------")
        // 现在就没有上面的问题了
        stu1BehaviorRelay.asObservable().flatMapLatest { (student) -> Observable<Double> in
            return student.socre.asObservable()
        }.subscribe { (event) in
            print(event)
        }.disposed(by: bag)
        stu1BehaviorRelay.accept(stu2)
        stu1.socre.accept(10)
        stu2.socre.accept(20)
    }
    
    
    
    
    
    
    
    func test3() {
        // 1.当你订阅PublishSubject的时候，你只能接收到订阅他之后发生的事件。
        // subject.onNext()发出onNext事件，对应的还有onError()和onCompleted()事件
        let publishSub = PublishSubject<String>()
        publishSub.onNext("订阅前发出的事件")
        publishSub.subscribe { (event) in
            print("PublishSubject:\(event)")
        }.disposed(by: bag)
        publishSub.onNext("订阅后发出的事件")
        print("-------------------")
        
        // 2.当你订阅ReplaySubject的时候，你可以接收到订阅他之后的事件，但也可以接受订阅他之前发出的事件，接受几个事件取决与bufferSize的大小
        // let replaySub = ReplaySubject<String>.create(bufferSize: 2)
        let replaySub = ReplaySubject<String>.createUnbounded()
        replaySub.onNext("a")
        replaySub.onNext("b")
        replaySub.onNext("c")
        replaySub.subscribe { (event) in
            print("ReplaySubject:\(event)")
        }.disposed(by: bag)
        replaySub.onNext("d")
        print("-------------------")
        
        // 3.当你订阅了BehaviorSubject，你会接受到订阅之前的最后一个事件
        let behaviorSub = BehaviorSubject(value: "10")
        behaviorSub.onNext("a")
        behaviorSub.onNext("b")
        behaviorSub.onNext("c")
        behaviorSub.subscribe { (event) in
            print("BehaviorSubject:\(event)")
        }.disposed(by: bag)
        behaviorSub.onNext("d")
        behaviorSub.onNext("e")
        behaviorSub.onNext("f")
        print("-------------------")
        
        // 4.Variable是BehaviorSubject一个包装箱，就像是一个箱子一样，使用的时候需要调用asObservable()拆箱，里面的value是一个BehaviorSubject，他不会发出error事件，但是会自动发出completed事件
        // 废弃了，用BehaviorRelay替换
        let variable = Variable("a")
        variable.value = "b"
        variable.asObservable().subscribe { (event) in
            print("Variable:\(event)")
        }.disposed(by: bag)
        variable.value = "c"
        variable.value = "d"
        
        let behaviorRelay = BehaviorRelay(value: "1")
        behaviorRelay.accept("2")
        behaviorRelay.accept("3")
        behaviorRelay.asObservable().subscribe { (event) in
            print("BehaviorRelay:\(event)")
        }.disposed(by: bag)
        behaviorRelay.accept("4")
        behaviorRelay.accept("5")
    }
    
    
    
    
    
    
    
    func test2() {
        // 1.never就是创建一个sequence，但是不发出任何事件信号
        let neverO = Observable<String>.never()
        neverO.subscribe { (event) in
            print("never:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 2.empty就是创建一个空的sequence,只能发出一个completed事件
        let emptyO = Observable<String>.empty()
        emptyO.subscribe { (event) in
            print("empty:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 3.just是创建一个sequence只能发出一种特定的事件，能正常结束
        let justO = Observable.just("哈撒给")
        justO.subscribe { (event) in
            print("just:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 4.of是创建一个sequence能发出很多种事件信号
        let ofO = Observable.of("OC", "Swift", "JAVA", "Python")
        ofO.subscribe { (event) in
            print("of:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 5.from就是从数组中创建sequence
        let fromO = Observable.from(["OC", "Swift", "JAVA", "Python"])
        fromO.subscribe { (event) in
            print("from:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 6.自定义可观察的sequence，那就是使用create
        let createO = createObserable()
        createO.subscribe { (event) in
            print("create:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        let myjustO = myJustObserable(element: "123")
        myjustO.subscribe { (event) in
            print("myjust:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 7.range就是创建一个sequence，他会发出这个范围中的从开始到结束的所有事件
        let rangO = Observable.range(start: 1, count: 10)
        rangO.subscribe { (event) in
            print("range:\(event)")
        }.disposed(by: bag)
        print("-------------------")
        
        // 8.创建一个sequence，发出特定的事件n次
        let repeatO = Observable.repeatElement("hello world")
        repeatO.take(5)
            .subscribe { (event) in
                print("repeat:\(event)")
        }.disposed(by: bag)
        print("-------------------")
    }
    
    /**
     比如一个宝宝在睡觉，爸爸妈妈不可能时时刻刻待在那看着吧？那样子太累了。他们该做啥做啥，只要听到宝宝哭声的时候，他们给宝宝喂奶就行了。这就是一个简单的观察者模式。宝宝是被观察者，爸爸妈妈是观察者也称作订阅者，只要被观察者发出了某一个事件，比如宝宝哭声，叫声都是一个事件，订阅者就会做出相应地响应。
     Observable就是可被观察的，也就是我们说的宝宝，他也是事件源。而Observer就是我们的观察者，也就是当收到事件的时候去做某些处理的爸爸妈妈。观察者需要去订阅(subscribe)被观察者，才能收到Observable的事件通知消息
     
     Observable
        被观察者，可观察的，用于发送事件，next事件表示发射新的数据，complete事件表示发射完成，error表示出现异常
        相当于KVO中的被观察对象，也就是事件源
     
     observer
        观察者对象，用来监听事件并作出响应
        观察者需要去订阅（subscribe）被观察者，才能收到Obserable的事件通知消息
     */
    fileprivate func createObserable() -> Observable<Any> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext("123")
            observer.onNext("Lucy")
            observer.onNext(20)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    fileprivate func myJustObserable(element: Any) -> Observable<Any> {
        return Observable.create { (observer) -> Disposable in
            observer.onNext(element)
            observer.onCompleted()
            
            return Disposables.create()
        }
        
    }
    
    
    
    
    
    
    func test1() {
        // 1.按钮点击事件
        btn1.rx.tap.subscribe { (event) in
            print("按钮1发生了点击")
        }.disposed(by: bag)
        
        // 2.监听UITextField文字改变
        tf1.rx.text.subscribe { (event) in
            print(event.element!!)
        }.disposed(by: bag)
        tf2.rx.text.subscribe(onNext: { (text) in
            print(text!)
        }).disposed(by: bag)
        
        // 3.UITextField文字改变显示到label中
        tf1.rx.text.subscribe { (event) in
            self.lb1.text = event.element!!
        }.disposed(by: bag)
        tf2.rx.text.bind(to: lb2.rx.text).disposed(by: bag)
        
        // 4.KVO
        lb1.rx.observe(String.self, "text").subscribe(onNext: { (text) in
            print("lb1发生了改变" + text!)
        }).disposed(by: bag)
        
        // 5.UIScrollView的滚动
        scrollView.contentSize = CGSize(width: 200, height: 1000)
        scrollView.rx.contentOffset.subscribe(onNext: { (point) in
            print(point)
        }).disposed(by: bag)
    }
}

