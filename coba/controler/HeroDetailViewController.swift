//
//  HeroDetailViewController.swift
//  coba
//
//  Created by H, Alfatkhu on 17/04/21.
//

import UIKit
import SDWebImage

class HeroDetailViewController: UIViewController {
    
    var dictDetailData = NSDictionary()
    var arrMasterDataCopy : [Any] = []
    var arrDataAttrSama = NSMutableArray()
    var arrDataRoleSama = NSMutableArray()
    var arrDataMaxMoveSpeed = NSMutableArray()
    @IBOutlet weak var viewProfilHero: UIView!
    @IBOutlet weak var imgHeroProfile: UIImageView!
    @IBOutlet weak var lbNameHero: UILabel!
    @IBOutlet weak var iconPanah: UIImageView!
    @IBOutlet weak var lbRole: UILabel!
    @IBOutlet weak var lbValRole: UILabel!
    @IBOutlet weak var viewStatistik: UIView!
    @IBOutlet weak var imgPedang: UIImageView!
    @IBOutlet weak var lbValPedang: UILabel!
    @IBOutlet weak var imgArmor: UIImageView!
    @IBOutlet weak var lbValArmor: UILabel!
    @IBOutlet weak var imgSpeed: UIImageView!
    @IBOutlet weak var lbValSpeed: UILabel!
    @IBOutlet weak var lbHealt: UIImageView!
    @IBOutlet weak var lbValHealt: UILabel!
    @IBOutlet weak var imgAttack: UIImageView!
    @IBOutlet weak var lbValAttack: UILabel!
    @IBOutlet weak var imgAgi: UIImageView!
    @IBOutlet weak var lbValAgi: UILabel!
    @IBOutlet weak var viewHeroStrong: UIView!
    @IBOutlet weak var lbSimiliarHeroes: UILabel!
    @IBOutlet weak var imgHero1: UIImageView!
    @IBOutlet weak var imgHero2: UIImageView!
    @IBOutlet weak var imgHero3: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lbNameHero.text = ""
        lbValArmor.text = ""
        lbValAttack.text = ""
        lbValAgi.text = ""
        lbValRole.text = ""
        lbValSpeed.text = ""
        lbValHealt.text = ""
        lbValPedang.text = ""
        
