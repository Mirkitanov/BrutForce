//
//  BruteForceOperation.swift
//  Navigation
//
//  Created by Админ on 25.11.2021.
//  Copyright © 2021 Artem Novichkov. All rights reserved.
//

import Foundation
import UIKit

class BruteForceOperation: Operation {
    let passField: UITextField
    let spinner: UIActivityIndicatorView
    var generatePasswordString: String = ""
    var bruteForceTextString: String = ""
    
    init(passField: UITextField, spinner: UIActivityIndicatorView) {
        self.passField = passField
        self.spinner = spinner
    }
    
    override func main() {
        generatePasswordString = generatePass()
        bruteForce(passwordToUnlock: generatePasswordString)
    }
    
    func generatePass() -> String {
        let array: [String] = String().printable.map { String($0) }
        
        var str: String = ""
        
        while str.count < 3 {
            str.append(characterAt(index: Int.random(in: 0..<array.count), array))
        }
        
        return str
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
        }
        
        self.bruteForceTextString = password
        
        DispatchQueue.main.async {
            self.passField.isSecureTextEntry = false
            self.passField.text = password
            self.spinner.stopAnimating()
        }
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        print(str)
        
        return str
        
    }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
                                   : Character("")
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters}

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}
