//
//  RepositoriesPresenter.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//

import Foundation
import UIKit

final class RepositoriesPresenter {
    
    //MARK: - Vars
    var repositories: [Repository] = []
    private weak var view: RepositoryView?
    
    //MARK: - Pagination vars
    var repositoriesPerPages = 10
    var limit = 10
    var paginationRepositories: [Repository] = []
    
    //MARK: - Init
    init(_ view: RepositoryView){
        self.view = view
    }
    
    //MARK: - Public Functions
    func getRepositories() {
        APIService.shared.getRepositories { (repositories: [Repository]?, error) in
            guard let repositories = repositories else {
                return
            }
            self.repositories = repositories
            self.limit = self.repositories.count
            
            for i in 0..<10 {
                self.paginationRepositories.append(repositories[i])
            }
            DispatchQueue.main.async {
                self.view?.reloadRepositoriesTableView()
            }
        }
    }
    
    func getCreationDate(for urlString: String?, at indexPath: IndexPath, in tableView: UITableView) {
        guard let urlString = urlString else {
            return
        }
        
        APIService.shared.getCreationDate(for: urlString) { (repository, error) in
            guard let repository = repository else {
                // Handle error
                return
            }
            
            let creationDate = repository.creationDate
            
            // Update the view with the creation date
            DispatchQueue.main.async {
                self.view?.displayCreationDate(creationDate!, at: indexPath,in: tableView)
            }
        }
    }
    
    func repositoriesCount() -> Int {
        return paginationRepositories.count
    }
    
    func getUsedRepository(at row: Int) -> Repository {
        return paginationRepositories[row]
    }
    
    //MARK: - Convert Date
    func formatDate(_ dateString: String) -> String {
        // Define a date formatter with ISO8601 format
        let iso8601DateFormatter = ISO8601DateFormatter()
        
        // Try to parse the date
        if let date = iso8601DateFormatter.date(from: dateString) {
            let currentDate = Date()
            let calendar = Calendar.current
            
            let dateDifference = calendar.dateComponents([.year, .month, .day], from: date, to: currentDate)
            
            if dateDifference.year! >= 2 {
                // If the date is more than 2 years ago, format as "2 years ago"
                let formattedDate = DateFormatter()
                formattedDate.dateFormat = "EEEE, MMM dd, yyyy"
                return formattedDate.string(from: date)
                
            } else if dateDifference.month! >= 6 {
                // If the date is more than 6 months ago, format as "Thursday, Oct 22, 2020"
                return "2 years ago"
                
            } else {
                // Calculate months and years ago
                let monthsAgo = dateDifference.year! * 12 + dateDifference.month!
                if monthsAgo >= 12 {
                    return "\(monthsAgo / 12) years ago"
                } else {
                    return "\(monthsAgo) months ago"
                }
            }
        } else {
            // Date parsing failed
            return "Invalid Date"
        }
    }
    
    func willDisplayRepository(at row: Int){
        if row == paginationRepositories.count - 1 {
            fetchMoreRepositoriesIfNeeded()
        }
    }
}

//MARK: - private funcs
extension RepositoriesPresenter {
    private func fetchMoreRepositoriesIfNeeded() {
        if repositoriesPerPages >= limit {
            return
        }
         else if repositoriesPerPages >= limit - 10 {
            for i in repositoriesPerPages..<limit {
                paginationRepositories.append(repositories[i])
            }
            self.repositoriesPerPages += 10
        }
        else {
            for i in repositoriesPerPages..<repositoriesPerPages + 10 {
                paginationRepositories.append(repositories[i])
            }
            self.repositoriesPerPages += 10
        }
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadRepositoriesTableView()
        }
    }
}
