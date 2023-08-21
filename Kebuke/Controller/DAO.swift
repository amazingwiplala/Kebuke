//
//  DAO.swift
//  Kebuke
//
//  Created by Jeanine Chuang on 2023/8/21.
//

import Foundation
class DAO{
    static let shared = DAO()
    
    func uploadOrder(url:String, orderPost:OrderPost, completion: @escaping(Result<Response,Error>)->Void){
        guard let url = URL(string: url)else{return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer patb1q4Gb5wLdwaRC.00f6550bf2189fe9eef459124964a3f87c688809342132436cd5d3f151ea96e0", forHTTPHeaderField: "Authorization")
        let updateBody = try! JSONEncoder().encode(orderPost)
        //print(String(data: updateBody, encoding: .utf8)!)
        urlRequest.httpBody = updateBody

        URLSession.shared.dataTask(with: urlRequest) {
            data, response, error
            in
            if let data{
                do{
                    let content = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(content))
                    print("上傳成功")
                }catch{
                    completion(.failure(error))
                    print(error)
                }
            }
        }.resume()
    }
    
    func deleteOrder(url:String, removes:[Field] ,completion: @escaping(Result<Records,Error>)->Void){
        var urlComponent = URLComponents(string: url)
        let queryItem = removes.map { URLQueryItem(name: "records[]", value: $0.id)  }
        urlComponent?.queryItems = queryItem
        if let url = urlComponent?.url{
            //print(url.absoluteString)
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "DELETE"
            urlRequest.setValue("Bearer patb1q4Gb5wLdwaRC.00f6550bf2189fe9eef459124964a3f87c688809342132436cd5d3f151ea96e0", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) {
                data, response, error
                in
                if let data{
                    //print(String(data: data, encoding: .utf8)!)
                    do{
                        let content = try JSONDecoder().decode(Records.self, from: data)
                        completion(.success(content))
                        print(content)
                    }catch{
                        completion(.failure(error))
                        print(error)
                    }
                }
            }.resume()
        }
    }
}

