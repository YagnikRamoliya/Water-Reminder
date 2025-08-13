import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    private let feedbackTextView = UITextView()
    private let placeholderLabel = UILabel()
    private let submitButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        // Label
        let titleLabel = UILabel()
        titleLabel.text = "We value your feedback"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        
        // TextView
        feedbackTextView.font = UIFont.systemFont(ofSize: 16)
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.borderColor = UIColor.systemGray4.cgColor
        feedbackTextView.layer.cornerRadius = 8
        feedbackTextView.delegate = self
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(feedbackTextView)
        
        // Placeholder Label for TextView
        placeholderLabel.text = "Write your feedback here..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: 16)
        placeholderLabel.textColor = .systemGray3
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        feedbackTextView.addSubview(placeholderLabel)
        
        // Submit Button
        submitButton.setTitle("Submit Feedback", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(submitButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            feedbackTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            feedbackTextView.heightAnchor.constraint(equalToConstant: 200),
            
            placeholderLabel.topAnchor.constraint(equalTo: feedbackTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: feedbackTextView.leadingAnchor, constant: 5),
            
            submitButton.topAnchor.constraint(equalTo: feedbackTextView.bottomAnchor, constant: 40),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // UITextViewDelegate method to hide/show placeholder
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @objc private func submitTapped() {
        let feedback = feedbackTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !feedback.isEmpty else {
            let alert = UIAlertController(title: "Please enter feedback", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // Handle feedback submission here
        // For example: send to server, save locally, etc.
        
        let alert = UIAlertController(title: "Thank you!", message: "Your feedback has been submitted.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.feedbackTextView.text = ""
            self.placeholderLabel.isHidden = false
        })
        present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true)
    }
}
