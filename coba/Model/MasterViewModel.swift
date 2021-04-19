//
//  MasterViewModel.swift
//  coba
//
//  Created by H, Alfatkhu on 18/04/21.
//

import UIKit

class MasterViewModel {
    
    private var masterValues: Master?
    
    let id: Int!
    let name:String!
    let localized_name:String!
    let primary_attr:String!
    let attack_type:String!
    let roles: [String]
    let img:String!
    let icon:String!
    let base_health:Int!
    let base_mana:Int!
    let base_armor:Int!
    let base_attack_min:Int!
    let base_attack_max:Int!
    let move_speed:Int!
    let legs:Int!
    
    init(masterValues: Master?) {
        self.masterValues = masterValues
        
        self.id = masterValues?.id
        self.name = masterValues?.name
        self.localized_name = masterValues?.localized_name
        self.primary_attr = masterValues?.primary_attr
        self.attack_type = masterValues?.attack_type
        self.roles = masterValues!.roles
        self.img = masterValues?.img
        self.icon = masterValues?.icon
        self.base_health = masterValues?.base_health
        self.base_mana = masterValues?.base_mana
        self.base_armor = masterValues?.base_armor
        self.base_attack_min = masterValues?.base_attack_min
        self.base_attack_max = masterValues?.base_attack_max
        self.move_speed = masterValues?.move_speed
        self.legs = masterValues?.legs
    }
}
