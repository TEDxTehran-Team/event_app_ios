//
//  AboutRepository.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 8/30/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import Foundation

class AboutRepository {
    
    func get(completion: @escaping ([About]?, XException?) -> ()) {
        
        Network.shared.apollo.fetch(query: GetAboutsQuery(),cachePolicy: .fetchIgnoringCacheCompletely) { result in
            switch result {
            case .failure(let error):
                print("About Error \(error)")
                completion(nil, XException(message: error.localizedDescription, code: 0))
            case .success(let data):                
                let model = data.data?.organizer?.decodeModel(type: AboutResponse.self)
                completion(model?.abouts, nil)
            }
        }
        
    }
    
}
