//
//  APIServices.swift
//  TMDBMovie
//
//  Created by Phincon on 11/07/21.
//

import Foundation
import Alamofire

class APIServices {
    static let shared = APIServices()
    func request<T: Decodable, E: Decodable>(url: String, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, completion: @escaping(T?,E?, Error?) ->()){
        
        Alamofire.request(url, method: method, parameters: params, encoding: encoding, headers: headers).validate(statusCode: 200...300).responseJSON { (response) in
            
            print(response.description)
            switch response.result {
            case .success:
                guard let data = response.data else { return }
                do {
                    let jsonData = try JSONDecoder().decode(T.self, from: data)
                    completion(jsonData, nil, nil)
                } catch let jsonError {
                    print(jsonError)
                }
                
            case .failure(let error):
                let statusCode = response.response?.statusCode ?? 0
                
                switch statusCode {
                
                // MARK: in api TDBMovie status code from 1 - 500
                case 1..<500:
                    do {
                        guard let data = response.data else { return }
                        let jsonError = try JSONDecoder().decode(E.self, from: data)
                        completion(nil, jsonError, nil)
                    } catch let jsonError {
                        print(jsonError)
                    }
                default:
                    completion(nil, nil, error)
                }
            }
        }
    }
}
