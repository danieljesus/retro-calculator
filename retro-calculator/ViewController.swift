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
    
    var numberDisplayed: Double = 0
    var memoryerDisplayed: Double = 0
    var leftNumber: Double?
    var rightNumber: Double?
    var booleanPrepareToCleanScreen = false

    var currentOperation : Operation = Operation.Empty
    
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
    
    @IBAction func clearData(sender: UIButton) {
        playSound()
        numberDisplayed = 0
        memoryerDisplayed = 0
        leftNumber = nil
        rightNumber = nil
        booleanPrepareToCleanScreen = false
        printTheScreen()
    }
    
    @IBAction func numberPressed(btn: UIButton!){
        playSound()
        if booleanPrepareToCleanScreen {
            cleanScreen()
            booleanPrepareToCleanScreen = false
            numberDisplayed = Double(btn.tag)
        }else{
            numberDisplayed = numberDisplayed * 10 + Double(btn.tag)
        }
        printTheScreen()
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
        playSound()
        if Operation.Empty != currentOperation && nil != leftNumber {
            if nil == rightNumber {
                rightNumber = numberDisplayed;
            }
            getResult()
        }
    }
    
    func getResult(){
        var result: Double = 0
        if Operation.Multiply == currentOperation {
            result = leftNumber! * rightNumber!
        } else if Operation.Divide == currentOperation {
            result = leftNumber! / rightNumber!
        } else if Operation.Add == currentOperation {
            result = leftNumber! + rightNumber!
        } else if Operation.Substract == currentOperation {
            result = leftNumber! - rightNumber!
        }
        numberDisplayed = result
        leftNumber = result
        
        printTheScreen()
        
    }
    
    func processOperation(operation: Operation) {
        playSound()
        rightNumber = nil
        leftNumber = numberDisplayed;
        currentOperation = operation;
        booleanPrepareToCleanScreen = true

    }
    
    func printTheScreen(){
        outputLbl.text = String(format: "%g", numberDisplayed)
    }
    
    func cleanScreen(){
        outputLbl.text = ""
    }
    
    func playSound() {
        if btnSound.playing {
            btnSound.stop()
        }
        btnSound.play()
    }
}

