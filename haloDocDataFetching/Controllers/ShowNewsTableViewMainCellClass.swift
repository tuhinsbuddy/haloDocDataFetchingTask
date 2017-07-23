//
//  ShowNewsTableViewMainCellClass.swift
//  haloDocDataFetching
//
//  Created by Tuhin Samui on 23/07/17.
//  Copyright © 2017 Tuhin Samui. All rights reserved.
//

import UIKit

class ShowNewsTableViewMainCellClass: UITableViewCell {

    @IBOutlet weak var showLatestNewsMainCellLoader: UIActivityIndicatorView!
    @IBOutlet weak var showLatestNewsMainStackView: UIStackView!
    @IBOutlet weak var showLatestNewsMainTitleLbl: UILabel!
    @IBOutlet weak var showLatestNewsMainAuthorLbl: UILabel!
    @IBOutlet weak var showLatestNewsCommentAndPointStackView: UIStackView!
    @IBOutlet weak var showLatestNewsPointLbl: UILabel!
    @IBOutlet weak var showLatestNewsCommentCountLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.showLatestNewsMainTitleLbl.textColor = UIColor.black
        self.showLatestNewsMainAuthorLbl.textColor = UIColor.black
        self.showLatestNewsPointLbl.textColor = UIColor.black
        self.showLatestNewsCommentCountLbl.textColor = UIColor.black
        self.showLatestNewsMainTitleLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        self.showLatestNewsMainAuthorLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 12)!
        self.showLatestNewsPointLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 10)!
        self.showLatestNewsCommentCountLbl.font = UIFont(name: "HelveticaNeue-Medium", size: 10)!
        self.showLatestNewsMainCellLoader.hidesWhenStopped = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
