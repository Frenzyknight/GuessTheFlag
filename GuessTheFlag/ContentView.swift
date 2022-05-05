//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Gaurav Ganju on 12/02/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var noOfQuestions = 0
    @State private var showingEnd = false
    
    @State private var selectedFlag = -1
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.5), location: 0.3),
                .init(color: Color(red: 0.75, green: 0.1, blue: 0.2) , location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.primary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            noOfQuestions += 1
                            if noOfQuestions == 8 || countries.count <= 3 {
                                showingEnd = true
                            }
                            if scoreTitle == "Correct Answer" {
                                score += 1
                            }
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0),
                                                  axis: (x: 0, y:1, z:0))
                                .opacity((selectedFlag == number || selectedFlag == -1) ? 1 : 0.25)
                                .animation(.default, value: selectedFlag )
                                .scaleEffect((selectedFlag == number || selectedFlag == -1) ? 1 : 0.75)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Final Score: \(score)", isPresented: $showingEnd) {
            Button("Reset Game", action: resetGame)
        } message: {
            Text("Click below to start again !!!")
        }
        
    }
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct Answer"
        } else {
            scoreTitle = "Wrong Answer. \n This is the flag of \(countries[number])"
        }
        if noOfQuestions == 0 {
            showingScore = false
        }
        else {
            showingScore = true
        }
        countries.remove(at: number)
    }
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    func resetGame() {
        countries = ["Estonia", "France", "Germany", "Ireland", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
        askQuestion()
        score = 0
        noOfQuestions = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
