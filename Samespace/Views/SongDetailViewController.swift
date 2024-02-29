//
//  SongDetailViewController.swift
//  Samespace
//
//  Created by Nitesh Malhotra on 26/02/24.
//

import Foundation
import UIKit
import AVFoundation

class SongDetailViewController : UIViewController{
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
       var track: Track?
       var audioPlayer: AVPlayer?
       var timeObserver: Any?
       var currentTrackIndex: Int = 0
       var trackCount : Int = 0 
       var tracks: [Track] = []
       
       
       override func viewDidLoad() {
           super.viewDidLoad()
           self.view.backgroundColor = .black
           addSwipeDownGestureRecognizer()
          trackImage.layer.cornerRadius = 20
          trackImage.clipsToBounds = true
           
           if let track = track {
               trackName.text = track.name
               artistName.text = track.artist
               
               if let coverID = track.cover {
                   let imageURL = Constants.CoverImage.imageURL + coverID
                   if let url = URL(string: imageURL) {
                       URLSession.shared.dataTask(with: url) { (data, response, error) in
                           if let data = data, let image = UIImage(data: data) {
                               DispatchQueue.main.async {
                                   self.trackImage.image = image
                               }
                           }
                       }.resume()
                   }
               } else {
                   trackImage.image = UIImage(named: "placeholder_image")
               }
               let audioURL = track.url
               audioPlayer = AVPlayer(url: audioURL)
               audioPlayer?.play()
               addTimeObserver()
           }
       }
       
       func addTimeObserver() {
           let interval = CMTime(seconds:  0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
           timeObserver = audioPlayer?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
               guard let self = self else { return }
               
               let currentTime = time.seconds
               self.currentTimeLabel.text = self.formatTime(time: currentTime)
               
               if let duration = self.audioPlayer?.currentItem?.duration.seconds {
                   let progress = Float(currentTime / duration)
                   self.progressSlider.value = progress
               }
               
               
               if let duration = self.audioPlayer?.currentItem?.duration.seconds, duration.isFinite {
                   self.durationLabel.text = self.formatTime(time: duration)
               }
           }
       }
       
       @IBAction func playButtonTapped(_ sender: UIButton) {
           if let player = audioPlayer {
                   if player.rate != 0 && player.error == nil {
                       player.pause()
                       sender.isSelected = false
                   } else {
                       player.play()
                       sender.isSelected = true
                   }
                   
                   let playImage = UIImage(systemName: "play.fill")
                   let pauseImage = UIImage(systemName: "pause.fill")
                   sender.setImage(sender.isSelected ? pauseImage : playImage, for: .normal)
               }
       }
       func formatTime(time: TimeInterval) -> String {
           let minutes = Int(time) /  60
           let seconds = Int(time) %  60
           return String(format: "%02d:%02d", minutes, seconds)
       }
       @objc func handleSwipeDownGesture(_ gesture: UISwipeGestureRecognizer) {
             if gesture.state == .ended {
                 print("Swipe down detected, showing mini player.")
             }
         }
       func addSwipeDownGestureRecognizer() {
               let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDownGesture(_:)))
               swipeDownGesture.direction = .down
               self.view.addGestureRecognizer(swipeDownGesture)
           }
       func progressBarValueChanged(_ sender: UISlider) {
           if let player = audioPlayer {
               let duration = player.currentItem?.duration.seconds ??  0.0
               let value = Double(sender.value) * duration
               let seekTime = CMTime(value: Int64(value), timescale:  1)
               
               player.seek(to: seekTime) { [weak self] (finished) in
                   guard let self = self else { return }
                   
                   if finished {
                      
                       let currentTime = player.currentTime().seconds
                       self.currentTimeLabel.text = self.formatTime(time: currentTime)
                   } else {
                       print("Seek operation was not completed successfully.")
                   }
               }
           }
       }

}


