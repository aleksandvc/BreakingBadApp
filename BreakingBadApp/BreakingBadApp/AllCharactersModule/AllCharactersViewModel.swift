//
//  AllCharactersViewModel.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 5.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import Foundation
import Bondage
import SDWebImage

class AllCharactersViewModel {
    var characters = BindableArray<Character>([])
    var allCharacters: [Character] = []
    var searchedCharacters: [Character] = []
    let seasons = [0,1,2,3,4,5]
    var images: [UIImage] = []
    
    let networkManager = NetworkManager()
    
    func reloadCharacters() {
        characters.value = allCharacters
    }
    
    func filterCharactersBySeason(season: Int, completion: ()->()) {
        if season == 0 {
            reloadCharacters()
        } else {
            characters.value = characters.value.filter({(character) in character.appearance.contains(season)})
        }
        completion()
    }
    
    func getCharacters(presenter: UIViewController, completion:@escaping (() -> ())) {
        networkManager.getAllCharacters(presenter: presenter, completion: { [weak self] characters in
            guard let strongSelf = self, let characters = characters else { return }
            for character in characters {
                SDWebImageManager.shared.loadImage(with: URL(string: character.image), options: .allowInvalidSSLCertificates, context: nil, progress: nil, completed: { image, _, error, _, _, _ in
                    if let _ = error {
                        return
                    }
                    guard let img = image else { return }
                    strongSelf.images.append(img)
                    strongSelf.characters.value.append(character)
                    strongSelf.allCharacters.append(character)
                })
            }
            completion()
        })
    }
}
