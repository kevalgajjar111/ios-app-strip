//
//  APIClient.swift
//  rocketrides-pilot
//
//  Created by James Little on 8/26/19.
//  Copyright © 2019 Stripe. All rights reserved.
//

import StripeTerminal
import Alamofire
/**
 Example API client class for talking to your backend.
 For simplicity, this class is a singleton; access the shared instance via
 `APIClient.shared`.
 */
class APIClient {
    
    //https://github.com/stripe/example-terminal-backend
    static let shared = APIClient()
    static let baseURL = URL(string: "https://stalwart-keval.herokuapp.com/")
    
    func capturePaymentIntent(_ paymentIntentId: String, completion: @escaping ErrorCompletionBlock) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: "/capture_payment_intent", relativeTo: APIClient.baseURL) else {
            fatalError("Invalid backend URL")
        }
        let parameters = "payment_intent_id=\(paymentIntentId)"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        
        let task = session.dataTask(with: request) {(data, response, error) in
            if let response = response as? HTTPURLResponse, let data = data {
                    switch response.statusCode {
                    case 200..<300:
                        completion(nil)
                    case 402:
                        let description = String(data: data, encoding: .utf8) ?? "Failed to capture payment intent"
                        completion(NSError(domain: "com.stripe-terminal-ios.example", code: 2, userInfo: [NSLocalizedDescriptionKey: description]))
                    default:
                        completion(error ?? NSError(domain: "com.stripe-terminal-ios.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Other networking error encountered."]))
                    }
            } else {
                completion(error)
            }
        }
        task.resume()
    }
    
    init() {
        if(APIClient.baseURL?.absoluteString == "https://stalwart-keval.herokuapp.com") {
            fatalError("\nPlease change the API client's base URL to be your backend URL.\n\n")
        }
    }
}

extension APIClient: ConnectionTokenProvider {
    
    func fetchConnectionToken(_ completion: @escaping ConnectionTokenCompletionBlock) {
        
        let _ : HTTPHeaders = ["Content-Type": "application/json"]
        guard let url = URL(string: "/connection_token", relativeTo: APIClient.baseURL) else {
               fatalError("Invalid backend URL")
        }
        AF.request(url, method: .get).responseString { (response) in
            switch response.result {
            case .success(let value):
                print(value)
                break
            case.failure(let error):
                print(error.localizedDescription)
                break
            }
        }
        
        /*
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: "/connection_token", relativeTo: APIClient.baseURL) else {
            fatalError("Invalid backend URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                         // Print out dictionary
                         print(json)
                    }

                    
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    /*
                    if let secret = json["secret"] as? String {
                        completion(secret, nil)
                    } else {
                        let error = NSError(domain: "com.stripe-terminal-ios.example",
                                            code: 2000,
                                            userInfo: [NSLocalizedDescriptionKey: "Missing `secret` in ConnectionToken JSON response"])
                        completion(nil, error)
                    }
                    */
                    
                }
                catch {
                    completion(nil, error)
                }
            }
            else {
                let error = NSError(domain: "com.stripe-terminal-ios.example",
                                    code: 1000,
                                    userInfo: [NSLocalizedDescriptionKey: "No data in response from ConnectionToken endpoint"])
                completion(nil, error)
            }
        }
        task.resume()
        */
    }
}
