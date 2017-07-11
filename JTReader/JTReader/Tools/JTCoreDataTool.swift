
//
//  JTCoreDataTool.swift
//  JTReader
//
//  Created by jiangT on 2017/6/26.
//  Copyright © 2017年 jiangT. All rights reserved.
//

import UIKit
import CoreData

class JTCoreDataTool: NSObject {

    ///CoreData操作
    let EntityName = "DownloadBook"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //增
    /*
     * 通过AppDelegate单利来获取管理的数据上下文对象，操作实际内容
     * 通过NSEntityDescription.insertNewObjectForEntityForName方法创建实体对象
     * 给实体对象赋值
     * 通过saveContext()保存实体对象
     */
    func addCoreData(saveBook : Book)
    {
        let context = getContext()
        // 定义一个entity，这个entity一定要在xcdatamodeld中做好定义
        let entity = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        
        let book = NSManagedObject(entity: entity!, insertInto: context)
//        bookName = book.bookName
//        catalogName = book.catalogName
//        bookIcon = book.bookIcon
//        bookDesc = book.bookDesc
//        zipUrl = book.zipUrl
//        score = book.score.floatValue
//        id = book.id.floatValue
        //设置数据
        book.setValue(saveBook.bookName, forKey: "bookName")
        book.setValue(saveBook.catalogName, forKey: "catalogName")
        book.setValue(saveBook.bookIcon, forKey: "bookIcon")
        book.setValue(saveBook.bookDesc, forKey: "bookDesc")
        book.setValue(saveBook.zipUrl, forKey: "zipUrl")
        book.setValue(saveBook.score, forKey: "score")
        book.setValue(saveBook.id, forKey: "id")
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
    
    //删
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 通过context.delete删除查询出来的某一个对象
     * 通过saveContext()保存修改后的实体对象
     */
    func deleteCoreData(ConditionDic deletBook:Book)
    {
        //获取数据上下文对象
        let context = getContext()
        
        //声明数据的请求
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName)
        
        //设置查询条件
        let condition = "id='周杰伦'"
        let predicate = NSPredicate(format: condition, "")
        request.predicate = predicate
        
        //查询操作
        do{
            //查询满足条件的联系人
            let resultsList = try context.fetch(request) as! [DownloadBook]
            
            if resultsList.count != 0 {//若结果为多条，则只删除第一条，可根据你的需要做改动
                //删除对象
                context.delete(resultsList[0] as NSManagedObject)
                
                //重新保存
                try context.save()
                print("delete success ~ ~")
            }else{
                print("删除失败！ 没有符合条件的联系人！")
            }
        }catch{
            print("delete fail !")
        }
}
    
    //3、修改数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 将查询出来的数据进行修改,也即进行赋新值
     * 通过saveContext()保存修改后的实体对象
     */
    func updateDataWithCoreData(Model useBook:DownloadBook, Where condiArray:NSArray)
    {
        //获取数据上下文对象
        let context = getContext()
        
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: EntityName)
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: EntityName, in: context)!
        
        let condition = "name='周杰伦'"
        let predicate = NSPredicate(format: condition,"")
        request.entity = entity
        request.predicate = predicate
        do{
            let userList = try context.fetch(request) as! [DownloadBook]
            if userList.count != 0 {
                let user = userList[0]
                user.bookName = "小公举"
                try context.save()
                print("修改成功 ~ ~")
            }else{
                print("修改失败，没有符合条件的联系人！")
            }
        }catch{
            print("修改失败 ~ ~")
        }
        
    }
    
    
    
    //4、查询数据的具体操作如下
    /*
     * 利用NSFetchRequest方法来声明数据的请求，相当于查询语句
     * 利用NSEntityDescription.entityForName方法声明一个实体结构，相当于表格结构
     * 利用NSPredicate创建一个查询条件，并设置请求的查询条件
     * 通过context.fetch执行查询操作
     * 使用查询出来的数据
     */
    func selectDataFromCoreData() -> NSArray
    {
        //获取数据上下文对象
        let context = getContext()
        
        var dataSource = NSArray()
        let request : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest()
        let entity:NSEntityDescription? = NSEntityDescription.entity(forEntityName: EntityName, in: context)
        request.entity = entity
        do{
            dataSource = try context.fetch(request) as! [DownloadBook] as NSArray
            print("数据读取成功 ~ ~")
        }catch{
            print("get_coredata_fail!")
        }
        
        return dataSource
    }
    
    
    //查询所有数据并输出
    func printAllDataWithCoreData() -> ([DownloadBook])
    {
        //获取数据上下文对象
        let context = getContext()
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: EntityName)
        
        //3
        do {
            let allBooks = try context.fetch(fetchRequest) as! [DownloadBook]
            print(allBooks.count)
            
            return allBooks
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return [DownloadBook]()
        }
    }
    
    
    //获取数据上下文对象
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
}
