//
//  MoreInfoViewController.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 5.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit

class MoreInfoViewController: UIViewController {

    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var occupationLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var nickNameLabel: UILabel!
    @IBOutlet private weak var seasonAppearanceLabel: UILabel!
    
    var image = UIImage()
    var name = ""
    var occupation = ""
    var status = ""
    var nickname = ""
    var seasonAppearance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        characterImage.image = image
        nameLabel.text = name
        occupationLabel.text = occupation
        statusLabel.text = status
        nickNameLabel.text = nickname
        seasonAppearanceLabel.text = seasonAppearance
    }
    
    func setupViewController(characterImage: UIImage, characterName: String, characterOccupation: String, characterStatus: String, characterNickname: String, characterAppearance: String) {
        image = characterImage
        name = "Name: \(characterName)"
        occupation = "Occupation: \(characterOccupation)"
        status = "Status: \(characterStatus)"
        nickname = "Nickname: \(characterNickname)"
        seasonAppearance = "Season appearance: \(characterAppearance)"
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
