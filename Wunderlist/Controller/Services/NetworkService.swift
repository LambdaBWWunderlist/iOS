//
//  NetworkService.swift
//  Wunderlist
//
//  Created by Kenny on 6/21/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

//
//  NetworkHelper.swift
//  App
//
//  Created by Kenny on 2/29/20.
//

import Foundation

protocol NetworkLoader {
    func loadData(using request: URLRequest, with completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkLoader {
    func loadData(using request: URLRequest, with completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: request, completionHandler: completion).resume()
    }
}

class NetworkService {
    ///Used to set a`URLRequest`'s HTTP Method
    enum HttpMethod: String {
        case get = "GET"
        case patch = "PATCH"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }

    /**
     used when the endpoint requires a header-type (i.e. "content-type") be specified in the header
     */
    enum HttpHeaderType: String {
        case contentType = "Content-Type"
        case authorization = "Authorization"
    }

    /**
     the value of the header-type (i.e. "application/json")
     */
    enum HttpHeaderValue: String {
        case json = "application/json"
    }

    /**
     - parameter request: should return nil if there's an error or a valid request object if there isn't
     - parameter error: should return nil if the request succeeded and a valid error if it didn't
     */
    struct EncodingStatus {
        let request: URLRequest?
        let error: Error?
    }

    ///used to switch between live and Mock Data
    var dataLoader: NetworkLoader

    init(dataLoader: NetworkLoader = URLSession.shared) {
        self.dataLoader = dataLoader
    }

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }

    /**
     Create a request given a URL and requestMethod (get, post, create, etc...)
     */
    func createRequest(
        url: URL?, method: HttpMethod,
        headerType: HttpHeaderType? = nil,
        headerValue: HttpHeaderValue? = nil
    ) -> URLRequest? {
        guard let requestUrl = url else {
            NSLog("request URL is nil")
            return nil
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        if let headerType = headerType,
            let headerValue = headerValue {
            request.setValue(headerValue.rawValue, forHTTPHeaderField: headerType.rawValue)
        }
        return request
    }

//    func getToDos() {
//        createRequest(url: AuthService, method: .post)
//    }
    /**
     Encode from a Swift object to JSON for transmitting to an endpoint.
     Modifies request passed in as well as returning a modified request as a parameter
     - note: It is preferred to use the request attached to the returned status
     - parameter type: the type to be encoded (i.e. MyCustomType.self)
     - parameter request: the URLRequest used to transmit the encoded result to the remote server
     - parameter dateFormatter: optional for use with JSONEncoder.dateEncodingStrategy
     - returns: An EncodingStatus object which should either contain an error and nil request or request and nil error
     */
    @discardableResult func encode<T: Encodable>(
        from type: T,
        request: inout URLRequest,
        dateFormatter: DateFormatter? = nil
    ) -> EncodingStatus {
        let jsonEncoder = JSONEncoder()
        if let dateFormatter = dateFormatter {
            jsonEncoder.dateEncodingStrategy = .formatted(dateFormatter)
        }
        do {
            request.httpBody = try jsonEncoder.encode(type)
        } catch {
            print("Error encoding object into JSON \(error)")
            return EncodingStatus(request: nil, error: error)
        }
        return EncodingStatus(request: request, error: nil)
    }

    func decode<T: Decodable>(
        to type: T.Type,
        data: Data,
        dateFormatter: DateFormatter? = nil
    ) -> T? {
        let decoder = JSONDecoder()
        if let dateFormatter = dateFormatter {
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
        }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error Decoding JSON into \(String(describing: type)) Object \(error)")
            return nil
        }
    }

    func loadData(using request: URLRequest, with completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        dataLoader.loadData(using: request, with: completion)
    }
}

//MARK: USAGE:

/*
To get data and decode:
func getSomeDataAndDecodeIt() {
    let networkService = NetworkService()
    guard let request = networkService.createRequest(url: URL(string:"https://www.google.com"), method: .get) else { return }
    networkService.loadData(using: request) {
        //TODO: Error handling like normal, maybe check the response if you care what the code is
        guard let data = data else { return }
        let decodedData = networkService.decode(to: Data.self, data: data) //Data.self would be whatever type you're really trying to decode to (i.e. Todo.self)
        print(String(data:data, encoding: .utf8))
    } //NO .resume() needed
}

//To encode data and send:
func encodeSomeDataAndSendIt() {
    let networkService = NetworkService()
    let loginUser = UserRepresentation(identifier: nil, username: "somenetworkuser", password: "123")
    guard var request = networkService.createRequest(url: URL(string:"https://www.google.com"), method: .get) else { return } //the request must be unwrapped and must be a variable
    let encodingStatus = networkService.encode(from: loginUser, request: &request)
    // you can check the encodingStatus.error for an error (and should)
    // you can use either the original request or encodingStatus.request
    // but should use the encodingStatus.request in case the original gets malformed
    guard let encodedRequest = encodingStatus.request else { return }
    networkService.loadData(using: encodedRequest) { (data, response, error) in
        //it's sent, the server has handled it, and sent you some data
        //handle the data that comes back
    } //NO .resume() needed

}
*/
