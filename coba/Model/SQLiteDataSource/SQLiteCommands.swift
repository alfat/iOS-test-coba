//
//  SQLiteCommands.swift
//  coba
//
//  Created by H, Alfatkhu on 18/04/21.
//

import Foundation
import SQLite
import SwiftyJSON

class SQLiteCommands {
    
    static var table = Table("heroDota")
    
    // Expressions
    static let id = Expression<Int>("id")
    static let name = Expression<String>("name")
    static let localized_name = Expression<String>("localized_name")
    static let primary_attr = Expression<String>("primary_attr")
    static let attack_type = Expression<String>("attack_type")
    static let roles = Expression<String>("roles")
    static let img = Expression<String>("img")
    static let icon = Expression<String>("icon")
    static let base_health = Expression<Int>("base_health")
    static let base_mana = Expression<Int>("base_mana")
    static let base_armor = Expression<Int>("base_armor")
    static let base_attack_min = Expression<Int>("base_attack_min")
    static let base_attack_max = Expression<Int>("base_attack_max")
    static let move_speed = Expression<Int>("move_speed")
    static let legs = Expression<Int>("legs")
    
    // Creating Table
    static func createTable() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
            // ifNotExists: true - Will NOT create a table if it already exists
            try database.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(name)
                table.column(localized_name)
                table.column(primary_attr)
                table.column(attack_type)
                table.column(roles)
                table.column(img)
                table.column(icon)
                table.column(base_health)
                table.column(base_mana)
                table.column(base_armor)
                table.column(base_attack_min)
                table.column(base_attack_max)
                table.column(move_speed)
                table.column(legs)

            })
        } catch {
            print("Table already exists: \(error)")
        }
    }
    
    // Inserting Row
    static func insertRow(_ masterValues: [Any]) -> Bool?{
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return false
        }
        
        do {
            for i in 0..<masterValues.count {
                let tempRoles = (masterValues[i] as AnyObject).object(forKey: "roles") as! [Any] as NSArray
                let idVal = ((masterValues[i] as AnyObject).object(forKey: "id") as! NSNumber).intValue
                let nameVal = ((masterValues[i] as AnyObject).object(forKey: "name") as? String ?? "")
                let localized_nameVal = ((masterValues[i] as AnyObject).object(forKey: "localized_name") as? String ?? "")
                let primary_attrVal = ((masterValues[i] as AnyObject).object(forKey: "primary_attr") as? String ?? "")
                let attack_typeVal = ((masterValues[i] as AnyObject).object(forKey: "attack_type") as? String ?? "")
                let imgVal = ((masterValues[i] as AnyObject).object(forKey: "img") as? String ?? "")
                let iconVal = ((masterValues[i] as AnyObject).object(forKey: "icon") as? String ?? "")
                let base_healthVal = ((masterValues[i] as AnyObject).object(forKey: "base_health") as! NSNumber).intValue
                let base_manaVal = ((masterValues[i] as AnyObject).object(forKey: "base_mana") as! NSNumber).intValue
                let base_armorVal = ((masterValues[i] as AnyObject).object(forKey: "base_armor") as! NSNumber).intValue
                let base_attack_minVal = ((masterValues[i] as AnyObject).object(forKey: "base_attack_min") as! NSNumber).intValue
                let base_attack_maxVal = ((masterValues[i] as AnyObject).object(forKey: "base_attack_max") as! NSNumber).intValue
                let move_speedVal = ((masterValues[i] as AnyObject).object(forKey: "move_speed") as! NSNumber).intValue
                let legsVal = ((masterValues[i] as AnyObject).object(forKey: "legs") as! NSNumber).intValue
                
                
                try database.run(table.insert(or: .replace,id <- idVal,
                                              name <- nameVal,
                                              localized_name <- localized_nameVal,
                                              primary_attr <- primary_attrVal,
                                              attack_type <- attack_typeVal,
                                              roles <- tempRoles.componentsJoined(by: ","),
                                              img <- imgVal,
                                              icon <- iconVal,
                                              base_health <- base_healthVal,
                                              base_mana <- base_manaVal,
                                              base_armor <- base_armorVal,
                                              base_attack_min <- base_attack_minVal,
                                              base_attack_max <- base_attack_maxVal,
                                              move_speed <- move_speedVal,
                                              legs <- legsVal))
            }
            return true
        } catch let Result.error(message, code, statement) where code == SQLITE_CONSTRAINT {
            print("Insert row failed: \(message), in \(String(describing: statement))")
            return false
        } catch let error {
            print("Insertion failed: \(error)")
            return false
        }
    }
    
    // Present Rows
    static func presentRows() -> [Master]? {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return nil
        }
    
        // Master Array
        var masterArray = [Master]()
        
        // Sorting data in descending order by ID
        table = table.order(id.asc)
        
        do {
            for master in try database.prepare(table) {
                
                let idValue = master[id]
                let nameValue = master[name]
                let localized_nameValue = master[localized_name]
                let primary_attrValue = master[primary_attr]
                let attack_typeValue = master[attack_type]
                let rolesValue = master[roles]
                let imgValue = master[img]
                let iconValue = master[icon]
                let base_healthValue = master[base_health]
                let base_manaValue = master[base_mana]
                let base_armorValue = master[base_armor]
                let base_attack_minValue = master[base_attack_min]
                let base_attack_maxValue = master[base_attack_max]
                let move_speedValue = master[move_speed]
                let legsValue = master[legs]
           
                // Create object
                let masterObject = Master(id: idValue, name: nameValue, localized_name: localized_nameValue, primary_attr: primary_attrValue, attack_type: attack_typeValue, roles: Array(arrayLiteral: rolesValue), img: imgValue, icon: iconValue, base_health: base_healthValue, base_mana: base_manaValue, base_armor: base_armorValue, base_attack_min: base_attack_minValue, base_attack_max: base_attack_maxValue, move_speed: move_speedValue, legs: legsValue)
                // Add object to an array
                masterArray.append(masterObject)
                
                print("id \(master[id]), name: \(master[name]), localized_name: \(master[localized_name]), primary_attr: \(master[primary_attr]), attack_type: \(master[attack_type])")
            }
        } catch {
            print("Present row error: \(error)")
        }
        
        return masterArray
    }
    
    // Delete Row
    static func deleteRow() {
        guard let database = SQLiteDatabase.sharedInstance.database else {
            print("Datastore connection error")
            return
        }
        
        do {
//            let master = table.filter(id == masterId).limit(1)
            try database.run(table.delete())
        } catch {
            print("Delete row error: \(error)")
        }
    }
}
