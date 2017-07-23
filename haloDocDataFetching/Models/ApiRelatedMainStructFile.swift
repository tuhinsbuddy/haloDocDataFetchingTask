//
//  ApiRelatedMainStructFile.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import Foundation

struct ApisForDataFetchingStruct{
    static let mainApiForLatestNews: String = "https://hn.algolia.com/api/v1/search"
}

struct ParametersForApisStruct {
    static let queryForNewsApi: String = "?query="
}

struct CreateCompleteApiEndpoints{
    static func makeApiForTheCompleteApp(mainApiString mainApiStringObj: String, middlePartOfTheApiToBeCreated middlePartString: String?, lastPartOfTheApiToBeCreated lastPartString: String?, onCompletion: (_ isSuccess: Bool, _ finalApiString: String) -> Void){
        var mainApiYouAreLookingFor: String = ""
        if let middlePartStringOfApiCheck = middlePartString,
            !middlePartStringOfApiCheck.isEmpty,
            let lastPartStringOfApiCheck = lastPartString,
            !lastPartStringOfApiCheck.isEmpty{
            mainApiYouAreLookingFor = "\(mainApiStringObj)/\(middlePartStringOfApiCheck)/\(lastPartStringOfApiCheck)"
        }else if let middlePartStringOfApiCheck = middlePartString,
            !middlePartStringOfApiCheck.isEmpty{
            mainApiYouAreLookingFor = "\(mainApiStringObj)/\(middlePartStringOfApiCheck)"
        }else if let lastPartStringOfApiCheck = lastPartString,
            !lastPartStringOfApiCheck.isEmpty{
            mainApiYouAreLookingFor = "\(mainApiStringObj)/\(lastPartStringOfApiCheck)"
        }else{
            mainApiYouAreLookingFor = mainApiStringObj
        }
        onCompletion(true, mainApiYouAreLookingFor)
    }
}

//MARK: - All HTTP Stauts Code
enum AllApiResponseStatusCodes: Int {
    case apiSuccessStatusCode = 200
    case apiErrorFromServerStatusCode = 500
    case apiErrorFromSystemStatusCode = 912
    case apiUnauthorizedCallStatusCode = 401
}

//MARK: - All Api Repsonse Name
enum LatestNewsApiStatusName: String {
    case getLatestNewsDataParsedSuccessfully = "getLatestNewsDataParsedSuccessfully"
    case getLatestNewsDataParsedWithApiError = "getLatestNewsDataParsedWithApiError"
    case getLatestNewsDataParsedWithSystemError = "getLatestNewsDataParsedWithSystemError"
}
