//
//  PasswordGenerator.swift
//  VTComponents
//
//  Created by arun-13757 on 22/09/22.
//

import Foundation

extension String {
    subscript(_ index: Int) -> Character {
        let stringIndex = self.index(startIndex, offsetBy: index)
        return self[stringIndex]
    }
}

/// Generates random password based on a given `PasswordPolicy`
public class PasswordGenerator {
    
    private static let lowerCaseLetters = "abcdefghijklmnopqrstuvwxyz"
    private static let upperCaseLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    private static let numerals = "0123456789"
    private static let specialCharacters = "~!@#$%^&*()-+,.:;<=>?[]_{|}"
    private static let adjacentSpecialCharacters = "~!@#$%^&*()-="
    
    /// Returns a random password generated based on the given `PasswordPolicy`
    /// - Parameters:
    ///   - passwordPolicy: The policy which the password should constraint to.
    ///   - tolerant: `true` if the password constraint is tolerable.
    /// - Throws: `PasswordPolicyError.invalidPolicy` if the given `PasswordPolicy` is invalid.
    public class func generatePassword(passwordPolicy: PasswordPolicy, tolerant: Bool = true) throws -> String {
        // constructing minimum length required to build the password
        var minLength = 0
        
        if passwordPolicy.mixedCaseNeeded {
            minLength = 2
        } else if passwordPolicy.startWithLetter {
            minLength = 1
        }
        
        if passwordPolicy.numeralsNeeded {
            minLength += 1
        }
        
        if passwordPolicy.specialCharactersNeeded {
            minLength += passwordPolicy.specialCharactersCount
        }
        
        var passwordMinLength = passwordPolicy.minLength
        if passwordPolicy.minLength < minLength {
            passwordMinLength = minLength
        }
        
        let passwordLength: Int
        // if given maxLength is less than required minLength, if user can tolerate changes, we can use minLength itself
        if passwordMinLength > passwordPolicy.maxLength {
            if tolerant {
                passwordLength = passwordMinLength
            } else {
                throw PasswordPolicy.PasswordPolicyError.invalidPolicy("Cannot determine password length based on given password policy")
            }
        } else {
            // if no issues with minLength, we can use any random character between minLength and maxLength
            passwordLength = Int.random(in: passwordMinLength..<passwordPolicy.maxLength)
        }
        // assigning default values to use while building password string against the given constraints in policy
        var lowerCaseAdded = false, upperCaseAdded = false, mixedCaseAdded = !passwordPolicy.mixedCaseNeeded, numeralsAdded = !passwordPolicy.numeralsNeeded, totalSpclCharsAdded = 0
        
        var password = ""
        
        var currentCharacter: Character
        var currentCharacterType: CharacterType
        
