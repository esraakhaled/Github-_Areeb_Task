//
//  APIService.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//

import Foundation

enum ErrorType: Error {
    case dataNotFound
}

final class APIService {
    
    static let shared = APIService()
    
    func getRepositories(completion: @escaping(_ repositories: [Repository]?, _ error: Error?) -> Void) {
        
        guard let url = URL(string: EndPoint.repositories) else { return }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, ErrorType.dataNotFound)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode([Repository].self, from: data)
                debugPrint(response)
                completion(response,nil)
            }
            catch {
                debugPrint(error.localizedDescription)
                completion(nil,error)
            }
        }
        task.resume()
    }
    //MARK: - Get Creation Date Function
    func getCreationDate(for urlString: String?, completion: @escaping (_ repository: Repository?, _ error: Error?) -> Void) {
        let urlString = urlString ?? ""
        guard let url = URL(string: urlString) else {
            completion(nil, nil)
            return
        }
        
        let session = URLSession.shared
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Repository.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}

