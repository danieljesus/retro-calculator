//
//  ViewController.swift
//  retro-calculator
//
//  Created by Daniel Jesús Martín Flores on 16/2/16.
//  Copyright © 2016 Daniel Jesús Martín Flores. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String{
        case Divide = "/"
        case Multiply = "*"
        case Substract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    
    var runningNumber = ""
    var leftValStr = ""
    var rightValStr = ""
    var currentOperation : Operation = Operation.Empty
    var result = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do{
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrl)
            btnSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    @IBAction func numberPressed(btn: UIButton!){
        playSound()
        
        runningNumber += "\(btn.tag)"
        outputLbl.text = runningNumber
    }
   
    @IBAction func onDividePressed(sender: UIButton) {
        processOperation(Operation.Divide)
    }

    @IBAction func onMultiplyPressed(sender: UIButton) {
        processOperation(Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: UIButton) {
        processOperation(Operation.Substract)
    }
    
    @IBAction func onAddPressed(sender: UIButton) {
        processOperation(Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: UIButton) {
        processOperation(currentOperation)
    }
    
    func processOperation(operation: Operation) {
        playSound()
        
        if Operation.Empty != currentOperation {
            
            if "" != runningNumber {
                rightValStr = runningNumber
                runningNumber = ""
                
                if Operation.Multiply == operation {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if Operation.Divide == operation {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if Operation.Substract == operation {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if Operation.Add == operation {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                leftValStr = result
                outputLbl.text = result
            }

            
            currentOperation = operation
            
        } else {
            leftValStr = runningNumber
            runningNumber = ""
            
            currentOperation = operation
        }
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
}

