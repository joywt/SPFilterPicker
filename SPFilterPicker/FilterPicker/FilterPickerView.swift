//
//  FilterPickerView.swift
//  SPFilterPicker
//
//  Created by wang tie on 2017/3/9.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit
import SnapKit
class FilterPickerView: UIView,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate{

    let  cellIdentifier = "filterPickerListViewCell"
    let tagOffset = 100
    weak var delegate:FilterPickerViewDelegate?
    weak var dataSource:FilterPickerViewDataSource?
    var filterListView:UIView?
    var currentComponent = 0
    var isShowFilterListView = OnOffSwitch.Off
    var components = [FilterTitle]()
    lazy var listView:UITableView = {
        let view = UITableView.init(frame: CGRect.zero, style: .plain)
        view.delegate = self
        view.dataSource = self
        view.tableFooterView = UIView()
        view.rowHeight = 45
        view.register(UITableViewCell.self, forCellReuseIdentifier: "filterPickerListViewCell")
        return view
    }()
    
    lazy var componentView: UIView = {
        let bounds = UIScreen.main.bounds
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func filterPickView(_ frame:CGRect,dataSource:FilterPickerViewDataSource,delegate:FilterPickerViewDelegate,components:[FilterTitle]) -> FilterPickerView {
        let filerPick = FilterPickerView(frame:frame)
        filerPick.delegate = delegate
        filerPick.dataSource = dataSource
        filerPick.components = components
        filerPick.setupUI()
        return filerPick
    }
    
    func setupUI(){
        componentView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 50.0)
        let sep = UIView(frame:CGRect.init(x: 0, y: 49.5, width: self.frame.size.width, height: 0.5))
        sep.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        componentView.addSubview(sep)
        
        let count = components.count
        let ftHeight:CGFloat = 50.0
        let ftWidth = self.frame.size.width / CGFloat(count)
        for i in 0..<count {
            let x = ftWidth * CGFloat(i)
            let ft = FilterTitleView.init(frame: CGRect(x: x, y: 0, width: ftWidth, height: ftHeight))
            let tp = UITapGestureRecognizer.init(target: self, action: #selector(filterTitleSelect))
            ft.addGestureRecognizer(tp)
            ft.tag = i + tagOffset
            ft.reloadData( components[i])
            componentView.addSubview(ft)
        }
        addSubview(componentView)
    }
    
    func reloadFilterView() {
        let labels = componentView.subviews
        for view in labels {
            if ((view as? FilterTitleView) != nil) {
                let ft:FilterTitleView = view as! FilterTitleView
                let tag = ft.tag - tagOffset
                ft.reloadData(components[tag])
            }
        }
    }
    func filterTitleSelect(tp:UIGestureRecognizer){
        
        if let ft:FilterTitleView = tp.view as! FilterTitleView? {
            let tag = ft.tag - tagOffset
            if currentComponent != tag{
                self.hideFilterListView()
            }
            currentComponent = tag
            if (delegate?.pickerView(self, shouldShowListView: tag))! {
                self.showFilterListView()
                listView.reloadData()
            }
            isShowFilterListView.toggle()
            changeFilterTitleView(.change,title:nil,changeView: ft)
        }
    }
    
    func changeFilterTitleView(_ op:FilterTitle.Operation,title:String?,changeView filterTitleView:FilterTitleView){
        var ft = components[currentComponent]
        ft.changeStatus(op)
        if let name = title{
           ft.name = name
        }
        
        //components[currentComponent] = ft
        filterTitleView.reloadData(ft)
    }
    func showFilterListView(){
        
        if isShowFilterListView == .Off{
            let y = self.frame.size.height + self.frame.origin.y
            let height = UIScreen.main.bounds.size.height - y
            let backgroundView = UIView.init(frame: CGRect.init(x: 0, y: y, width: self.frame.size.width, height: height))
            backgroundView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
            let tp = UITapGestureRecognizer.init(target: self, action: #selector(hideFilterListView))
            tp.delegate = self
            backgroundView.clipsToBounds = false
            backgroundView.addGestureRecognizer(tp)
            self.listView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 0)
            backgroundView.addSubview(listView)
            
            UIApplication.shared.keyWindow?.addSubview(backgroundView)
            filterListView = backgroundView
            
            UIView.animate(withDuration: 0.5) {
                self.listView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 225)
            }

        }else {
            filterListView?.removeFromSuperview()
        }
    }
    
    func hideFilterListView(){
        
        if let ft:FilterTitleView = self.viewWithTag(currentComponent + tagOffset) as! FilterTitleView? {
            changeFilterTitleView(.reset,title:ft.currentTitle, changeView: ft)
        }
        if isShowFilterListView == .On {
            isShowFilterListView.toggle()
            filterListView?.removeFromSuperview()
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view {
            if touchView.isDescendant(of: listView){
                return false
            }
        }
        return true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.pickerView(self, numberOfRowsInComponent: currentComponent) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let title = delegate?.pickerView(self, titleForRow: indexPath.row, forComponent: currentComponent) ?? ""
        cell.textLabel?.text = title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = delegate?.pickerView(self, rowHeightForComponent: currentComponent) ?? 0.0
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let title = delegate?.pickerView(self, titleForRow: indexPath.row, forComponent: currentComponent) ?? ""
        if let ft:FilterTitleView = self.viewWithTag(currentComponent + tagOffset) as! FilterTitleView? {
            changeFilterTitleView(.reset,title: title, changeView: ft)
        }
        if isShowFilterListView == .On {
            isShowFilterListView.toggle()
            filterListView?.removeFromSuperview()
        }
        delegate?.pickerView(self, didSelectRow: indexPath.row, inComponent: currentComponent)
    }

}

protocol FilterPickerViewDataSource: NSObjectProtocol {
    
    //func numberOfComponents(in pickerView: FilterPickerView) -> Int
    
    func pickerView(_ pickerView: FilterPickerView, numberOfRowsInComponent component: Int) -> Int
    
    
}

protocol FilterPickerViewDelegate: NSObjectProtocol {
    
    
    //func pickerView(_ pickerView: FilterPickerView, filterTitle component: Int) -> FilterTitle?
    func pickerView(_ pickerView: FilterPickerView, rowHeightForComponent component: Int) -> CGFloat
    func pickerView(_ pickerView: FilterPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    func pickerView(_ pickerView: FilterPickerView, didSelectRow row: Int, inComponent component: Int)
   // func pickerView(_ pickerView: FilterPickerView, didSelectComponent component: Int)
    func pickerView(_ pickerView: FilterPickerView, shouldShowListView component: Int) -> Bool
}


