//
//  RatingViewController.swift
//  Water Reminder
//
//  Created by iMac on 12/08/25.
//

import Foundation
import UIKit
import StoreKit

class RatingViewController: UIViewController {
    
    private var selectedRating = 0
    private let stackView = UIStackView()
    private var starButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        // Label
        let label = UILabel()
        label.text = "How do you like our app?"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        // Stars StackView
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        // Create 5 star buttons
        for i in 1...5 {
            let button = UIButton(type: .system)
            button.tag = i
            button.setTitle("☆", for: .normal) // empty star
            button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
            button.tintColor = .systemYellow
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        // Submit Button
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit Rating", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(submitButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 250),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        selectedRating = sender.tag
        updateStars()
    }
    
    private func updateStars() {
        for button in starButtons {
            button.setTitle(button.tag <= selectedRating ? "★" : "☆", for: .normal)
        }
    }
    
    @objc private func submitTapped() {
        guard selectedRating > 0 else {
            let alert = UIAlertController(title: "Please select rating", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Option 1: Show thank you alert
        let alert = UIAlertController(title: "Thank you!", message: "You rated us \(selectedRating) star(s).", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            // Optionally open App Store review page here
            self.requestAppStoreReview()
        })
        present(alert, animated: true)
    }
    
    private func requestAppStoreReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}
