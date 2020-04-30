//
//  ViewController.swift
//  YMobileData
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ListTableViewCellDelegate {

    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var listTable: UITableView!
    var infoArr = [[String:String]]()
    var yearsArr = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //打开数据库
        if  SQLManager.shareInstance().openDB() {
            print("数据库打开成功")
        }
        //判断是否是iphonex
        if kIsIPhoneX() {
            titleHeight.constant = 88
        }
        initTableHeader()
        self.listTable.mj_header?.beginRefreshing()
        
    }
    
    func initTableHeader(){
        // 顶部刷新
        let header = MJRefreshNormalHeader()
        // 顶部刷新
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        listTable.mj_header = header
        
    }
    // 顶部刷新
    @objc fileprivate func headerRefresh(){
        startRequestData()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
            self.endRefresh()
        }
    }
    
    func endRefresh(){
        self.listTable.mj_header?.endRefreshing()
    }

    //MARK: UITableViewDelegate
    // 设置cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "testCellID"
        var cell:ListTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellid) as? ListTableViewCell
        if cell==nil {
            cell = ListTableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        let item:Dictionary = infoArr[indexPath.row]
        let year = item["year"]!
        cell?.titleLabel.text = year
        cell?.numLabel.text = item["volume"]
        cell?.delegate = self
        cell?.indexRow = indexPath.row
        if yearsArr.contains(year) {
            cell?.signBtn.isHidden = false
        }else {
            cell?.signBtn.isHidden = true
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: ListTableViewCellDelegate
    func didClickRangeBtn(year: String){
        
        let str = "Mobile data has large fluctuation in " + year
        let alertController = UIAlertController(title: nil, message: str, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: 数据请求
    func startRequestData() {
        let str = "https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f";
        Alamofire.request(str, method: .get, parameters: nil, encoding: URLEncoding.queryString, headers: nil).responseJSON { (response) in
            if response.result.isSuccess{
                if let dic = response.result.value as? [String: AnyObject]{
//                    print("tttttu: ", dic)
                    DispatchQueue.main.async {
                        
                        
//                        if String.isNullOrEmpty(dic["success"]) == "1" {
                        let rstate = dic["success"] as! Int
                        if rstate == 1 {
                            if let rdic = dic["result"] as? [String:Any]{
                                if let arr = rdic["records"] as? [[String:Any]]{
                                    //删除数据
                                    SQLManager.shareInstance().deleteYearsData()
                                    SQLManager.shareInstance().deleteVolumneData()
                                    //
                                    var year = ""
                                    var nyear = ""  //当前年份
                                    var tempVolume = 0.0
                                    var isIncrease = true
                                    for item in arr{
                                        let quarter = item["quarter"] as! String
                                        nyear = String(quarter.prefix(4))
                                        //插入原始数据
                                        SQLManager.shareInstance().insertVolumneData(quarter: quarter, volume: item["volume_of_mobile_data"] as! String, year: nyear)
                                        //获取某个年份，数据没有递增的
                                        let vstr = item["volume_of_mobile_data"] as! String
//                                        let num = Float(vstr)
                                        let volume = (vstr as NSString).doubleValue
                                        if nyear != year {
                                            //保存上一年的情况
                                            if year != "" {
                                                if !isIncrease {
                                                    SQLManager.shareInstance().insertRelateData(year: year)
                                                }
                                            }
                                            //重置数据
                                            isIncrease = true
                                            year = nyear
                                            tempVolume = volume
                                        }else {
                                            //与上一季度数据做比较
                                            if isIncrease {
                                                if volume < tempVolume {
                                                    isIncrease = false
                                                }
                                            }
                                            tempVolume = volume
                                        }
                                    }
                                    //保存最后一年的情况
                                    if !isIncrease {
                                        SQLManager.shareInstance().insertRelateData(year: nyear)
                                    }
                                    //刷新页面
                                    self.reloadPageData()
                                }
                            }
                        }else{
                            self.reloadPageData()
                        }
                    }
                }
            }else{
                self.reloadPageData()
            }
        }
        
    }
    
    func reloadPageData() {
        self.endRefresh()
        self.infoArr.removeAll()
        //获取数据
        let yarr = SQLManager.shareInstance().selectFluctuationYears()
        if yarr != nil {
             yearsArr = yarr as! [String]
        }
        //
        let varr = SQLManager.shareInstance().selectVolumneDataForYears()
        if varr != nil {
            infoArr = varr as! [[String: String]]
        }
        self.listTable.reloadData()
    }
    

}

