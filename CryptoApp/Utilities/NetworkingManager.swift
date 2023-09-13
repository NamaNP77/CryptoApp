//
//  NetworkingManager.swift
//  CryptoApp
//
//  Created by NamaN  on 06/09/23.
//

import Foundation
import Combine

class NetworkingManager {
    
    static func download(url : URL) -> AnyPublisher<Data,any Error>{
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0)})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher() // return expression to type 'AnyPublisher<Data, any Error>'
    }
    
    static func handleURLResponse(output : URLSession.DataTaskPublisher.Output) throws -> Data{
        
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    static func handleCompletion(completion : Subscribers.Completion<Error>){
        switch completion  {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
}
