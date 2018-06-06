//
//  RecordSoundsViewController.swift

//  Pitch Perfect
//
//  Created by Farhan Qazi on 5/22/18.
//  Copyright © 2018 Farhan Qazi. All rights reserved.
//

import UIKit
import AVFoundation // framework = contains the audio recorders and avfoundation class

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    /// Superclass UIViewController, this class is inherting from superclass. A class can conform to many protocols
    //as long they are listed, seperated by commas
    
    var audioRecorder: AVAudioRecorder! // audio recorder property, This property gives the view controller the ability
    // to ,1-Use, 2-Reference, in multiple purpose as the Ref of the recording will be used in 2 differnt spots
    /// Beinging of rec and Stop Rec
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        /// In order to Disable this from the begining
        // as soon as the app loads
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear Called")
    }

    //Refactor methos will go below vvvvvvvvvv
    
    func configureUI(recording enable: Bool, labelString: String)
    {
        recordButton.isEnabled = !enable
        stopRecordingButton.isEnabled = enable
        recordingLabel.text = labelString
    }
    
    
    
    
    //*********end of Refector method********
    
    
    
    @IBAction func recordAudio(_ sender: Any) {
        print("Record Button was pressed")
        
//=============================Refector Method Call==========================
        configureUI(recording: true, labelString: "Recording in progress")
        
//=============================//=============================
        
        
//xxxxxxxxxxxxxxxxxxxxxxxxxxOLD Stuffxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
//        recordingLabel.text = "Recording in Progress"
//        stopRecordingButton.isEnabled = true // ok to rec after stop rec
//        recordButton.isEnabled = false // while recording, rec = disabled
        
 //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        //gets App's document directory an stores this as string .
        let recordingName = "recordedVoice.wav" // This dirpath gets combined with teh file name for the recording
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath)
        
        let session = AVAudioSession.sharedInstance() // session is an instance-class AVAudiosession that is needed
        /// for the recording and playback
        
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self /// adding audioRecorder as a delegate to conform to AVAudioRecorderDelegate
        
        audioRecorder.isMeteringEnabled = true // property = true, prepare to record, record.
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    
    @IBAction func stopRecording(_ sender: Any) {
        
        print("stop recording button was pressed")
 
        
//=============================Refector Method Call==========================

        configureUI(recording: false, labelString: "Tap to Record")
        
//=============================//=============================
        
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxOLD STUFF xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
//        recordButton.isEnabled = true // to make the next recording possible
//        stopRecordingButton.isEnabled = false // while recording has been already stopped now
//        recordingLabel.text = "Tap to Record" // need to show a lable now for next audio rec
        
 //xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        
        audioRecorder.stop() // stop the reocorder
        let audioSession = AVAudioSession.sharedInstance() // set shared avaudiosession = inactive
        try! audioSession.setActive(false)
    } //// One of the functions available in this Delegate. this function will be called to stop recording Segue.
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Sorry! Recording was not successful")
        }
        print("AvAudioRecorder has finished Recording")
        
        
    } // when a segue is called there is function that is triggered, on the existing view controller, to help prepare it for a segue. first we check if this is the segue with the identifier we setup early as stop Recording.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController // because segue.destination is property of UIViewController, but we know it is play sounds view controller we can UPCAST it to a PlaySoundsViewController using a forced UPCAST "as!"
            let recordedAudioURL = sender as! URL //
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

