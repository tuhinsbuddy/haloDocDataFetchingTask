//
//  ShowLatestNewsMainViewController.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ShowLatestNewsMainViewController: UIViewController {
    
    @IBOutlet weak var showLatestNewsTopSearchBarSuperView: UIView!
    @IBOutlet weak var showLatestNewsMainTableView: UITableView!
    
    fileprivate let searchBarController = UISearchController(searchResultsController: nil)
    fileprivate var layOutManagedProperly: Bool = false
    fileprivate var latestNewsDetailsDataFromServer: [[String: Any]] = []
    fileprivate var selectedUrlString: String = ""
    fileprivate var selectedPageTitleString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        searchBarController.searchBar.returnKeyType = .done
        searchBarController.delegate = self
        searchBarController.searchBar.delegate = self
        searchBarController.hidesNavigationBarDuringPresentation = true
        searchBarController.dimsBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.backgroundImage = UIImage()
        searchBarController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBarController.searchBar.placeholder = "Latest News..."
        showLatestNewsTopSearchBarSuperView.backgroundColor = UIColor.clear
        showLatestNewsMainTableView.delegate = self
        showLatestNewsMainTableView.dataSource = self
        showLatestNewsMainTableView.register(UINib(nibName: "ShowNewsTableViewMainCellClass", bundle: nil), forCellReuseIdentifier: "showNewsTableViewMainCellId")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataParsingMainSingletonClass.singletonForDataParsing.newsDataFromServerCustomDelegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if layOutManagedProperly != true {
            layOutManagedProperly = true
            searchBarController.searchBar.frame = showLatestNewsTopSearchBarSuperView.frame
            showLatestNewsTopSearchBarSuperView.addSubview(searchBarController.searchBar)
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case _ where segue.identifier == "gotLoadWebPageToShowTheDetails":
            if let showDetailsPageObject = segue.destination as? ShowDetailsOnWebPageViewController{
                showDetailsPageObject.urlToLoad = selectedUrlString
                showDetailsPageObject.pageTitle = selectedPageTitleString
            }

        default:
            break
            
        }
    }
    
    
    

    fileprivate func getDetailsFromServer(searchedNews searchedString: String){
        CreateCompleteApiEndpoints.makeApiForTheCompleteApp(mainApiString: ApisForDataFetchingStruct.mainApiForLatestNews, middlePartOfTheApiToBeCreated: ParametersForApisStruct.queryForNewsApi, lastPartOfTheApiToBeCreated: nil, onCompletion: {(finished, apiString) in switch finished{
        case true:
            debugPrint("Final api is \(apiString) and the parameter is \(searchedString)")
            let finalApiString: String = "\(apiString)\(searchedString)"
            NewsRelatedApiHandlingStruct.getLatestNewsFromServer(finalApiString: finalApiString)
            
        case false:
            debugPrint("Final Api Creation Failed")
            
            }
        })
    }

    
    fileprivate func selectCellAndLoadUrl(indexValue indexPath: IndexPath) {
        DispatchQueue.main.async(execute:{
            if let urlCheck = self.latestNewsDetailsDataFromServer[indexPath.row]["urlString"] as? String,
                !urlCheck.isEmpty{
                self.selectedUrlString = urlCheck
            } else {
                debugPrint("Can't find url for this selected cell! Perform some error handling task here!")
            }
            
            if let newsMainTitleCheck = self.latestNewsDetailsDataFromServer[indexPath.row]["titleName"] as? String,
                !newsMainTitleCheck.isEmpty {
                self.selectedPageTitleString = newsMainTitleCheck
            } else {
                self.selectedPageTitleString = "No title found!"
                debugPrint("Can't find page title for this selected cell! Perform some error handling task here!")
            }
            
            self.performSegue(withIdentifier: "gotLoadWebPageToShowTheDetails", sender: self)

        })
    }
    
}

