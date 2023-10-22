//
//  RepositoryCell.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//

import UIKit

class RepositoryCell: UITableViewCell {
    
    @IBOutlet weak var repoImgView: UIImageView!
    @IBOutlet weak var repoOwnerNameLbl: UILabel!
    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var creationDateLbl: UILabel!
    
    //MARK: - Configure Cell
    func configureCell(with repository: Repository) {
        repoNameLbl.text = repository.name
        guard let owner = repository.owner else { return }
        guard let imageURL = owner.avatarURL else { return }
        repoImgView.layer.cornerRadius = repoImgView.frame.size.width / 2
        repoImgView.layer.masksToBounds = true
        repoImgView.load(urlString: imageURL)
        creationDateLbl.text = repository.creationDate
        repoOwnerNameLbl.text = repository.owner?.login
    }
    
    override func prepareForReuse() {
        repoImgView?.image = nil
    }
}

