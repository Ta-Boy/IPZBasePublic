//
// Created by tommy on 2019/10/31.
// Copyright (c) 2019 ipzoe. All rights reserved.
//

import Foundation

public protocol EvaBaseViewModelType {

    // 定义输入输出类型，具体类型到具体业务相关的ViewModel时再确定
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
