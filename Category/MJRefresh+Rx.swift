//
//  MJRefresh+Rx.swift
//  PSK
//
//  Created by tommy on 2019/11/15.
//  Copyright © 2019 ipzoe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import MJRefresh

extension Reactive where Base: MJRefreshHeader {

    // 正在刷新事件
    public var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureExecutingOnScheduler()

            guard let header = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            header.refreshingBlock = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
        return ControlEvent(events: source)
    }

    // 停止刷新
    public var endRefreshing: Binder<Bool> {
        return Binder(self.base) { (refresh: MJRefreshHeader, isEnd: Bool) in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

extension Reactive where Base: MJRefreshFooter {

    // 正在刷新事件
    public var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create { [weak control = self.base] observer in
            MainScheduler.ensureExecutingOnScheduler()

            guard let header = control else {
                observer.on(.completed)
                return Disposables.create()
            }

            header.refreshingBlock = {
                observer.on(.next(()))
            }

            return Disposables.create()
        }
        return ControlEvent(events: source)
    }

    // 停止刷新
    public var endRefreshing: Binder<Bool> {
        return Binder(self.base) { (refresh: MJRefreshFooter, hasMoreData: Bool) in
            if hasMoreData {
                refresh.endRefreshing()
            } else {
                refresh.endRefreshingWithNoMoreData()
            }
        }
    }
}
