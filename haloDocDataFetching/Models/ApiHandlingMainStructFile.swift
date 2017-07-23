//
//  ApiHandlingMainStructFile.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import Foundation
import Alamofire

struct NewsRelatedApiHandlingStruct {
    
    static func getLatestNewsFromServer(finalApiString apiToHit: String){
        print(apiToHit)
        
        Alamofire.request(apiToHit, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { response in switch response.result {
            
        case .success(_):
            if let receivedData: Any = response.result.value,
                let statusCode: Int = response.response?.statusCode {
                DataParsingMainSingletonClass.singletonForDataParsing.parseLatestNewsData(dataToParse: receivedData, statusCode: statusCode)
                
            }else{
                DataParsingMainSingletonClass.singletonForDataParsing.parseLatestNewsData(dataToParse: nil, statusCode: AllApiResponseStatusCodes.apiErrorFromSystemStatusCode.rawValue)
            }
        case .failure(_):
            DataParsingMainSingletonClass.singletonForDataParsing.parseLatestNewsData(dataToParse: nil, statusCode: AllApiResponseStatusCodes.apiErrorFromSystemStatusCode.rawValue)
            }
        })
    }
}
