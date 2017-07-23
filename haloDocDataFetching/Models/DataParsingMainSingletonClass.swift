//
//  DataParsingMainSingletonClass.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit
import SwiftyJSON


@objc protocol LatestNewsDataParsedDelegate: class{
    @objc optional func latestNewsDataParsedDelegateResponse(errorStatus isError: Bool, responseApiName responseStatusApiName: String?, responseDataValue dataObjectResponse: Any?, httpCallStatus statusCode: Int)
}


class DataParsingMainSingletonClass: NSObject {
    static let singletonForDataParsing = DataParsingMainSingletonClass()
    weak var newsDataFromServerCustomDelegate: LatestNewsDataParsedDelegate?
    
    
    fileprivate override init() {
        super.init()
    }
    
    
    
    func parseLatestNewsData(dataToParse rawData: Any?, statusCode codeValue: Int){
        switch codeValue{
        case _ where codeValue == AllApiResponseStatusCodes.apiSuccessStatusCode.rawValue:
            if let rawDataObjectCheck = rawData{
                var finalDataToReturn: [[String: Any]] = []
                let convertedData = JSON(rawDataObjectCheck)
                let receivedDataValue = convertedData["hits"].arrayValue
                for valueObject in receivedDataValue {
                    let titleName: String = valueObject["title"].stringValue
                    let urlString: String = valueObject["url"].stringValue
                    let authorName: String = valueObject["author"].stringValue
                    let pointsCount: Int = valueObject["points"].intValue
                    let commentsCount: Int = valueObject["num_comments"].intValue
                    let dataToAppend: [String: Any] = ["titleName": titleName, "urlString": urlString, "authorName": authorName, "pointsCount": pointsCount, "commentsCount": commentsCount]
                    finalDataToReturn.append(dataToAppend)
                }
                
                
                newsDataFromServerCustomDelegate?.latestNewsDataParsedDelegateResponse?(errorStatus: false, responseApiName: LatestNewsApiStatusName.getLatestNewsDataParsedSuccessfully.rawValue, responseDataValue: finalDataToReturn, httpCallStatus: codeValue)
                
            }else{
                newsDataFromServerCustomDelegate?.latestNewsDataParsedDelegateResponse?(errorStatus: true, responseApiName: LatestNewsApiStatusName.getLatestNewsDataParsedWithSystemError.rawValue, responseDataValue: nil, httpCallStatus: codeValue)
                
            }
            
        case _ where codeValue == AllApiResponseStatusCodes.apiUnauthorizedCallStatusCode.rawValue:
            
            newsDataFromServerCustomDelegate?.latestNewsDataParsedDelegateResponse?(errorStatus: true, responseApiName: LatestNewsApiStatusName.getLatestNewsDataParsedWithApiError.rawValue, responseDataValue: nil, httpCallStatus: codeValue)

        case _ where codeValue == AllApiResponseStatusCodes.apiErrorFromSystemStatusCode.rawValue: //API System Error
            
            newsDataFromServerCustomDelegate?.latestNewsDataParsedDelegateResponse?(errorStatus: true, responseApiName: LatestNewsApiStatusName.getLatestNewsDataParsedWithSystemError.rawValue, responseDataValue: nil, httpCallStatus: codeValue)
            
        default: break
        }
    }
    
    
    
}