        for i in 0...passwordLength {
            // for first index
            if i == 0 {
                if passwordPolicy.startWithLetter {
                    currentCharacterType = .letter
                } else {
                    currentCharacterType = getRandomCharacterType(withNumerals: passwordPolicy.numeralsNeeded, withSpclChars: passwordPolicy.specialCharactersNeeded)
                }
                // if numeral is needed and not added
            } else if passwordPolicy.numeralsNeeded && !numeralsAdded {
                currentCharacterType = .numeral
                // if mixed case is needed and not added
            } else if passwordPolicy.mixedCaseNeeded && !mixedCaseAdded {
                currentCharacterType = .letter
                // is specialCharacters needed
            } else if passwordPolicy.specialCharactersNeeded {
                // if required number of special characters are not yet added
                if totalSpclCharsAdded < passwordPolicy.specialCharactersCount {
                    // if remaining characters in password count is not same as count of remaining special characters to be added (i,e) if remaining all characters are not required to be special character
                    if (passwordLength - i) != (passwordPolicy.specialCharactersCount - totalSpclCharsAdded) {
                        currentCharacterType = getRandomCharacterType(withNumerals: passwordPolicy.numeralsNeeded, withSpclChars: passwordPolicy.specialCharactersNeeded)
                    } else {
                        currentCharacterType = .specialCharacter
                    }
                    // without special characters
                } else {
                    currentCharacterType = getRandomCharacterType(withNumerals: passwordPolicy.numeralsNeeded, withSpclChars: false)
                }
                // all requirements are fulfilled and password can be any type
            } else {
                currentCharacterType = getRandomCharacterType(withNumerals: passwordPolicy.numeralsNeeded, withSpclChars: passwordPolicy.specialCharactersNeeded)
            }
            
            switch currentCharacterType {
            case .numeral:
                // getting a random number as a character
                let currentNumberIndex = Int.random(in: 0..<numerals.count)
                currentCharacter = numerals[currentNumberIndex]
                // if current generated character is same/adjacent as last added character
                if isLastCharacterSame(as: currentCharacter, forString: password) {
                    // replacing it with another character, (3 is a random value forward or backward)
                    if (currentNumberIndex - 3) >= 0 {
                        currentCharacter = numerals[currentNumberIndex - 3]
                    } else if (currentNumberIndex + 3) < numerals.count {
                        currentCharacter = numerals[currentNumberIndex + 3]
                    }
                }
                password.append(currentCharacter)
                numeralsAdded = true
                
            case .specialCharacter:
                // fetching a random special character
                let currentSpclCharIndex = Int.random(in: 0..<specialCharacters.count)
                currentCharacter = specialCharacters[currentSpclCharIndex]
                // if current generated character is same/adjacent as last added character
                if isLastCharacterSame(as: currentCharacter, forString: password) {
                    // replacing it with another character, (3 is a random value forward or backward)
                    if (currentSpclCharIndex - 3) >= 0 {
                        currentCharacter = specialCharacters[currentSpclCharIndex - 3]
                    } else if (currentSpclCharIndex + 3) < specialCharacters.count {
                        currentCharacter = specialCharacters[currentSpclCharIndex + 3]
                    }
                }
                password.append(currentCharacter)
                totalSpclCharsAdded += 1
                
            case .letter:
                // fetching a random letter
                let currentLetterIndex = Int.random(in: 0..<26)
                
                if passwordPolicy.mixedCaseNeeded {
                    // 0 means lower case and 1 means upper case
                    var randomCase = Int.random(in: 0...1)
                    // if lower case is already added and upper case is not, change randomCase as lower case
                    if (randomCase == 0) && lowerCaseAdded && !upperCaseAdded {
                        randomCase = 1
                    } else if randomCase == 1 && upperCaseAdded && !lowerCaseAdded {
                        randomCase = 0
                    }
                    // for upper case
                    if randomCase != 0 {
                        currentCharacter = upperCaseLetters[currentLetterIndex]
                        // if current generated character is same/adjacent as last added character
                        if isLastCharacterSame(as: currentCharacter, forString: password) {
                            // replacing it with another character, (3 is a random value forward or backward)
                            if (currentLetterIndex - 3) >= 0 {
                                currentCharacter = upperCaseLetters[currentLetterIndex - 3]
                            } else if (currentLetterIndex + 3) <= upperCaseLetters.count {
                                currentCharacter = upperCaseLetters[currentLetterIndex + 3]
                            }
                        }
                        upperCaseAdded = true
                        // for lower case
                    } else {
                        currentCharacter = lowerCaseLetters[currentLetterIndex]
                        // if current generated character is same/adjacent as last added character
                        if isLastCharacterSame(as: currentCharacter, forString: password) {
                            // replacing it with another character, (3 is a random value forward or backward)
                            if (currentLetterIndex - 3) >= 0 {
                                currentCharacter = lowerCaseLetters[currentLetterIndex - 3]
                            } else if (currentLetterIndex + 3) <= lowerCaseLetters.count {
                                currentCharacter = lowerCaseLetters[currentLetterIndex + 3]
                            }
                        }
                        lowerCaseAdded = true
                    }
                    mixedCaseAdded = lowerCaseAdded && upperCaseAdded
                } else {
                    // if not mixedCase, we add lower case
                    currentCharacter = lowerCaseLetters[currentLetterIndex]
                    // if current generated character is same/adjacent as last added character
                    if isLastCharacterSame(as: currentCharacter, forString: password) {
                        // replacing it with another character, (3 is a random value forward or backward)
                        if (currentLetterIndex - 3) >= 0 {
                            currentCharacter = lowerCaseLetters[currentLetterIndex - 3]
                        } else if (currentLetterIndex + 3) <= lowerCaseLetters.count {
                            currentCharacter = lowerCaseLetters[currentLetterIndex + 3]
                        }
                    }
                }
                password.append(currentCharacter)
                
            default:
                break
            }
        }
        
