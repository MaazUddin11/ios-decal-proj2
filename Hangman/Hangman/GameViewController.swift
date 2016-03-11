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
    
    let hangmanImagesArray: [String] = ["hangWizard1", "hangWizard2", "hangWizard3", "hangWizard4", "hangWizard5", "hangWizard6", "hangWizard7"]
    var wronglyGuessedLetters: [String] = []
    var stringOfCorrectLettersAndUnderscores: String = ""
    var phraseThatPlayerMustGuessLettersOf: String = ""
    var numberOfWrongGuesses = 0
    var phraseLength = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.view.backgroundColor = UIImageView(image: "matrixBackground.jpg")
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
    
    @IBAction func whenGuessIsClicked(sender: AnyObject) {
        if numberOfWrongGuesses != 6 {
            numberOfWrongGuesses += 1
            hangmanImage.image = UIImage(named: hangmanImagesArray[numberOfWrongGuesses])
        }
        updateUILabel()
    }
    
    func initializeUILabel() {
        for char in phraseThatPlayerMustGuessLettersOf.characters {
            if char == " " {
                stringOfCorrectLettersAndUnderscores += "  "
            } else {
                stringOfCorrectLettersAndUnderscores += "- "
            }
        }
    }
    
    func updateUILabel() {
        for char in phraseThatPlayerMustGuessLettersOf.characters {
            if String(char) == guessedLetterFromTextField.text!.lowercaseString {
                stringOfCorrectLettersAndUnderscores += guessedLetterFromTextField.text!
            }
            if char == " " {
                stringOfCorrectLettersAndUnderscores += "  "
            } else {
                stringOfCorrectLettersAndUnderscores += "- "
            }
        }
        displayedPhrase.text = stringOfCorrectLettersAndUnderscores
        print(guessedLetterFromTextField.text)
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
