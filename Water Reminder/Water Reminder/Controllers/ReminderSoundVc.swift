import UIKit
import AVFoundation

class ReminderSoundVc: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let defaultSound = ("Default", nil as String?)
    let customSounds: [(String, String?)] = [
        ("Comedic Silence", "comedic-silence-90574.caf"),
        ("Pianos", "pianos-by-174717.caf"),
        ("Busy Cafe", "busy-cafe-27972.caf"),
        ("Sound 4", "034774_sound.caf"),
        ("Sound 5", "039854_16.aiff")
    ]
    
    var selectedSoundFile: String? {
        didSet {
            UserDefaults.standard.set(selectedSoundFile, forKey: "selectedSound")
        }
    }
    
    private var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        selectedSoundFile = UserDefaults.standard.string(forKey: "selectedSound")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Default + Custom
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : customSounds.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : "Custom Sounds"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SoundCell", for: indexPath)
    
        var config = cell.defaultContentConfiguration()
        
        if indexPath.section == 0 {
            config.text = defaultSound.0
            if selectedSoundFile == nil {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else {
            let sound = customSounds[indexPath.row]
            config.text = sound.0
            if sound.1 == selectedSoundFile {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            selectedSoundFile = nil
        } else {
            let sound = customSounds[indexPath.row]
            selectedSoundFile = sound.1
            if let fileName = sound.1 {
                playPreview(fileName: fileName)
            }
        }
        tableView.reloadData()
    }
    
    private func playPreview(fileName: String) {
        stopPreview()
        let ns = fileName as NSString
        let name = ns.deletingPathExtension
        let ext = ns.pathExtension
        
        if let url = Bundle.main.url(forResource: name, withExtension: ext) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
    
    private func stopPreview() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    
    @IBAction func btnExit(_ sender: Any) {
        dismiss(animated: true)
    }
}


class SoundCell :UITableViewCell {
    
    
    @IBOutlet weak var uiVIew: UIView!
    
    @IBOutlet weak var soundNames: UILabel!
    
}
