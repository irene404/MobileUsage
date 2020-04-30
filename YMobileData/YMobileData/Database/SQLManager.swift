//
//  SQLManager.swift
//  YMobileData
//
//  Created by ye on 2020/4/29.
//  Copyright © 2020 ye. All rights reserved.
//

import UIKit
import SQLite3

class SQLManager: NSObject {
    
    var db:OpaquePointer? = nil
    static let instance = SQLManager()
    class func shareInstance() -> SQLManager {
        return instance
    }
    
    func openDB() -> Bool {
        let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!
        print(filePath)
        let file = filePath + "/mobileUsage.sqlite"
        let cfile = file.cString(using: String.Encoding.utf8)
        let state = sqlite3_open(cfile,&db)
        if state != SQLITE_OK{
            print("打开数据库失败")
            return false
        }
        //创建表
        return creatTable()
    }
    //创建表
    func creatTable() -> Bool {
        //创建用量表
        let sql = "CREATE TABLE IF NOT EXISTS 'usage_table' ('id' integer NOT NULL PRIMARY KEY AUTOINCREMENT,'quarter' text,'volume' text , 'year' text);"
        execSql(sql: sql)
        //创建关系表
        let sql2 = "CREATE TABLE IF NOT EXISTS 'usageRelate_table' ('id' integer NOT NULL PRIMARY KEY AUTOINCREMENT, 'year' text);"
        return execSql(sql: sql2)
    }
    
    func execSql(sql:String) -> Bool {
        let csql = sql.cString(using: String.Encoding.utf8)
        return sqlite3_exec(db, csql, nil, nil, nil) == SQLITE_OK
    }
    //插入数据
    func insertVolumneData(quarter: String, volume: String, year: String) -> Bool {
        let sql = "INSERT INTO usage_table" +
            "(quarter, volume, year)" +
            "VALUES" +
        "('\(quarter)', \(volume), \(year));"
        return execSql(sql: sql)
    }
    //
    func insertRelateData( year: String) -> Bool {
        let sql = "INSERT INTO usageRelate_table" +
            "(year)" +
            "VALUES" +
        "(\(year));"
        return execSql(sql: sql)
    }
    //查询数据
    func selectVolumneDataForYears() -> [Any]? {
        var stmt:OpaquePointer? = nil
        let sql = "select sum(volume) as volume, year from usage_table group by year"
        let csql = (sql.cString(using: String.Encoding.utf8))!
        if sqlite3_prepare(db, csql, -1, &stmt, nil) != SQLITE_OK {
            print("未准备好")
            return nil
        }
        //准备好
        var tempArr = [Any]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            let volume = String.init(cString: sqlite3_column_text(stmt, 0)!)
            let year = String.init(cString: sqlite3_column_text(stmt, 1)!)
            let item:Dictionary<String, String> = ["volume": volume, "year": year]
            tempArr.append(item)
        }
        return tempArr
    }
    //获取数据波动大的年份
    func selectFluctuationYears() -> [Any]? {
        var stmt:OpaquePointer? = nil
        let sql = "select year from usageRelate_table"
        let csql = (sql.cString(using: String.Encoding.utf8))!
        if sqlite3_prepare(db, csql, -1, &stmt, nil) != SQLITE_OK {
            print("未准备好")
            return nil
        }
        //准备好
        var tempArr = [String]()
        while sqlite3_step(stmt) == SQLITE_ROW {
            
            let year = String.init(cString: sqlite3_column_text(stmt, 0)!)
            tempArr.append(year)
        }
        return tempArr
    }
    //删除数据
    func deleteVolumneData() {
       
        let deleSql = "delete from usage_table;"
        if execSql(sql: deleSql) {
            print("删除成功")
        }else{
             print("删除失败")
        }
    }
    //删除数据
    func deleteYearsData() {
       
        let deleSql = "delete from usageRelate_table;"
        if execSql(sql: deleSql) {
            print("删除成功")
        }else{
             print("删除失败")
        }
    }
}