        return password
    }
    
    private static func isSameOrAdjacent(_ firstChar: Character, _ secondChar: Character) -> Bool {
        guard firstChar != secondChar else { return true }
        
        
        // letter
        if let firstCharLower = Character(firstChar.lowercased()).asciiValue,
           let secondCharLower = Character(secondChar.lowercased()).asciiValue {
            return ((firstCharLower + 1) == secondCharLower) || ((secondCharLower + 1) == firstCharLower)
        }
        
        // number
        if firstChar.isNumber, secondChar.isNumber, let firstCharAscii = firstChar.asciiValue, let secondCharAscii = secondChar.asciiValue {
            return ((firstCharAscii + 1) == secondCharAscii) || ((secondCharAscii + 1) == firstCharAscii)
        }
        
        // special character
        if let firstSplCharIndex = adjacentSpecialCharacters.firstIndex(of: firstChar),
           let secondSplCharIndex = adjacentSpecialCharacters.firstIndex(of: secondChar) {
            return ((adjacentSpecialCharacters.index(after: firstSplCharIndex) == secondSplCharIndex) ||
                    (adjacentSpecialCharacters.index(after: secondSplCharIndex) == firstSplCharIndex))
        }
        
        return false
    }
    
    private static func getRandomCharacterType(withNumerals: Bool = true, withSpclChars: Bool = true) -> CharacterType {
        if withNumerals && withSpclChars {
            switch Int.random(in: 0..<3) {
            case 0:
                return .letter
            case 1:
                return .numeral
            case 2:
                return .specialCharacter
            default:
                break
            }
        } else if withNumerals {
            switch Int.random(in: 0..<2) {
            case 0:
                return .letter
            case 1:
                return .numeral
            default:
                break
            }
        } else if withSpclChars {
            switch Int.random(in: 0..<2) {
            case 0:
                return .letter
            case 1:
                return .specialCharacter
            default:
                break
            }
        }
        return .letter
    }
    
    private static func isLastCharacterSame(as character: Character, forString password: String) -> Bool {
        return (password.count >= 1) && isSameOrAdjacent(password[password.count - 1], character)
    }
}

enum CharacterType {
    case letter
    case numeral
    case specialCharacter
}

public class PasswordPolicy {
    public let minLength: Int
    public let maxLength: Int
    public let startWithLetter: Bool
    public let mixedCaseNeeded: Bool
    public let numeralsNeeded: Bool
    public let specialCharactersNeeded: Bool
    public let specialCharactersCount: Int
    
    public init(minLength: Int, maxLength: Int, startWithLetter: Bool = true, mixedCaseNeeded: Bool = true, numeralsNeeded: Bool = true, specialCharactersNeeded: Bool = true, specialCharactersCount: Int = 1, tolerant: Bool = true) throws {
        self.minLength = minLength
        self.maxLength = maxLength
        self.startWithLetter = startWithLetter
        self.mixedCaseNeeded = mixedCaseNeeded
        self.numeralsNeeded = numeralsNeeded
        self.specialCharactersNeeded = specialCharactersNeeded
        
        if specialCharactersNeeded && (specialCharactersCount < 1) {
            if tolerant {
                self.specialCharactersCount = 1
            } else {
                throw PasswordPolicyError.invalidPolicy("Special characters count must be 1 or more if special characters needed")
            }
        } else {
            self.specialCharactersCount = specialCharactersCount
        }
    }
    
    public enum PasswordPolicyError: Error {
        case invalidPolicy(String)
    }
}
