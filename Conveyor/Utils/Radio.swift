//
//  File.swift
//  Conveyor
//
//  Created by Drew Lanning on 4/22/19.
//  Copyright © 2019 Drew Lanning. All rights reserved.
//

import AVFoundation

struct Radio {
  
  var player: AVAudioPlayer?
  
  init() {
    do {
      try AVAudioSession.sharedInstance().setCategory(.ambient)
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
      print(error)
    }
  }
  
  mutating func playItemComplete() {
    let path = Bundle.main.path(forResource: "slide-paper.aif", ofType: nil)
    let url = URL(fileURLWithPath: path!)
    do {
      player = try AVAudioPlayer(contentsOf: url)
      player?.prepareToPlay()
      player?.play()
    } catch {
      print(error)
    }
  }
  
}
