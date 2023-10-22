//
//  RepositoriesViewController.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//
import UIKit

protocol RepositoryView: AnyObject {
    func reloadRepositoriesTableView()
}

class RepositoriesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    //MARK: - Vars
    private var presenter: RepositoriesPresenter!
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RepositoriesPresenter(self)
        configureTableView()
        presenter.getRepositories()
        self.title = "Repositories"
    }
    
    //MARK: - Configure TableView
    private func configureTableView() {
        repositoriesTableView.delegate = self
        repositoriesTableView.dataSource = self
        repositoriesTableView.register(UINib(nibName: String(describing: RepositoryCell.self), bundle: nil), forCellReuseIdentifier: String(describing: RepositoryCell.self))
    }
    
}

//MARK: - TableView DataSource
extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.returnRepositoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = repositoriesTableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryCell.self), for: indexPath) as? RepositoryCell
        else {
            return UITableViewCell()
        }
        cell.configureCell(with: presenter.getUsedRepository(at: indexPath.row))
        let dateString = cell.creationDateLbl.text
        cell.creationDateLbl.text = presenter.formatDate(dateString ?? "Invalid Date")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter.willDisplayRepository(at: indexPath.row)
    }
}

//MARK: - View Extension
extension RepositoriesViewController: RepositoryView {
    func reloadRepositoriesTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.repositoriesTableView.reloadData()
        }
    }
}