//MARK: - UITableView Delegate Methods
extension ShowLatestNewsMainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isSelected == true{
            cell.contentView.backgroundColor = UIColor.lightGray
        
        }
        if(tableView.responds(to: #selector(setter: UITableViewCell.separatorInset))) {
            tableView.separatorInset = UIEdgeInsets.zero
        }
        
        if(tableView.responds(to: #selector(setter: UIView.layoutMargins))) {
            tableView.layoutMargins = UIEdgeInsets.zero
        }
        
        if(cell.responds(to: #selector(setter: UIView.layoutMargins))) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if latestNewsDetailsDataFromServer.isEmpty{
            return tableView.frame.size.height
        } else {
            return 150
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            cell.isSelected == true{
            selectCellAndLoadUrl(indexValue: indexPath)
            cell.contentView.backgroundColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath),
            cell.isSelected == true{
            cell.contentView.backgroundColor = UIColor.clear
        }
    }
    
}

//MARK: - UITableView DataSource Methods
extension ShowLatestNewsMainViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if latestNewsDetailsDataFromServer.isEmpty{
            return 1
        } else {
            return latestNewsDetailsDataFromServer.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "showNewsTableViewMainCellId", for: indexPath) as? ShowNewsTableViewMainCellClass{
            
            if latestNewsDetailsDataFromServer.isEmpty{
                if cell.showLatestNewsMainCellLoader.isAnimating == false{
                    cell.showLatestNewsMainCellLoader.startAnimating()
                }
                
                cell.showLatestNewsPointLbl.text = nil
                cell.showLatestNewsMainTitleLbl.text = nil
                cell.showLatestNewsMainAuthorLbl.text = nil
                cell.showLatestNewsCommentCountLbl.text = nil
                
                cell.showLatestNewsPointLbl.isHidden = true
                cell.showLatestNewsMainTitleLbl.isHidden = true
                cell.showLatestNewsMainAuthorLbl.isHidden = true
                cell.showLatestNewsCommentCountLbl.isHidden = true
                
            } else {
                if cell.showLatestNewsMainCellLoader.isAnimating == true {
                    cell.showLatestNewsMainCellLoader.stopAnimating()
                }
                cell.showLatestNewsPointLbl.isHidden = false
                cell.showLatestNewsMainTitleLbl.isHidden = false
                cell.showLatestNewsMainAuthorLbl.isHidden = false
                cell.showLatestNewsCommentCountLbl.isHidden = false


                if let newsMainTitleCheck = latestNewsDetailsDataFromServer[indexPath.row]["titleName"] as? String,
                    !newsMainTitleCheck.isEmpty {
                    cell.showLatestNewsMainTitleLbl.text = newsMainTitleCheck
                } else {
                    cell.showLatestNewsMainTitleLbl.text = "No title found!"
                }
                
                if let authorNameCheck = latestNewsDetailsDataFromServer[indexPath.row]["authorName"] as? String,
                    !authorNameCheck.isEmpty {
                    cell.showLatestNewsMainAuthorLbl.text = authorNameCheck
                } else {
                    cell.showLatestNewsMainAuthorLbl.text = "No author found!"
                }
                
                if let pointsCountCheck = latestNewsDetailsDataFromServer[indexPath.row]["pointsCount"] as? Int{
                    cell.showLatestNewsPointLbl.text = "Points - \(pointsCountCheck)"
                } else {
                    cell.showLatestNewsPointLbl.text = "Points - 0"
                }
                
                if let commentsCountCheck = latestNewsDetailsDataFromServer[indexPath.row]["commentsCount"] as? Int{
                    cell.showLatestNewsCommentCountLbl.text = "Comments - \(commentsCountCheck)"
                } else {
                    cell.showLatestNewsCommentCountLbl.text = "Comments - 0"
                }
                
            }

            
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .default
            
            return cell
        }else{
            return UITableViewCell()
        }
    }
}

//MARK: - UISearchBar Delegate Methods
extension ShowLatestNewsMainViewController: UISearchBarDelegate, UISearchControllerDelegate { //UISearchResultsUpdating
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBarController.searchBar.text,
            !searchText.isEmpty {
            searchBarController.isActive = false
            getDetailsFromServer(searchedNews: searchText.lowercased())
        }
    }
}


//MARK: - Data Parsing Model Class response
extension ShowLatestNewsMainViewController: LatestNewsDataParsedDelegate {
    func latestNewsDataParsedDelegateResponse(errorStatus isError: Bool, responseApiName responseStatusApiName: String?, responseDataValue dataObjectResponse: Any?, httpCallStatus statusCode: Int) {
    
        switch isError{
            
        case true:
            switch statusCode{
            case AllApiResponseStatusCodes.apiUnauthorizedCallStatusCode.rawValue:
                debugPrint("Authorization failed! Please re login again!")
                
            default:
                switch responseStatusApiName {
                case _ where responseStatusApiName == LatestNewsApiStatusName.getLatestNewsDataParsedWithApiError.rawValue:
                    debugPrint("Error From Server! Perform some error handling task here!")
                    
                case _ where responseStatusApiName == LatestNewsApiStatusName.getLatestNewsDataParsedWithSystemError.rawValue:
                    debugPrint("Error From System! Show some messge or alert from here to notify the user!")
                    
                default:
                    break
                }
            }
            
            
        case false:
            switch statusCode {
            case AllApiResponseStatusCodes.apiSuccessStatusCode.rawValue:
                
                switch responseStatusApiName{
                case _ where responseStatusApiName == LatestNewsApiStatusName.getLatestNewsDataParsedSuccessfully.rawValue:
                    
                    if let responseDataCheck = dataObjectResponse as? [[String: Any]],
                        !responseDataCheck.isEmpty{

                        latestNewsDetailsDataFromServer = responseDataCheck
                        showLatestNewsMainTableView.reloadData()
                        
                    } else {
                        debugPrint("Server response is empty here! Try performing some error handling task here!")
                    }
                        
                    default:
                        break
                    }
                    
                default:
                    break
                }
            }
        }
    }



