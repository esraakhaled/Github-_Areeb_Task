//
//  RepositoriesViewController.swift
//  Github Repo
//
//  Created by Esraa Khaled   on 21/10/2023.
//
import UIKit

protocol RepositoryView: AnyObject {
    func reloadRepositoriesTableView()
    func displayCreationDate(_ date: String, at indexPath: IndexPath, in tableView: UITableView)
}

class RepositoriesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    //MARK: - Vars
    private var presenter: RepositoriesPresenter!
    var isLoading = false
    
    //MARK: - Constants
    let loader = UIActivityIndicatorView(style: .large)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Repositories"
        setupLoader()
        presenter = RepositoriesPresenter(self)
        configureTableView()
        presenter.getRepositories()
    }
    
    //MARK: - Set Loader Function
    func setupLoader() {
        loader.color = .blue
        
        let backgroundView = UIView(frame: self.repositoriesTableView.bounds)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.addSubview(loader)
        
        loader.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXConstraint = loader.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor)
        let centerYConstraint = loader.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        
        NSLayoutConstraint.activate([centerXConstraint, centerYConstraint])
        self.repositoriesTableView.backgroundView = backgroundView
        
        loader.startAnimating()
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
        presenter.repositoriesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = repositoriesTableView.dequeueReusableCell(withIdentifier: String(describing: RepositoryCell.self), for: indexPath) as? RepositoryCell
        else {
            return UITableViewCell()
        }
        cell.configureCell(with: presenter.getUsedRepository(at: indexPath.row))
        let repository = presenter.getUsedRepository(at: indexPath.row)
        let urlString = repository.url
        
        presenter.getCreationDate(for: urlString, at: indexPath, in: tableView)
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
    func displayCreationDate(_ date: String, at indexPath: IndexPath, in tableView: UITableView) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RepositoryCell else {
            return
        }
        
        cell.creationDateLbl.text = presenter.formatDate(date)
    }
    
    func reloadRepositoriesTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.repositoriesTableView.reloadData()
            self?.loader.stopAnimating()
        }
    }
}
