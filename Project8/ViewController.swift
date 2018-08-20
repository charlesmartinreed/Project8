//
//  ViewController.swift
//  Project8
//
//  Created by Charles Martin Reed on 8/13/18.
//  Copyright © 2018 Charles Martin Reed. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    //letter group arrays, one to store all buttons, one to store all the buttons being used to spell an answer, one for all the possible solutions
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Outlet Collection for the button action
        
        //trying to drill down into the stack view, pull out the view and then the subviews for that view to get to the buttons
        for subview in stackView.arrangedSubviews {
            //typecast the view as a UIButton, we know it's a button since we explicitly set this up so this is fine.
            for view in subview.subviews where view.tag == 1001 {
                
                let btn = view as! UIButton
                
                letterButtons.append(btn)
                
                //attach a method to our button, when we touch up inside
                //code equivalent to ctrl-dragging to make connections in IB
                btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            }
        }
        
        
       loadLevel()
    }
    
    func loadLevel() {
        
        //stores the level's clues
        var clueString = ""
        
        //stores how many letters each answer is
        var solutionString = ""
        
        //stores the letter groups, HA, UNT, ED for example
        var letterBits = [String]()
        
        //grab the txt file for the level, try to make a long string and the seperate them into lines separated by the newline character. Make an shuffled array of the strings.
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: "txt") {
            if let levelContents = try? String(contentsOfFile: levelFilePath) {
                var lines = levelContents.components(separatedBy: "\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
                
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        
        //MARK: - CONFIGURE THE BUTTONS AND LABELS AT LOAD
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        //we have same amount of elements in letterBits and letterButtons array, so this works well for a loop
        //we used the half-open range operator because we only have 20 elements BUT counting begins at 0
        if letterBits.count == letterButtons.count {
            for i in 0..<letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
        
        
    }
    
    

    @objc func letterTapped(btn: UIButton) {
        //UIButton is sent, we read the letter group on the button and use it to spell words
        //the letter groups are randomly assigned in our loadLevel()
        
    }

    @IBAction func submitTapped(_ sender: UIButton) {
    }
    
    @IBAction func clearTapped(_ sender: UIButton) {
    }
    
    
}

