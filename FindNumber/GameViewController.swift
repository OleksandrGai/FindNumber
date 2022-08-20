//
//  GameViewController.swift
//  FindNumber
//
//  Created by Alex Gailiunas on 04.08.2022.
//

import UIKit

class GameViewController: UIViewController {
  
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var nextDigit: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
 
    
    lazy var game = Game(countItems: buttons.count) { [weak self](status, seconds) in
        guard let self = self else {return}
        
        self.timerLabel.text = seconds.secondsToString()
        self.updateInfoGame(with: status)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
        if Settings.shared.currentSettings.timerState == false {
            timerLabel.isHidden = true
        }

    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else { return }
        game.check(index: buttonIndex)
        
       updateUI()
       
    }
    
    
//    @IBAction func newGame(_ sender: UIButton) {
//        game.newGame()
//        sender.isHidden = true
//        setupScreen()
//    }
    
    
    private func setupScreen() {
        
        for index in game.items.indices {
            buttons[index].setTitle(game.items[index].titel, for: .normal)
          //  buttons[index].isHidden = false
            buttons[index].alpha =  1
            buttons[index].isEnabled = true
        }
        nextDigit.text = game.nextItem?.titel
    }
    func updateUI() {
        for index in game.items.indices{
          //  buttons[index].isHidden = game.items[index].isFound
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError {
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: {[weak self] (_) in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
            }
        }
    }
        nextDigit.text = game.nextItem?.titel
        
        updateInfoGame(with: game.status)
          
    }
    
    
    func updateInfoGame(with status: StatusGame){
        switch status {
        case .start :
            statusLabel.text = "Start Game!"
            statusLabel.textColor = .blue
        case.win :
            statusLabel.text = "Win!"
            statusLabel.textColor = .yellow
            if game.isNewRecord {
                schowAlert()
            } else {
                schowAlertActionSheet()
            }
        case.lose :
            statusLabel.text = "Lose!"
            statusLabel.textColor = .red
            schowAlertActionSheet()
        }
    }
    
    private func schowAlert (){
        let alert = UIAlertController(title: "Congratulations", message: "New record", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (_) in }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    private func  schowAlertActionSheet() {
        let alert = UIAlertController(title: "What we do next?" , message: nil , preferredStyle: .actionSheet)
        let newGameAction = UIAlertAction(title: "Start new game", style: .default) { [weak self](_) in
                self?.game.newGame()
                self?.setupScreen()
        }
        
        let schowRecord = UIAlertAction(title: "Records", style: .default) {[weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Settings", style: .destructive) {[weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(schowRecord)
        alert.addAction(menuAction)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

