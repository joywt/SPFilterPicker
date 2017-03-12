//
//  FilterTitleView.swift
//  SPFilterPicker
//
//  Created by wang tie on 2017/3/10.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit
import SnapKit
class FilterTitleView: UIView {
    
    private let nameLabel:UILabel = UILabel()
    private let imageView:UIImageView = UIImageView()
    private var currentFilterTitle:FilterTitle?
    override init(frame: CGRect) {
        super.init(frame: frame)
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textAlignment = .center
        addSubview(nameLabel)
        addSubview(imageView)
        setNeedsLayout()
    }
    override func updateConstraints() {
        super.updateConstraints()
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
        imageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.centerY.equalToSuperview()
            make.left.equalTo(nameLabel.snp.right).offset(0)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(_ data:FilterTitle){
        currentFilterTitle = data
        nameLabel.text = data.name
        imageView.image = UIImage(named:data.imageName)
        self.setNeedsUpdateConstraints()
    }
    var currentTitle:String {
        return nameLabel.text!
    }
    //
    /*
    func selected(){
        if let ft = currentFilterTitle{
            self.reloadData(ft)
        }
    }*/
}
