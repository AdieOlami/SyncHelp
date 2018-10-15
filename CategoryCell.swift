//
//  CategoryCell.swift
//  Sync-Schedule
//
//  Created by Olar's Mac on 8/25/18.
//  Copyright © 2018 trybetech LTD. All rights reserved.
//

import UIKit
import ChameleonFramework

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var notificationView: UIView!
    
    @IBOutlet weak var sharingButton: UIButton?
    
    var shareButtonAction: (()->())?
    
    @IBAction func didTapShare() {
        
        shareButtonAction?()
    }
    static var completedFunc: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryView.addShadowAndRoundCorners()
        categoryView.backgroundColor = Theme.current.accent
        categoryNameLabel.font = UIFont(name: Theme.current.mainFontName, size: 30)
        notificationView.backgroundColor = UIColor.clear
        notificationView.layer.cornerRadius = 12.5
        notificationView.layer.shadowOpacity = 1
        notificationView.layer.shadowOffset = CGSize.zero
        notificationView.layer.shadowColor = UIColor.darkGray.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(categoryModel: CategoryModel) -> Void {
        categoryNameLabel.text = categoryModel.name
        guard let categoryColor = UIColor(hexString: categoryModel.color) else {fatalError()}
        categoryView.backgroundColor = categoryColor
        categoryNameLabel.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        if !categoryModel.isCompleted {
            
            notificationView.backgroundColor = UIColor.clear
            notificationView.layer.cornerRadius = 12.5
            notificationView.layer.shadowOpacity = 0
            notificationView.layer.shadowOffset = CGSize.zero
            notificationView.layer.shadowColor = UIColor.darkGray.cgColor
        } else {
           
            notificationView.backgroundColor = ContrastColorOf(categoryColor, returnFlat: true)
            notificationView.layer.cornerRadius = 12.5
            notificationView.layer.shadowOpacity = 0
            notificationView.layer.shadowOffset = CGSize.zero
            notificationView.layer.shadowColor = UIColor.darkGray.cgColor
        }
    }
}
