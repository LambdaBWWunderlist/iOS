//
//  MockDataLoader.swift
//  Wunderlist
//
//  Created by Kenny on 6/22/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

class MockDataLoader: NetworkLoader {

    let data: Data?
    let response: URLResponse?
    let error: Error?

    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }

    private(set) var request: URLRequest?

    func loadData(using request: URLRequest, with completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
            self.request = request
            completion(self.data, self.response, self.error)
        }
    }
}
