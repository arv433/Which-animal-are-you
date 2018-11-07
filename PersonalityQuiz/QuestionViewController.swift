//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Arvin Zojaji on 2018-11-05.
//  Copyright © 2018 Arvin Zojaji. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
    }


    // models
    
    var questionIndex = 0
    var answersChosen: [Answer] = []
    var questions: [Question] = [
        Question(text: "Which food do you like the most?",
                 type: .single,
                 answers: [
                    Answer(text: "Steak", type: .dog),
                    Answer(text: "Corn", type: .turtle),
                    Answer(text: "Carrots", type: .rabbit),
                    Answer(text: "Fish", type: .cat)
            ]),
        Question(text: "Which activities do you enjoy?",
            type: .multiple,
            answers: [
                Answer(text: "Swimming", type: .turtle),
                Answer(text: "Eating", type: .dog),
                Answer(text: "Sleeping", type: .cat),
                Answer(text: "Cuddling", type: .rabbit)
            ]),
        Question(text: "How much do you enjoy car rides?",
                 type: .ranged,
                 answers: [
                    Answer(text: "I dislike them", type: .cat),
                    Answer(text: "I get a little nervous", type: .rabbit),
                    Answer(text: "I barely notice them", type: .turtle),
                    Answer(text: "I love them", type: .dog)
            ]),
        Question(text: "Which school subjects do you enjoy?",
                 type: .multiple,
                 answers: [
                    Answer(text: "Mathematics", type: .cat),
                    Answer(text: "Science", type: .turtle),
                    Answer(text: "Literature", type: .rabbit),
                    Answer(text: "Physical Education", type: .dog)
            ]),
        Question(text: "How much do you enjoy being around friends?",
                 type: .ranged,
                 answers: [
                    Answer(text: "I am antisocial", type: .cat),
                    Answer(text: "I do not really like socialization", type: .rabbit),
                    Answer(text: "I somewhat enjoy other people", type: .turtle),
                    Answer(text: "I love being with others!", type: .dog)
            ]),
        Question(text: "Which is your favorite season?",
                 type: .single,
                 answers: [
                    Answer(text: "Spring", type: .rabbit),
                    Answer(text: "Summer", type: .dog),
                    Answer(text: "Autumn", type: .turtle),
                    Answer(text: "Winter", type: .cat)
            ]),
        Question(text: "Do you tend to take on challenges more creatively or logically?",
                 type: .ranged,
                 answers: [
                    Answer(text: "Very creative", type: .dog),
                    Answer(text: "Somewhat creative", type: .rabbit),
                    Answer(text: "Somewhat logical", type: .turtle),
                    Answer(text: "Very logical", type: .cat)
            ])
    ]

    
    // views
    
    // label outlet for each question
    @IBOutlet weak var questionLabel: UILabel!
    
    // outlets for single question stack
    @IBOutlet weak var singleStackView: UIStackView!
    @IBOutlet weak var singleButton1: UIButton!
    @IBOutlet weak var singleButton2: UIButton!
    @IBOutlet weak var singleButton3: UIButton!
    @IBOutlet weak var singleButton4: UIButton!
    
    // outlets for multiple question stack
    @IBOutlet weak var multipleStackView: UIStackView!
    @IBOutlet weak var multiLabel1: UILabel!
    @IBOutlet weak var multiSwitch1: UISwitch!
    @IBOutlet weak var multiLabel2: UILabel!
    @IBOutlet weak var multiSwitch2: UISwitch!
    @IBOutlet weak var multiLabel3: UILabel!
    @IBOutlet weak var multiSwitch3: UISwitch!
    @IBOutlet weak var multiLabel4: UILabel!
    @IBOutlet weak var multiSwitch4: UISwitch!
    
    // outlets for ranged question stack
    @IBOutlet weak var rangedStackView: UIStackView!
    @IBOutlet weak var rangedSlider: UISlider!
    @IBOutlet weak var rangedLabel1: UILabel!
    @IBOutlet weak var rangedLabel2: UILabel!
    
    // outlet for progress bar
    @IBOutlet weak var questionProgressView: UIProgressView!
    
    
    // controllers
    
    // actions for selecting answers
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        switch sender {
        case singleButton1:
            answersChosen.append(currentAnswers[0])
        case singleButton2:
            answersChosen.append(currentAnswers[1])
        case singleButton3:
            answersChosen.append(currentAnswers[2])
        case singleButton4:
            answersChosen.append(currentAnswers[3])
        default:
            break
        }
        
        nextQuestion()
    }
    
    @IBAction func multipleAnswersButtonPressed() {
        let currentAnswers = questions[questionIndex].answers
        
        if multiSwitch1.isOn {
            answersChosen.append(currentAnswers[0])
        }
        
        if multiSwitch2.isOn {
            answersChosen.append(currentAnswers[1])
        }
        
        if multiSwitch3.isOn {
            answersChosen.append(currentAnswers[2])
        }
        
        if multiSwitch4.isOn {
            answersChosen.append(currentAnswers[3])
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let currentAnswers = questions[questionIndex].answers

        let index = Int(round(rangedSlider.value * Float(currentAnswers.count - 1)))
        
        answersChosen.append(currentAnswers[index])
        
        nextQuestion()
    }


    func updateUI() {
        func updateSingleStack(using answers: [Answer]) {
            singleStackView.isHidden = false
            singleButton1.setTitle(answers[0].text, for: .normal)
            singleButton2.setTitle(answers[1].text, for: .normal)
            singleButton3.setTitle(answers[2].text, for: .normal)
            singleButton4.setTitle(answers[3].text, for: .normal)
        }
        
        func updateMultipleStack(using answers: [Answer]) {
            multipleStackView.isHidden = false
            multiSwitch1.isOn = false
            multiSwitch2.isOn = false
            multiSwitch3.isOn = false
            multiSwitch4.isOn = false
            multiLabel1.text = answers[0].text
            multiLabel2.text = answers[1].text
            multiLabel3.text = answers[2].text
            multiLabel4.text = answers[3].text
        }
        
        func updateRangedStack(using answers: [Answer]) {
            rangedStackView.isHidden = false
            rangedSlider.setValue(0.5, animated: false)
            rangedLabel1.text = answers.first?.text
            rangedLabel2.text = answers.last?.text
        }
        
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        let currentQuestion = questions[questionIndex]
        let currentAnswers = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswers)
        case .multiple:
            updateMultipleStack(using: currentAnswers)
        case .ranged:
            updateRangedStack(using: currentAnswers)
        }
        
    }
    
    func nextQuestion() {
        questionIndex += 1
        
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "resultsSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "resultsSegue" {
            let resultsViewController = segue.destination as! ResultsViewController
            resultsViewController.responses = answersChosen
        }
    }

    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

