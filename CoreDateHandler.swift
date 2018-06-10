//
//  CoreDateHandler.swift
//  I-valleyBuffte
//
//  Created by azzaz on 6/4/18.
//  Copyright © 2018 azzaz. All rights reserved.
//


import UIKit
import CoreData

class CoreDataHandler: NSObject
{
    // in this method to return the viewContext that is object from NSMAngeOblectContext to deal with data save , retrieve and so on
    fileprivate class   func getAppDelegateObj() -> NSManagedObjectContext{
        let appDelegateObject = UIApplication.shared.delegate as! AppDelegate // obj from Appdelegate to access persistentContainer method
        return appDelegateObject.persistentContainer.viewContext
    }
    // method to save data
    class  func saveData(paremeters:[String:Any],entityName:String) -> Bool
    {
        let context = getAppDelegateObj()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let mangedObj = NSManagedObject(entity:entity! , insertInto: context)
        
        if (entityName == "User")
        {
            mangedObj.setValue(paremeters["name"], forKey:"name")
            mangedObj.setValue(paremeters["password"], forKey:"password")
            mangedObj.setValue(paremeters["confirmPassword"] , forKey:"confirmPassword")
            mangedObj.setValue(paremeters["telephoneNumber"], forKey:"telephoneNumber")
            mangedObj.setValue(paremeters["userId"], forKey:"userId")
            mangedObj.setValue(paremeters["username"], forKey:"username")
        }
        else if (entityName == "Item")
        {
            mangedObj.setValue(paremeters["name"], forKey:"name")
            mangedObj.setValue(paremeters["availbe"] , forKey:"availbe")
            mangedObj.setValue(paremeters["price"], forKey:"price")
            mangedObj.setValue(paremeters["itemId"] , forKey:"itemId")
            mangedObj.setValue(paremeters["itemDate"] , forKey:"itemDate")
        }
        else if (entityName == "Order")
        {
            mangedObj.setValue(paremeters["count"], forKey:"count")
            mangedObj.setValue(paremeters["itemId"], forKey:"itemId")
            mangedObj.setValue(paremeters["name"] , forKey:"name")
            mangedObj.setValue(paremeters["payed"] , forKey:"payed")
            mangedObj.setValue(paremeters["placed"], forKey:"placed")
            mangedObj.setValue(paremeters["price"] , forKey:"price")
            mangedObj.setValue(paremeters["totalCost"] , forKey:"totalCost")
        }
        
        do {
            try context.save()
            return true
        }
        catch
        {
            print("Error")
            return false
        }
        // End of the method
    }
    
    class func getData(entitty:String) -> [Any]?
    {
        let context = getAppDelegateObj()
        
        if entitty == "User"
        {
            var arrayOfUsers :[User]?
            do{
                arrayOfUsers =  try context.fetch(User.fetchRequest())
                return arrayOfUsers
            }
            catch
            {
                return arrayOfUsers
            }
        }
        else if entitty == "Order"
        {
            var arrayOfUsers :[Order]?
            do{
                arrayOfUsers =  try context.fetch(Order.fetchRequest())
                return arrayOfUsers
            }
            catch
            {
                return arrayOfUsers
            }
        }
        else if entitty == "Item"
        {
            var arrayOfUsers :[Item]?
            do{
                arrayOfUsers =  try context.fetch(Item.fetchRequest())
                return arrayOfUsers
            }
            catch
            {
                return arrayOfUsers
            }
        }
        return ["No entity"]
    }
    // to remove Item
    class func remove(indexPath:IndexPath,array:[Any])
    {
        let context = getAppDelegateObj()
        if indexPath.row >= 0 && indexPath.row >= 0
        {
            context.delete(array[indexPath.row] as! NSManagedObject)
            do{
                try context.save()
                print("delete sucssefully")
            }
            catch{
                debugPrint("couldn't remove data \(error.localizedDescription)")
            }
        }
        
    }
    
    
    // end of the class
}


