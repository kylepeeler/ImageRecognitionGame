//
//  GameResult.swift
//  ImageRecognitionGame
//
//  Created by Kyle Peeler on 4/25/18.
//  Copyright © 2018 Kyle Peeler. All rights reserved.
//

import UIKit

class GameResult: UIViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationItem.setHidesBackButton(true, animated: false);
    }
}
