//
//  WonGameResult.swift
//  ImageRecognitionGame
//
//  Created by Kyle Peeler on 4/25/18.
//  Copyright © 2018 Kyle Peeler. All rights reserved.
//

import UIKit
import SAConfettiView

class WonGameResult: GameResult{

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.isUserInteractionEnabled = false
        self.view.addSubview(confettiView);
        confettiView.startConfetti();
    }
}
