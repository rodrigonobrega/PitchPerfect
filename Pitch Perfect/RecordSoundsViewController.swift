//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Rodrigo Nóbrega on 6/14/18.
//  Copyright © 2018 Rodrigo Nóbrega. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: constants
    internal struct RecordSoundsConstants{
        static let AudioFileName = "recordedVoice.wav"
        static let StopRecordingSegue = "stopRecording"
        static let AudioSeparatorName = "/"
    }
    
    // MARK: LabelTexts, use to show status message
    internal struct LabelTexts {
        static let RecordingInProgress = "Recording in progress"
        static let TapToRecord = "Tap to Record..."
    }
    
    // MARK: local properties
    var audioRecorder:AVAudioRecorder!
    
    // MARK: IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    // MARK: View did Load - instance method
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }

    // MARK: IBActions Methods
    @IBAction func recordAudio(_ sender: AnyObject) {
        setupUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = RecordSoundsConstants.AudioFileName
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: RecordSoundsConstants.AudioSeparatorName))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        setupUI()
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Configure UI
    func setupUI(recording: Bool = false) {
        if (recording) {
            recordingLabel.text = LabelTexts.RecordingInProgress
        } else {
            recordingLabel.text = LabelTexts.TapToRecord
        }
        stopRecordingButton.isEnabled = recording
        recordButton.isEnabled = !recording
    }
    
    // MARK: Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: RecordSoundsConstants.StopRecordingSegue, sender: audioRecorder.url)
        }
    }
    
    // MARK: Segue method with url audio in sender parameter
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RecordSoundsConstants.StopRecordingSegue {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}

