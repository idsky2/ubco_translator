//
//  EditorView.swift
//  UBCO_Translator
//
//  Created by Bruce Webster on 2/02/22.
//

import SwiftUI

struct EditorView: View {
    @State private var textToTranslate = Translation.placeholderText
    @State private var translatedText = ""
    @State private var toUBCOMode = true
    @FocusState private var editorFocus:Bool
    
    init() {
        UITextView.appearance().backgroundColor = .white.withAlphaComponent(0.2)
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, Color("UBCO_BrandColor")]), startPoint: .top, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
     
                HStack(alignment: .bottom) {
                    Image("UBCO_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 65)
                    VStack {
                        Text("Language Translator")
                            .font(.headline)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Picker(selection: $toUBCOMode, label:Text("oo")) {
                            Text("To UBCO").tag(true)
                            Text("From UBCO").tag(false)
                        }
                        .onChange(of: toUBCOMode, perform: {(value) in
                            if !(translatedText.count==0) {
                                textToTranslate = translatedText
                            }
                        })
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                TextEditor(text: $textToTranslate)
                .onChange(of: textToTranslate) {
                    translatedText = Translation(translateText: $0, intoUBCO: toUBCOMode).text
                }
                .onTapGesture {
                    if(textToTranslate == Translation.placeholderText) {
                        textToTranslate = ""
                    }
                    editorFocus = true
                }
                .focused($editorFocus, equals: true)
                .accessibilityIdentifier("translationTextEditor")
                
                Image(systemName:"arrow.down")
                
                Text(translatedText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityIdentifier("translatedText")

                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            editorFocus = false
                        }
                    }
                }
            }
            .foregroundColor(Color.white)
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditorView()
        }
    }
}
