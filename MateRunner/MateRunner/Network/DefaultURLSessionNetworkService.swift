//
//  DefaultURLSessionNetworkService.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/20.
//

import Foundation

import RxSwift

enum URLSessionNetworkServiceError: Int, Error, CustomStringConvertible {
    var description: String { self.errorDescription }
    
    case emptyDataError
    case responseDecodingError
    case payloadEncodingError
    case unknownError
    case invalidURLError
    case invalidRequestError = 400
    case authenticationError = 401
    case forbiddenError = 403
    case notFoundError = 404
    case notAllowedHTTPMethodError = 405
    case timeoutError = 408
    case internalServerError = 500
    case notSupportedError = 501
    case badGatewayError = 502
    case invalidServiceError = 503
    
    var errorDescription: String {
        switch self {
        case .invalidURLError: return "INVALID_URL_ERROR"
        case .invalidRequestError: return "400:INVALID_REQUEST_ERROR"
        case .authenticationError: return "401:AUTHENTICATION_FAILURE_ERROR"
        case .forbiddenError: return "403:FORBIDDEN_ERROR"
        case .notFoundError: return "404:NOT_FOUND_ERROR"
        case .notAllowedHTTPMethodError: return "405:NOT_ALLOWED_HTTP_METHOD_ERROR"
        case .timeoutError: return "408:TIMEOUT_ERROR"
        case .internalServerError: return "500:INTERNAL_SERVER_ERROR"
        case .notSupportedError: return "501:NOT_SUPPORTED_ERROR"
        case .badGatewayError: return "502:BAD_GATEWAY_ERROR"
        case .invalidServiceError: return "503:INVALID_SERVICE_ERROR"
        case .responseDecodingError: return "RESPONSE_DECODING_ERROR"
        case .payloadEncodingError: return "REQUEST_BODY_ENCODING_ERROR"
        case .unknownError: return "UNKNOWN_ERROR"
        case .emptyDataError: return "RESPONSE_DATA_EMPTY_ERROR"
        }
    }
}

final class DefaultURLSessionNetworkService: URLSessionNetworkService {
    private enum HTTPMethod {
        static let get = "GET"
        static let post = "POST"
        static let patch = "PATCH"
        static let delete = "DELETE"
    }
    
    func post<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        return self.request(with: data, url: urlString, headers: headers, method: HTTPMethod.post)
    }
    
    func patch<T: Codable>(
        _ data: T,
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        return self.request(with: data, url: urlString, headers: headers, method: HTTPMethod.patch)
    }
    
    func delete(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        return self.request(url: urlString, headers: headers, method: HTTPMethod.delete)
    }
    
    func get(
        url urlString: String,
        headers: [String: String]?
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        return self.request(url: urlString, headers: headers, method: HTTPMethod.get)
    }
    
    private func request(
        url urlString: String,
        headers: [String: String]? = nil,
        method: String
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        guard let url = URL(string: urlString) else {
            return Observable.error(URLSessionNetworkServiceError.invalidURLError)
        }
        return Observable<Result<Data, URLSessionNetworkServiceError>>.create { emitter in
            let request = self.createHTTPRequest(of: url, with: headers, httpMethod: method)
            let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
                guard let httpResponse = reponse as? HTTPURLResponse else {
                    emitter.onError(URLSessionNetworkServiceError.unknownError)
                    return
                }
                
                if let error = error {
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                
                guard 200...299 ~= httpResponse.statusCode else {
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                guard let data = data else {
                    emitter.onNext(.failure(.emptyDataError))
                    return
                }
                emitter.onNext(.success(data))
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func request<T: Codable>(
        with bodyData: T,
        url urlString: String,
        headers: [String: String]? = nil,
        method: String
    ) -> Observable<Result<Data, URLSessionNetworkServiceError>> {
        guard let url = URL(string: urlString),
              let httpBody = self.createPostPayload(from: bodyData) else {
                  return Observable.error(URLSessionNetworkServiceError.emptyDataError)
              }
        return Observable<Result<Data, URLSessionNetworkServiceError>>.create { emitter in
            let request = self.createHTTPRequest(of: url, with: headers, httpMethod: method, with: httpBody)
            
            let task = URLSession.shared.dataTask(with: request) { data, reponse, error in
                guard let httpResponse = reponse as? HTTPURLResponse else {
                    emitter.onError(URLSessionNetworkServiceError.unknownError)
                    return
                }
                if let error = error {
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                guard 200...299 ~= httpResponse.statusCode else {
                    emitter.onError(self.configureHTTPError(errorCode: httpResponse.statusCode))
                    return
                }
                guard let data = data else {
                    emitter.onNext(.failure(.emptyDataError))
                    return
                }
                emitter.onNext(.success(data))
                emitter.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func createPostPayload<T: Codable>(from requestBody: T) -> Data? {
        if let data = requestBody as? Data {
            return data
        }
        return try? JSONEncoder().encode(requestBody)
    }
    
    private func configureHTTPError(errorCode: Int) -> Error {
        return URLSessionNetworkServiceError(rawValue: errorCode)
        ?? URLSessionNetworkServiceError.unknownError
    }
    
    private func createHTTPRequest(
        of url: URL,
        with headers: [String: String]?,
        httpMethod: String,
        with body: Data? = nil
    ) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        headers?.forEach({ header in
            request.addValue(header.value, forHTTPHeaderField: header.key)
        })
        if let body = body {
            request.httpBody = body
        }
        
        return request
    }
}
