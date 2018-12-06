//
//  RecordVC.swift
//  pitchPerfect
//
//  Created by Ashish Chatterjee on 11/28/18.
//  Copyright © 2018 Ashish Chatterjee. All rights reserved.
//

import UIKit
import AVFoundation

class RecordVC: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordLabel: UILabel!
    var isRecording : Bool = false
    @IBOutlet weak var recordButton: UIButton!
    @IBAction func recordButton(_ sender: UIButton) {
        record()
        toggleRecording()
    }
    
    @IBOutlet weak var stopButton: UIButton!
    @IBAction func stopButton(_ sender: UIButton) {
        stopRecording()
        toggleRecording()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Pitch Perfect"
    }

    func toggleRecording() {
        isRecording = !isRecording
        recordButton.isEnabled = !isRecording
        stopButton.isEnabled = isRecording
        if isRecording {
            recordLabel.text = "Stop Recording"
        } else {
            recordLabel.text = "Tap to Record"
        }
    }
    
    func record() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recording = "recording.wav"
        let pathArray = [dirPath, recording]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func stopRecording() {
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            showAlert("Successfully recorded your audio!", message: "Let's play it back with some effects!", true)
        } else {
            showAlert("Uh oh!", message: "Seems like there was an error recording your audio.", false)
        }
    }
    
    func goToPlayBack() {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playbackVC = segue.destination as! PlayBackVC
            playbackVC.recordedAudio = sender as! URL
        }
    }
    
    func showAlert(_ title: String, message: String, _ success: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if success {
            alert.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: { (UIAlertAction) in
                self.goToPlayBack()
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

