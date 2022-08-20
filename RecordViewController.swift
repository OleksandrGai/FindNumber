//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Alex Gailiunas on 16.08.2022.
//

import UIKit

class RecordViewController: UIViewController {

    
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
        if record != 0 {
            recordLabel.text = "Ваш рекорд - \(record)"
        } else {
            recordLabel.text = "У вас відсутній рекорд"
        }
    }
}
