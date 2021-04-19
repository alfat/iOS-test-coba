//
//  ViewController.swift
//  coba
//
//  Created by H, Alfatkhu on 16/04/21.
//

import UIKit
import SVProgressHUD
import SDWebImage
import SwiftyJSON
import SQLite

protocol ButtonsMenuTitle{
    func tapName(no: Int)
}

class MenuTableViewCell: UITableViewCell {

        var delegate:ButtonsMenuTitle!
        @IBOutlet weak var btnMenu: UIButton!
        @IBAction func btnMenuClik(_ sender: Any) {
            self.delegate?.tapName(no:(sender as AnyObject).tag)
        }

}

class ImgCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgHero: UIImageView!
    @IBOutlet weak var nameHero: UILabel!
    
    func setup(with link: String, name: String) {
        DispatchQueue.main.async { [self] in
            imgHero.sd_setImage(with: URL(string: "http://cdn.dota2.com/" + link), completed: nil)
        }
        nameHero.text = name
    }
}

extension ViewController: ModelDelegate {
    func starting(model: Model) {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
    }
    
    func modeldoneWithData(model: Model, result: Any) {
        if model.isMember(of: Model.self) {
            print(model)
            _ = result as! NSArray
        }
        else if model.isMember(of: Service.self) {
            let response = result as! NSArray
            _ =  SQLiteCommands.insertRow(response as! [Any])
            arrMasterData = ((response as! [Any]) as NSCopying) as! [Any]
            tblMenuButton.reloadData()
            colectionView.reloadData()
            SVProgressHUD.dismiss()
        }
    }
    
    func modelfailedWithError(model: Model, error: NSError) {
        print("error data d ", error)
        SVProgressHUD.dismiss()
        
        let alert = UIAlertController(title: "Error", message: "Terjadi kesalahan pada server atau koneksi Anda", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            @unknown default: break
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ButtonsMenuTitle{
    var arrMasterData:[Any] = []
    var arrMasterRoles = NSMutableArray()
    var arrMenu = ["Disabler", "Nuker", "Durable","Initiator", "Escape", "Jungler", "Support", "Carry", "Pusher", "ALL"]
    private var viewModel = MasterScreenViewModel()
    
    @IBOutlet weak var tblMenuButton: UITableView!
    @IBOutlet weak var colectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Connect to database.
        viewModel.connectToDatabase()
        createTable()
        
//        SQLiteCommands.deleteRow()
//        let master =  SQLiteCommands.presentRows()
        
        self.getServiceHerostat()
        self.navigationItem.title = arrMenu.last
        tblMenuButton.delegate = self
        colectionView.dataSource = self
        colectionView.delegate = self
        colectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.blue]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        UserDefaults.standard.set(arrMenu.last, forKey: "titleClick")
        tblMenuButton.reloadData()
        colectionView.reloadData()
    }
    
    func getServiceHerostat(){
        DispatchQueue.main.async { [self] in
            let getService = Service()
            getService._apiName = "https://api.opendota.com/api/herostats"
            getService.fetchWithDelegate(_delegate: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        colectionView.reloadData()
    }
    
    // MARK: - Connect to database and create table.
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = tblMenuButton.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        cell.btnMenu.setTitle(arrMenu[indexPath.row], for: .normal)
        cell.btnMenu.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tapName(no: Int) {
        self.navigationItem.title = arrMenu[no]
        self.filterData(clickedNo: no)
    }

    func filterData(clickedNo : Int) {
        let arrTempFilterHero = NSMutableArray()
        let clickedButtonTitle = arrMenu[clickedNo]
        for i in 0..<arrMasterData.count{
            let arrRole = (arrMasterData[i] as AnyObject).object(forKey: "roles") as! [Any] as NSArray
            for a in 0..<arrRole.count {
                if(clickedButtonTitle == (arrRole[a] as! String)){
                    arrTempFilterHero.add(arrMasterData[i])
                }
            }
        }
        
        if(arrMenu[clickedNo] != "ALL"){
            arrMasterData = arrTempFilterHero.mutableCopy() as! [Any]
        }
        else{
            self.getServiceHerostat()
        }
        
        tblMenuButton.reloadData()
        colectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (arrMasterData.count == 0){
            self.getServiceHerostat()
        }
        return  arrMasterData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollectionViewCell", for: indexPath) as! ImgCollectionViewCell
        let imagelink = (arrMasterData[indexPath.row] as AnyObject).object(forKey: "img") as? String ?? ""
        let imageName = (arrMasterData[indexPath.row] as AnyObject).object(forKey: "localized_name") as? String ?? ""
        cell.setup(with: imagelink, name: imageName)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let VC = storyboard?.instantiateViewController(identifier: "HeroDetailViewController") as! HeroDetailViewController
        VC.dictDetailData = arrMasterData[indexPath.row] as! NSDictionary
        VC.arrMasterDataCopy = arrMasterData
        self.navigationController?.pushViewController(VC, animated: false)
    }
}
