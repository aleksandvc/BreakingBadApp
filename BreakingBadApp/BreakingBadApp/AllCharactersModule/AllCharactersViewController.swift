//
//  AllCharactersViewController.swift
//  BreakingBadApp
//
//  Created by Sasha Belov on 5.08.20.
//  Copyright © 2020 Alexander Tsvetanov. All rights reserved.
//

import UIKit
import Bondage

class AllCharactersViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterView: FilterView!
    @IBOutlet private weak var charactersTableView: UITableView!
    
    var activityIndicator: UIActivityIndicatorView?
    
    var isSearching = false
    
    var viewModel = AllCharactersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.layer.borderColor = UIColor.white.cgColor
        searchBar.layer.borderWidth = 1
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        filterView.setupView(delegate: self, description: "Show me all characters in season:", inputView: pickerView)
        
        activityIndicator = getActivityIndicator()
        
        viewModel.characters.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.charactersTableView.reloadData()
            }
        }
        
        DispatchQueue.main.async {
            self.activityIndicator?.startAnimating()
        }
        viewModel.getCharacters(presenter: self) {
            DispatchQueue.main.async {
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
    //Showing small loading circle while the request is executing
    private func getActivityIndicator() -> UIActivityIndicatorView {
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
        return indicator
    }
    
    func presentMoreInfoScreen(characterImage: UIImage, characterName: String, characterOccupation: String, characterStatus: String, characterNickname: String, characterAppearance: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let moreInfoVC = storyboard.instantiateViewController(withIdentifier: "MoreInfoViewController") as? MoreInfoViewController else { return }
        moreInfoVC.setupViewController(characterImage: characterImage, characterName: characterName, characterOccupation: characterOccupation, characterStatus: characterStatus, characterNickname: characterNickname, characterAppearance: characterAppearance)
        DispatchQueue.main.async {
            self.present(moreInfoVC, animated: true, completion: nil)
        }
    }
}

extension AllCharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = isSearching ? viewModel.searchedCharacters[indexPath.row] : viewModel.characters.value[indexPath.row]
        var occupation = ""
        var appearance = ""
        for entry in character.occupation {
            occupation = "\(occupation)  \(entry)"
        }
        
        for season in character.appearance {
            appearance = "\(appearance) \(season)"
        }
        
        presentMoreInfoScreen(characterImage: viewModel.images[indexPath.row], characterName: character.name, characterOccupation: occupation, characterStatus: character.status, characterNickname: character.nickname, characterAppearance: appearance)
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
    }
}

extension AllCharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? viewModel.searchedCharacters.count : viewModel.characters.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        let characterName = isSearching ? " \(viewModel.searchedCharacters[indexPath.row].name)" : "\(viewModel.characters.value[indexPath.row].name)"
        if let fontName = cell.textLabel?.font.familyName {
            cell.textLabel?.font = UIFont(name: fontName, size: 15)
        }
        DispatchQueue.main.async {
            cell.textLabel?.text = "\(indexPath.row + 1) \(characterName)"
            cell.imageView?.image = self.viewModel.images[indexPath.row]
        }
    
        return cell
    }
}

extension AllCharactersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        viewModel.searchedCharacters = viewModel.characters.value.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        isSearching = true
        DispatchQueue.main.async {
            self.charactersTableView.reloadData()
        }
    }
}

extension AllCharactersViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension AllCharactersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.seasons.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return viewModel.seasons[row] == 0 ? "No filter" : String(viewModel.seasons[row])
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        isSearching = false
        DispatchQueue.main.async {
            self.searchBar.text = ""
            self.filterView.setTextInTextField(text: String(self.viewModel.seasons[row]))
            self.filterView.resignFirstResponderToTextField()
            self.viewModel.filterCharactersBySeason(season: self.viewModel.seasons[row]) {
                self.charactersTableView.reloadData()
            }
        }
        viewModel.reloadCharacters()
    }
}
