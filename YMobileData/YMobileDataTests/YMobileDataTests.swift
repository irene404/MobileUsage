//
//  YMobileDataTests.swift
//  YMobileDataTests
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import XCTest
import UIKit
import Alamofire
@testable import YMobileData

class YMobileDataTests: XCTestCase {

    var vcon : ViewController!
    var smanager: SQLManager!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        vcon = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? ViewController
        smanager = SQLManager.shareInstance()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        vcon = nil
        smanager = nil
    }
    
    //测试计算数据库是否创建成功
    func testDBCreate(){
        let isopen = smanager.openDB()
        XCTAssert(isopen == true)
    }
    
    //测试插入数据
    func testInsertVolumeData(){
        if smanager.openDB() {
            let issuccess = smanager.insertVolumneData(quarter: "2014-q2", volume: "23.2", year: "2014")
            XCTAssert(issuccess == true)
        }
    }
    
    //测试插入年份数据
    func testInsertRelateData(){
        if smanager.openDB() {
            let issuccess = smanager.insertRelateData(year: "2011")
            XCTAssert(issuccess == true)
        }
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
            
        }
    }
    
    func testAsynNetworkTest(){

        let networkExpection = expectation(description: "networkDownSuccess")
            Alamofire.request("https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f", method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (respons) in
                XCTAssertNotNil(respons)
                networkExpection.fulfill()
            }
            let result = XCTWaiter(delegate: self).wait(for: [networkExpection], timeout:  1)
            if result == .timedOut {
                print("超时")
        }
    }

}
