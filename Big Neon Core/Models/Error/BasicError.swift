//
// Created by Keith Simon on 2019-01-21.
// Copyright (c) 2019 Big Neon Inc. All rights reserved.
//

import Foundation


public struct BasicError: Codable {
    let error: String

    enum CodingKeys: String, CodingKey {
        case error = "error"
    }
}

protocol BasicErrorProtocol: LocalizedError {

    var title: String? { get }
}

struct BasicErrorImpl: BasicErrorProtocol {

    var title: String?
    var errorDescription: String? { return _description }
    var failureReason: String? { return _description }

    private var _description: String

    init(title: String?, description: String) {
        self.title = title ?? "Error"
        self._description = description
    }
}
