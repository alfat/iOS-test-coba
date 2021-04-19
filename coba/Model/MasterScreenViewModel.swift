//
//  MasterScreenViewModel.swift
//  coba
//
//  Created by H, Alfatkhu on 18/04/21.
//

import Foundation

class MasterScreenViewModel {
    
    private var masterArray = [Master]()
    
    func connectToDatabase() {
        _ = SQLiteDatabase.sharedInstance
    }
    
    func loadDataFromSQLiteDatabase() {
        masterArray = SQLiteCommands.presentRows() ?? []
    }
    
    func numberOfRowsInSection (section: Int) -> Int {
        if masterArray.count != 0 {
            return masterArray.count
        }
        return 0
    }
    
    func cellForRowAt (indexPath: IndexPath) -> Master {
        return masterArray[indexPath.row]
    }
}
