//
//  ViewController.swift
//  SPFilterPicker
//
//  Created by wang tie on 2017/3/9.
//  Copyright © 2017年 360jk. All rights reserved.
//

import UIKit

class ViewController: UIViewController,FilterPickerViewDelegate,FilterPickerViewDataSource {
    
    let statusArray = ["初始化","跟进中","已签约","合同审核中","服务中","服务完成"]
    let timeArray = ["今日","最近一周","最近一月","最近三月","最近一年"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let ft1 = FilterTitle(name:"状态排序",noStatusImage:"more",statusImages:["less","more"])
        let ft2 = FilterTitle(name:"时间排序",noStatusImage:"more",statusImages:["less","more"])
        let ft3 = FilterTitle(name:"价格排序",noStatusImage:"sort",statusImages:["sort-dscending","sort-ascending"])
        var components = [FilterTitle]()
        components.append(contentsOf: [ft1,ft2,ft3])
        let frame = CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 50)
        let ftv = FilterPickerView.filterPickView(frame, dataSource: self, delegate: self,components: components)
        self.view.addSubview(ftv)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickerView(_ pickerView: FilterPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    func pickerView(_ pickerView: FilterPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return statusArray.count
        case 1: return timeArray.count
        default:return 0
        }
    }
    
    func pickerView(_ pickerView: FilterPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0: return statusArray[row]
        case 1: return timeArray[row]
        default:return ""
        }
    }
    func pickerView(_ pickerView: FilterPickerView, shouldShowListView component: Int) -> Bool {
        if  component == 2 {
            return false
        }
        return true
    }
  
    func pickerView(_ pickerView: FilterPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    

}

