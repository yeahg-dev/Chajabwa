//
//  Observable.swift
//  app-show-room
//
//  Created by Moon Yeji on 2022/08/15.
//

import Foundation

final class Observable<Value> {
    
    struct Observer<Value> {
        weak var observer: AnyObject?
        let valueDidSet: (Value) -> Void
    }
    
    private var observers = [Observer<Value>]()
    
    var value: Value {
        didSet { notifyObserversOnMainThread() }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func observe(
        on observer: AnyObject,
        _ subscribeBlock: @escaping (Value) -> Void) {
        observers.append(Observer(observer: observer, valueDidSet: subscribeBlock))
        subscribeBlock(self.value)
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    private func notifyObserversOnMainThread() {
        for observer in observers {
            DispatchQueue.main.async { observer.valueDidSet(self.value) }
        }
    }
    
}
