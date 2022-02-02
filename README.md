# UBCO Translator
### Demo app language translator

This is a fun little swift demo exercise with a simple interface to "translate" text from your native language to "UBCO" language.
I set the minimum iOS platform to iOS15 so I could use the latest SwiftUI features, a real-world app would have to consider the userbase (e.g: if you have iPhone 6 users then you need to target iOS12).

#### Specification Assumptions
- This seems like an old-school ASCII function, but we live in a multi-byte unicode world with grapheme clusters
- I made sure the app was unicode safe.  Feel free to put in emojis or chinese characters.
- The spec made no mention of vowels and consonants beyond the 26 letters of the English alphabet so I chose to cleanly pass all other characters through unharmed just like punctuation.  The é in café doesn't double, neither do Māori macrons.  Add any twiddly bits to your consonants and they won't change either.
- What is a "word"?  Is the digit "5" by itself a word?  I let iOS decide, with localisation support.
#### Structural Implementation 
- The **Translation** class does all translation functions and no UI.
    - It privately holds "plainTranslation" without the UBCO affixes to keep things from getting too messy
    - The **translateText** method can translate in either direction
    - The public var **text** gives the translation with the affixes for UBCO text or without them if translating back
    - **textWithoutUBCOAffixes** and **wordCount** are publicly available if needed.  Perhaps the aliens are perfect at typing the wordcount but I wouldn't trust humans, so the UI should probably show the auto-calculated word count outside of the textEditor until editing is done.
- The **EditorView** class does all UI.
    - SwiftUI layout fits content to device with stacks and padding
    - Controls are bound to state variables to trigger UI updates
#### Tests
- **testTranslationModel** in **UBCO_TranslatorTests** asserts that text translates as per spec examples, and back to match original text
- **testTranslationUI** in **UBCO_TranslatorUITests** types out "Hello World" on the device keyboard and asserts that the translated Text displayed on screen matches the expected translation.
#### Bonus
- Being able to translate text for the aliens is one thing, but what if they reply or you want to read up on all their fancy technology?  Rather that wait for the feature request, I added a toggle to translate in reverse.  
- Translating from UBCO can mean dealing with invalid UBCO text.  Rather that give errors if the UBCO affixes are missing or wrong, I allowed them to be optional.

#### What next?
- Improve Keyboard setup and Word Count handling when typing in UBCO
- Store translation history, restore state on new launch.  Normally there would be a ViewModel to push and pull Model data from the view but this simple app doesn't have any of that.
- collect user events
- deploy to the world
- check for any crash reports
- Set up automated cloud test runs e.g. on Bitrise, triggered on push to GitHub repo


##### UBCO Translation Rules from spec:
1. Text always begins with the word ‘UBCO’.
2. All vowels in the original text (a, e, i, o, u) are doubled.
3. All other letters (the consonants) in the original text are shifted by one place to
the next consonant in the alphabet. For example:
    * ‘b' goes to 'c’ 
    * ‘d' goes to 'f’ 
    * ‘z' goes to 'b’
4. Text ends with a number indicating the number of words in the original text.
5. Case is preserved.
6. All other characters (punctuation, whitespace, etc) are unchanged.
