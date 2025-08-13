import UIKit

class GenderViewController: UIViewController {
    
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    private var selectedGender: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedGender = UserDefaults.standard.string(forKey: "SelectedGender") {
               selectedGender = savedGender
               goToNextScreen()
               return
           }
        setupGestureRecognizers()
        resetSelectionUI()
        uiDesign()
    }
    
    func uiDesign(){
        maleView.layer.cornerRadius = maleView.frame.width/2
        femaleView.layer.cornerRadius = femaleView.frame.width/2
        btnNext.layer.cornerRadius = 12
        
       
        
    }
    
    private func setupGestureRecognizers() {
        let maleTap = UITapGestureRecognizer(target: self, action: #selector(maleTapped))
        maleView.addGestureRecognizer(maleTap)
        maleView.isUserInteractionEnabled = true
        
        let femaleTap = UITapGestureRecognizer(target: self, action: #selector(femaleTapped))
        femaleView.addGestureRecognizer(femaleTap)
        femaleView.isUserInteractionEnabled = true
    }
    
    private func resetSelectionUI() {
        // Default gray background
        maleView.backgroundColor = UIColor.lightGray
        femaleView.backgroundColor = UIColor.lightGray
    }
    
    // MARK: - Gender Selection
    @objc private func maleTapped() {
        selectedGender = "Male"
        updateSelectionUI()
    }
    
    @objc private func femaleTapped() {
        selectedGender = "Female"
        updateSelectionUI()
    }
    
    private func updateSelectionUI() {
        resetSelectionUI()
        
        if selectedGender == "Male" {
            maleView.backgroundColor = .systemBlue
            genderLabel.text = "Male"
        } else if selectedGender == "Female" {
            femaleView.backgroundColor = .systemPink
            genderLabel.text = "Female"
        }
    }

    // MARK: - Button Action
       @IBAction func nextButtonTapped(_ sender: UIButton) {
           guard let gender = selectedGender else {
               showAlert(message: "Please select a gender before continuing.")
               return
           }

           // Save selection so we don't show this screen again
           UserDefaults.standard.set(gender, forKey: "SelectedGender")
           
           goToNextScreen()
       }
    private func showAlert(message: String) {
          let alert = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true)
      }
    
    private func goToNextScreen() {
        guard let selectedGender = selectedGender else {
            print("Gender is nil!")
            return
        }

        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeightViewController") as! WeightViewController
        vc.selectedGender = selectedGender
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    
    
    
}