        let tempRoles = dictDetailData.object(forKey: "roles") as! [Any] as NSArray
        self.checkArr()
        let ImgHero = (dictDetailData.object(forKey: "img") as! String)
        DispatchQueue.main.async { [self] in
            imgHeroProfile.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + ImgHero), completed: nil)
        }
        lbNameHero.text = (dictDetailData.object(forKey: "localized_name") as! String)
        lbValRole.text = tempRoles.componentsJoined(by: ",")
        lbValPedang.text = (dictDetailData.object(forKey: "base_attack_min") as! NSNumber).stringValue + "-" + (dictDetailData.object(forKey: "base_attack_max") as! NSNumber).stringValue
        lbValArmor.text = (dictDetailData.object(forKey: "base_armor") as! NSNumber).stringValue + "." + (dictDetailData.object(forKey: "legs") as! NSNumber).stringValue
        lbValSpeed.text = (dictDetailData.object(forKey: "move_speed") as! NSNumber).stringValue
        lbValHealt.text = (dictDetailData.object(forKey: "base_health") as! NSNumber).stringValue
        lbValAttack.text = (dictDetailData.object(forKey: "base_mana") as! NSNumber).stringValue
        lbValAgi.text = (dictDetailData.object(forKey: "primary_attr") as! String)
    }
    
    
    func checkArr(){
        arrDataAttrSama = NSMutableArray()
        arrDataRoleSama = NSMutableArray()
        let tempPrimary_Attr = dictDetailData.object(forKey: "primary_attr") as! String
        for item in 0..<arrMasterDataCopy.count {
            if (tempPrimary_Attr == (arrMasterDataCopy[item] as AnyObject).object(forKey: "primary_attr") as? String ?? "") {
                arrDataAttrSama.add(arrMasterDataCopy[item])
            }
        }
        
        
//       check roles yang sama tapi ada data gak nyampe 3 :
//        let tempRole = dictDetailData.object(forKey: "roles") as! [Any] as NSArray
//        for loop in 0..<arrDataAttrSama.count {
//                if (tempRole == (arrDataAttrSama[loop] as AnyObject).object(forKey: "roles") as! [Any] as NSArray) {
//                    arrDataRoleSama.add(arrDataAttrSama[loop])
//            }
//        }
        
        self.check3Max()
    }
    
    func check3Max(){
        arrDataMaxMoveSpeed = NSMutableArray()
        let tempPrimary_AttrMax = dictDetailData.object(forKey: "primary_attr") as! String
            if (tempPrimary_AttrMax == "agi") {
                //agi tampilkan 3 hero dengan movement speed tertinggi
                    for j in 0..<arrDataAttrSama.count{
                        let valMax = ((arrDataAttrSama[j] as AnyObject).object(forKey: "move_speed") as! NSNumber).intValue
                        let val = max(valMax, Int(truncating: ((arrDataAttrSama[j] as AnyObject).object(forKey: "move_speed") as! NSNumber)))
                        if(val > 300){
                            arrDataMaxMoveSpeed.add(arrDataAttrSama[j])
                        }
                    }
            
               
                let dateDescriptor = NSSortDescriptor(key: "move_speed", ascending: false)
                let sortedArray = arrDataMaxMoveSpeed.sortedArray(using: [dateDescriptor])
                    
                let imgHeroMoveSpeed = ((sortedArray[0] as AnyObject).object(forKey: "img") as? String)!
                let imgHeroMoveSpeed1 = ((sortedArray[1] as AnyObject).object(forKey: "img") as? String)!
                let imgHeroMoveSpeed2 = ((sortedArray[2] as AnyObject).object(forKey: "img") as? String)!
                DispatchQueue.main.async { [self] in
                        imgHero1.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed), completed: nil)
                        imgHero2.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed1), completed: nil)
                        imgHero3.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed2), completed: nil)
                    }
            }
            else if(tempPrimary_AttrMax == "str"){
                //tampilkan 3 hero dengan base attack max tertinggi
                for j in 0..<arrDataAttrSama.count{
                    let valMax = ((arrDataAttrSama[j] as AnyObject).object(forKey: "base_attack_max") as! NSNumber).intValue
                    let val = max(valMax, Int(truncating: ((arrDataAttrSama[j] as AnyObject).object(forKey: "base_attack_max") as! NSNumber)))
                    if((val) != 0){
                        arrDataMaxMoveSpeed.add(arrDataAttrSama[j])
                    }
                }
        
            let dateDescriptor = NSSortDescriptor(key: "base_attack_max", ascending: false)
            let sortedArray = arrDataMaxMoveSpeed.sortedArray(using: [dateDescriptor])
                
            let imgHeroMoveSpeed = ((sortedArray[0] as AnyObject).object(forKey: "img") as? String)!
            let imgHeroMoveSpeed1 = ((sortedArray[1] as AnyObject).object(forKey: "img") as? String)!
            let imgHeroMoveSpeed2 = ((sortedArray[2] as AnyObject).object(forKey: "img") as? String)!
            DispatchQueue.main.async { [self] in
                    imgHero1.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed), completed: nil)
                    imgHero2.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed1), completed: nil)
                    imgHero3.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed2), completed: nil)
                }
            }
            else if(tempPrimary_AttrMax == "int"){
                //tampilkan 3 hero dengan basis mana tertinggi
                for j in 0..<arrDataAttrSama.count{
                    let valMax = ((arrDataAttrSama[j] as AnyObject).object(forKey: "base_mana") as! NSNumber).intValue
                    let val = max(valMax, Int(truncating: ((arrDataAttrSama[j] as AnyObject).object(forKey: "base_mana") as! NSNumber)))
                    if((val) != 0){
                        arrDataMaxMoveSpeed.add(arrDataAttrSama[j])
                    }
                }
        
            let dateDescriptor = NSSortDescriptor(key: "base_mana", ascending: false)
            let sortedArray = arrDataMaxMoveSpeed.sortedArray(using: [dateDescriptor])
                
            let imgHeroMoveSpeed = ((sortedArray[0] as AnyObject).object(forKey: "img") as? String)!
            let imgHeroMoveSpeed1 = ((sortedArray[1] as AnyObject).object(forKey: "img") as? String)!
            let imgHeroMoveSpeed2 = ((sortedArray[2] as AnyObject).object(forKey: "img") as? String)!
            DispatchQueue.main.async { [self] in
                    imgHero1.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed), completed: nil)
                    imgHero2.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed1), completed: nil)
                    imgHero3.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + imgHeroMoveSpeed2), completed: nil)
                }
          }
    }
}
