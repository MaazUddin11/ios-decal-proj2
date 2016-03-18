//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var guessedLetterFromTextField: UITextField!
    @IBOutlet var hangmanImage: UIImageView!
    @IBOutlet weak var guessButton: UIButton!
    @IBOutlet weak var displayedPhrase: UILabel!
    @IBOutlet weak var wrongLettersLabel: UILabel!
    
    let hangmanImagesArray: [String] = ["hangWizard1", "hangWizard2", "hangWizard3", "hangWizard4", "hangWizard5", "hangWizard6", "hangWizard7"]
    var wronglyGuessedLetters: [String] = []
    var correctlyGuessedLetters: [String] = []
    var stringOfCorrectLettersAndUnderscores: String = ""
    var phraseThatPlayerMustGuessLettersOf: String = ""
    var numberOfWrongGuesses = 0
    var phraseLength = 0
    var gameState = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        phraseThatPlayerMustGuessLettersOf = phrase
        phraseLength = phraseThatPlayerMustGuessLettersOf.characters.count
        hangmanImage.image = UIImage(named: hangmanImagesArray[numberOfWrongGuesses])
        initializeUILabel()
        print(phrase)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Touching away from the keyboard removes keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Return button removes keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Initializes the game with "-" for every corresponding letter
    func initializeUILabel() {
        for char in phraseThatPlayerMustGuessLettersOf.characters {
            if char == " " {
                stringOfCorrectLettersAndUnderscores += "  "
            } else {
                stringOfCorrectLettersAndUnderscores += "- "
            }
        }
        displayedPhrase.text = stringOfCorrectLettersAndUnderscores
    }
    
    // When Guess is clicked, either correctly change the letter in the text field
    // or will update the hangman accordingly
    @IBAction func whenGuessIsClicked(sender: AnyObject) {
        if gameState {
            if guessedLetterFromTextField.text!.uppercaseString.characters.count != 1 {
                let invalidInputAlert = UIAlertController(title: "Invalid Input", message: "You must input 1 character", preferredStyle: UIAlertControllerStyle.Alert)
                invalidInputAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(invalidInputAlert, animated: true, completion: nil)
                
            } else if correctlyGuessedLetters.contains(guessedLetterFromTextField.text!.uppercaseString) {
                let correctlyGuessedAlert = UIAlertController(title: "Please Try Again", message: "You already tried guessing that letter", preferredStyle: UIAlertControllerStyle.Alert)
                correctlyGuessedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(correctlyGuessedAlert, animated: true, completion: nil)
                guessedLetterFromTextField.text = ""
                
            } else if isGuessedLetterInPhrase() {
                updateUILabel()
                if stringOfCorrectLettersAndUnderscores == phraseThatPlayerMustGuessLettersOf {
                    gameHasEnded()
                }
            } else {
                if wronglyGuessedLetters.contains(guessedLetterFromTextField.text!.uppercaseString) {
                    let wronglyGuessedAlert = UIAlertController(title: "Please Try Again", message: "You already tried guessing that letter", preferredStyle: UIAlertControllerStyle.Alert)
                    wronglyGuessedAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(wronglyGuessedAlert, animated: true, completion: nil)
                    guessedLetterFromTextField.text = ""
                    
                } else {
                    wrongLettersLabel.text! += guessedLetterFromTextField.text!.uppercaseString
                    wrongLettersLabel.text! += " "
                    wronglyGuessedLetters.append(guessedLetterFromTextField.text!.uppercaseString)
                    numberOfWrongGuesses += 1
                    hangmanImage.image = UIImage(named: hangmanImagesArray[numberOfWrongGuesses])
                    guessedLetterFromTextField.text = ""
                    if numberOfWrongGuesses == 6 {
                        gameHasEnded()
                    }
                }
            }
        }
    }
    
    // Helper function to see if the guessed character is in the phrase
    func isGuessedLetterInPhrase() -> Bool {
        return phraseThatPlayerMustGuessLettersOf.containsString(guessedLetterFromTextField.text!.uppercaseString)
    }
    
    // Update the UI Label with the guessed character
    func updateUILabel() {
        var temp = ""
        for char in phraseThatPlayerMustGuessLettersOf.characters {
            if correctlyGuessedLetters.contains(String(char)) {
                temp += String(char).uppercaseString
            } else if String(char).uppercaseString == guessedLetterFromTextField.text!.uppercaseString {
                temp += guessedLetterFromTextField.text!.uppercaseString
                correctlyGuessedLetters.append(String(char).uppercaseString)
            } else if char == " " {
                temp += " "
            } else {
                temp += "-"
            }
        }
        stringOfCorrectLettersAndUnderscores = temp
        displayedPhrase.text = stringOfCorrectLettersAndUnderscores
        guessedLetterFromTextField.text = ""
    }
    
    // Set the gameState to false, disallowing any further moves to be made
    func gameHasEnded() {
        gameState = false
        if numberOfWrongGuesses == 6 {
            let loseAlert = UIAlertController(title: "SORRY :(", message: "You Ran Out Of Lives", preferredStyle: UIAlertControllerStyle.Alert)
            loseAlert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.startOver("") }))
            loseAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            loseAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.newGame() }))
            self.presentViewController(loseAlert, animated: true, completion: nil)

        } else {
            let winAlert = UIAlertController(title: "CONGRATULATIONS", message: "You Guessed All The Correct Letters", preferredStyle: UIAlertControllerStyle.Alert)
            winAlert.addAction(UIAlertAction(title: "Start Over", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.startOver("") }))
            winAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            winAlert.addAction(UIAlertAction(title: "New Game", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.newGame() }))
            self.presentViewController(winAlert, animated: true, completion: nil)
        }
    }
    
    // Start a new game with a new word
    func newGame() {
        gameState = true
        viewDidLoad()
        startOver("")
    }
    
    // Start a new game with the same word
    @IBAction func startOver(sender: AnyObject) {
        gameState = true
        numberOfWrongGuesses = 0
        hangmanImage.image = UIImage(named: hangmanImagesArray[numberOfWrongGuesses])
        stringOfCorrectLettersAndUnderscores = ""
        wrongLettersLabel.text! = "Incorrect Guesses: "
        wronglyGuessedLetters = []
        correctlyGuessedLetters = []
        initializeUILabel()

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
