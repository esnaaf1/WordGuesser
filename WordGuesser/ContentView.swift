//
//  ContentView.swift
//  WordGuesser
//
//  Created by Farshad Esnaashari on 3/19/24.
//
import SwiftUI

struct ContentView: View {
    @State private var word = ""
    @State private var guessedLetters = Array(repeating: " ", count: 5)
    @State private var currentGuess = ""
    @State private var strikes = 0
    @State private var wins = 0
    @State private var losses = 0
    @State private var gameEnded = false
    @State private var playerWon = false
    @State private var isShowingTitle = false
    @State private var isShowingWin = false
    @State private var isShowingLose = false

    @FocusState private var letterInFocus: Bool
    var body: some View {
        
    VStack {
        Text("WORD GUESSER")
            .offset(y: 30)
            .font(.largeTitle)
            .foregroundColor(.blue)
            .scaleEffect(isShowingTitle ? 1 : 0)
        
            .animation(.spring(response: 0.5,
                               dampingFraction: 0.3,
                              blendDuration: 0),
                       value: isShowingTitle)
            .onAppear {
                self.isShowingTitle = true
            }.padding()
        Spacer()
        CircleImage()
            .offset(y: -1)
            .padding(.bottom, -5)

        Text("Strikes: \(strikes)/3")
            .offset(y:-90)
            .font(.title3)
            .foregroundColor(.red)
        Text("Wins: \(wins); Losses: \(losses)")
            .offset(y:-90)
            .font(.title3)
            .foregroundColor(.black)

        ZStack {
            if (playerWon && strikes == 0) {
                Text("Wow! You are an Expert!")
                    .font(.title)
                    .offset(y:-40)
                    .foregroundColor( isShowingWin ? .green: .blue)
                    .scaleEffect(isShowingWin ? 1.2: 1)
                    .rotationEffect(.degrees(isShowingWin ? 360: 0))
                    .animation(.easeInOut(duration: 2), value: isShowingWin)
                    .onAppear{self.isShowingWin = !isShowingWin}
            } else if (playerWon && strikes == 1) {
                Text("Great Job! You Win!")
                    .font(.title)
                    .offset(y:-40)
                    .foregroundColor(.teal)
                    .opacity(isShowingWin ? 1: 0)
                    .animation(.easeIn(duration: 2), value: isShowingWin)
                    .onAppear{self.isShowingWin = !isShowingWin}
            } else if (playerWon && strikes == 2) {
                Text("Phew! You just made it!")
                    .font(.title)
                    .offset(y:-40)
                    .foregroundColor(.purple)
                    .opacity(isShowingWin ? 1: 0)
                    .animation(.easeIn(duration: 2), value: isShowingWin)
                    .onAppear{self.isShowingWin = !isShowingWin}
            } else if (strikes == 3) {
                Text("Sorry, the word is \(word)")
                    .font(.title)
                    .offset(y:-40)
                    .foregroundColor(.red)
                    .scaleEffect(isShowingLose ? 1.2 : 1)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isShowingLose)
                    .onAppear {
                        isShowingLose.toggle()
                    }

            } else {
    
                Text(" ")
                    .font(.title)
                    .offset(y: -50)
                    
                }
            }
        VStack {

            HStack {
                ForEach(0..<5) { index in
                    Text("\(guessedLetters[index])")
                        .frame(width: 60, height: 60)
                        .border(Color.black, width: 3)
                        .font(.title)
                }
            }
            Text("Let's Play").font(.title)
            
            TextField("Enter a letter", text: $currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($letterInFocus)
                .onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.letterInFocus = true
                  }
                }

            
            Button (action: makeGuess) {
             Text("Guess")
                    .foregroundColor(gameEnded ? .secondary : .white)
                    .padding()
                    .background(gameEnded ? Color.secondary: Color.blue)
                    .clipShape(Capsule())
            }.disabled(gameEnded)
    
    

            Button(action: resetGame) {
                Text("Play Again")
                    .foregroundColor(!gameEnded ? .secondary : .white)
                    .padding()
                    .background(!gameEnded ? Color.secondary: Color.blue)
                    .clipShape(Capsule())
            }
            .padding()
            .disabled(!gameEnded)
        }
        .onAppear(perform: resetGame)  // Initialize the game when the view appears
    }
    
}


    func makeGuess() {
        guard currentGuess.count == 1 else { return }
        let upperGuess = currentGuess.uppercased()
        var correctGuess = false

        for (index, letter) in word.enumerated() {
            if String(letter) == upperGuess {
                guessedLetters[index] = upperGuess
                correctGuess = true
            }
        }

        if !correctGuess {
            strikes += 1
            if strikes == 3 {
                gameEnded = true
                losses += 1
            }
        } else {
            checkIfPlayerWon()
        }

        currentGuess = ""
    }

    func checkIfPlayerWon() {
        if guessedLetters.joined() == word {
            playerWon = true
            wins += 1
            gameEnded = true
        }
    }

    func resetGame() {
        word = wordList.randomElement()!.uppercased()  // Randomly select a new word
        
        print(word)  // Print the word to console for debugging
        guessedLetters = Array(repeating: " ", count: 5)
        strikes = 0
        gameEnded = false
        playerWon = false
        isShowingWin = false
        isShowingLose = false
        
    }
}

#Preview {
    ContentView()
}
