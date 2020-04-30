//
//  ListTableViewCell.swift
//  YMobileData
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import UIKit
import Masonry

protocol ListTableViewCellDelegate {
    func didClickRangeBtn(year: String)
}

class ListTableViewCell: UITableViewCell {
    
    var delegate:ListTableViewCellDelegate?
    var signBtn:UIButton!
    var titleLabel:UILabel!
    var numLabel:UILabel!
    var rangeLabel:UILabel!
    var indexRow:Int!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.signBtn = UIButton(type: .custom);
        self.signBtn.setImage(UIImage(named: "rangeSign"), for: .normal)
        self.signBtn.addTarget(self, action: #selector(clickRangeBtn(button:)), for: .touchUpInside)
        self.addSubview(self.signBtn)
        self.signBtn.mas_makeConstraints{(make) in
            make?.trailing.offset()(-15)
            make?.width.height()?.offset()(40)
            make?.centerY.offset()
        }
        //
        self.titleLabel = UILabel()
        self.titleLabel.textColor = .white
        self.addSubview(self.titleLabel)
        self.titleLabel.mas_makeConstraints{(make) in
        make?.leading.equalTo()(self.signBtn.mas_trailing)?.offset()(3)
            make?.leading.mas_equalTo()(15)
            make?.height.offset()(40)
            make?.centerY.offset()
        }
        //
        self.numLabel = UILabel()
        self.numLabel.textColor = .white
        self.addSubview(self.numLabel)
        self.numLabel.mas_makeConstraints{(make) in
            make?.height.offset()(40)
            make?.centerY.offset()
            make?.centerX.offset()
        }
        //
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickRangeBtn(button: UIButton) {
        let str = self.titleLabel.text!
        self.delegate?.didClickRangeBtn(year: str)
    }
}
