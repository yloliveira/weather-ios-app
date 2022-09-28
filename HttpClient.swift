//
//  HttpClient.swift
//  Clima
//
//  Created by Yan Oliveira on 24/09/22.
//  Copyright © 2022 yloliveira. All rights reserved.
//

import Foundation

struct HttpClient {
    var baseUrl: String?
    
    func performGetRequest(with urlString: String, _ handler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let encodedUrl = urlString.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        if let url = URL(string: "\(self.baseUrl!)\(encodedUrl ?? urlString)") {
            let session = URLSession(configuration: .default)
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            let task = session.dataTask(with: request, completionHandler: handler)
            task.resume()
        }
    }
}
