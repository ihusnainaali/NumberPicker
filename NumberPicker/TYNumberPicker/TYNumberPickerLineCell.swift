//
//  TYNumberPickerLineCell.swift
//  NumberPicker
//
//  Created by Yash Thaker on 19/10/18.
//  Copyright © 2018 Yash Thaker. All rights reserved.
//

import UIKit

class TYNumberPickerLineCell: UICollectionViewCell {
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(lineView)
    }
    
    func calcLineViewHeight(_ index: Int, bgColor: UIColor) {
        if index % 5 == 0 {
            lineView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 80)
            lineView.backgroundColor = bgColor
            
        } else {
            lineView.frame = CGRect(x: 0, y: 15, width: bounds.width, height: 50)
            lineView.backgroundColor = bgColor.withAlphaComponent(0.7)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
