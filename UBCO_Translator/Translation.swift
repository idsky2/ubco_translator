//
//  Translator.swift
//  UBCO_Translator
//
//  Created by Bruce Webster on 2/02/22.
//

import Foundation

public class Translation: NSObject {
    static let vowels = "aeiou"
    static let consonants = "bcdfghjklmnpqrstvwxyz"
    static let ubcoPrefix = "UBCO "
    static let placeholderText = "Enter your text to translate"
    public var isUBCO = false
    
    private var plainTranslation = ""
    
    init(translateText: String, intoUBCO:Bool = true) {
        isUBCO = intoUBCO
        plainTranslation = intoUBCO ?
            Translation.translateToUBCO(translateText: translateText) :
            Translation.translateFromUBCO(translateText: translateText)
    }
    
    var textWithoutUBCOAffixes : String {
        return plainTranslation
    }
    
    public var text : String {
        return (isUBCO && (plainTranslation.count != 0)) ? textWithUBCOAffixes : textWithoutUBCOAffixes
    }
    
    var wordCount : Int {
        return Translation.countWords(translateText: plainTranslation)
    }
    
    private var textWithUBCOAffixes : String {
        return Translation.ubcoPrefix + plainTranslation + String(wordCount)
    }
    
    static private func translateToUBCO(translateText: String) -> String {
        var output = ""
        translateText.forEach { char in
            if Translation.vowels.contains(char.lowercased()) {
                output += String(char) + String(char)
            } else {
                output += modifyConsonantOrLeaveUnchanged(char: char)
            }
        }
        return output
    }
    
    static private func translateFromUBCO(translateText: String) -> String {
        // Remove UBCO Affixes if they are there before translating back
        var cleanInputText = translateText
        if cleanInputText.hasPrefix(Translation.ubcoPrefix) {
            let index = cleanInputText.index(cleanInputText.startIndex, offsetBy: Translation.ubcoPrefix.count)
            cleanInputText = String(cleanInputText[index...])
        }
        let wordCount = Translation.countWords(translateText: cleanInputText)
        
        // There is some ambiguity as to whether trailing digits are a "word" or an UBCO suffix or a mix of both.
        if cleanInputText.hasSuffix(String(wordCount)) {
            cleanInputText = Translation.removeSuffix(cleanInputText, suffix: String(wordCount))
        } else if (wordCount>0 && cleanInputText.hasSuffix(String(wordCount - 1))) {
            cleanInputText = Translation.removeSuffix(cleanInputText, suffix: String(wordCount - 1))
        }
        
        var output = ""
        var previousDuplicateVowel = ""
        cleanInputText.forEach { char in
            if Translation.vowels.contains(char.lowercased()) {
                if previousDuplicateVowel == String(char) {
                    previousDuplicateVowel = ""
                } else {
                    output += String(char)
                    previousDuplicateVowel = String(char)
                }
            } else {
                output += modifyConsonantOrLeaveUnchanged(char: char, increment: false)
                previousDuplicateVowel = ""
            }
        }
        return output
    }
    
    static private func removeSuffix(_ inputText: String, suffix: String) -> String {
        let index = inputText.index(inputText.endIndex, offsetBy: -suffix.count)
        return String(inputText[..<index])
    }
    
    static private func countWords(translateText: String) -> Int {
        var count = 0
        let range = translateText.startIndex..<translateText.endIndex
        translateText.enumerateSubstrings(in: range, options: [.byWords, .substringNotRequired, .localized], { _, _, _, _ -> () in
            count += 1
        })
        return count
    }
    
    static private func modifyConsonantOrLeaveUnchanged(char:String.Element, increment:Bool = true) -> String {
        let lowerChar = char.lowercased()
        
        let consonants = Translation.consonants
        if let inConsonantRange: Range<String.Index> = consonants.range(of: lowerChar) {
            var charPosition: Int = consonants.distance(from: consonants.startIndex, to: inConsonantRange.lowerBound)
            if(increment) {
                if charPosition == consonants.count - 1 {charPosition = 0} else {charPosition += 1}
            } else {
                if charPosition == 0 {charPosition = consonants.count - 1} else {charPosition -= 1}
            }
            let consonantIndex = consonants.index(consonants.startIndex, offsetBy: charPosition)
            let output = String(consonants[consonantIndex...consonantIndex])
            return char.isLowercase ? output : output.uppercased()
        }
        return String(char)
    }
}
