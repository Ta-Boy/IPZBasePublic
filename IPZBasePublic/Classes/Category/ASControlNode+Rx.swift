//
//  ASControlNode+Rx.swift
//  PSK
//
//  Created by tommy on 2019/11/13.
//  Copyright © 2019 ipzoe. All rights reserved.
//

import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

public final class ASControlTarget<Control: ASControlNode>: _RXKVOObserver, Disposable {

    typealias Callback = (Control) -> Void

    let selector = #selector(eventHandler(_:))

    weak var controlNode: Control?
    var callback: Callback?

    init(_ controlNode: Control, _ eventType: ASControlNodeEvent, callback: @escaping Callback) {
        super.init()

        self.controlNode = controlNode
        self.callback = callback

        controlNode.addTarget(self, action: selector, forControlEvents: eventType)

        let method = self.method(for: selector)
        if method == nil {
            fatalError("Can't find method")
        }
    }

    @objc func eventHandler(_ sender: UIGestureRecognizer) {
        if let callback = self.callback, let controlNode = self.controlNode {
            callback(controlNode)
        }
    }

    public override func dispose() {
        super.dispose()
        self.controlNode?.removeTarget(self, action: selector, forControlEvents: .allEvents)
        self.callback = nil
    }
}

public final class ASGestureTarget<Control: ASControlNode>: _RXKVOObserver, Disposable {

    typealias Callback = (UIGestureRecognizer) -> Void

    weak var controlNode: Control?
    var callback: Callback?
    let selector = #selector(eventHandler(_:))
    var gestureRecognizer: UIGestureRecognizer?

    init(_ controlNode: Control, _ gestureRecognizer: UIGestureRecognizer, callback: @escaping Callback) {
        super.init()

        self.controlNode = controlNode
        self.callback = callback
        self.gestureRecognizer = gestureRecognizer

        gestureRecognizer.addTarget(self, action: selector)
        controlNode.view.addGestureRecognizer(gestureRecognizer)

        let method = self.method(for: selector)
        if method == nil {
            fatalError("Can't find method")
        }
    }

    @objc func eventHandler(_ sender: UIGestureRecognizer) {
        if let callback = self.callback, let gestureRecognizer = self.gestureRecognizer {
            callback(gestureRecognizer)
        }
    }

    public override func dispose() {
        super.dispose()
        self.gestureRecognizer?.removeTarget(self, action: self.selector)
        self.callback = nil
    }
}

extension Reactive where Base: ASControlNode {

    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }

    public var isSelected: Binder<Bool> {
        return Binder(self.base) { control, selected in
            control.isSelected = selected
        }
    }

    public func asEvent(_ type: ASControlNodeEvent) -> ControlEvent<Void> {
        let source = Observable<Void>.create { [weak control = self.base] observer in
            MainScheduler.ensureExecutingOnScheduler()

            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            let observer = ASControlTarget(control, type) { control in
                observer.on(.next(()))
            }

            return observer
        }.takeUntil(deallocated)

        return ControlEvent(events: source)
    }

    public func asGesture(_ gestureRecognizer: UIGestureRecognizer) -> ControlEvent<UIGestureRecognizer> {
        let source = Observable<UIGestureRecognizer>.create { [weak control = self.base] observer in
            MainScheduler.ensureExecutingOnScheduler()

            guard let control = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            let observer = ASGestureTarget.init(control, gestureRecognizer) { recognizer in
                observer.on(.next(recognizer))
            }

            return observer
        }.takeUntil(deallocated)

        return ControlEvent(events: source)
    }
}
