//
//  HomeView.swift
//  FinanceApp
//
//  Created by Rodrigo Borges on 30/12/21.
//

import UIKit

struct HomeViewConfiguration {
    let homeData: HomeData
}

final class HomeView: UIView {
    private var activities: [Activity] = []

    private lazy var accountSummaryView: AccountSummaryView = {
        let element = AccountSummaryView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ActivityCellView.self, forCellReuseIdentifier: ActivityCellView.reuseIdentifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.dataSource = self
        return tableView
    }()

    init() {
        super.init(frame: .zero)
        self.setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView(with configuration: HomeViewConfiguration) {
        activities = configuration.homeData.activity
        accountSummaryView.updateValues(balance: configuration.homeData.balance,
                                        savings: configuration.homeData.savings,
                                        spending: configuration.homeData.spending)
        tableView.reloadData()
    }
}

private extension HomeView {

    func setupViews() {
        backgroundColor = .white
        configureSubviews()
        configureSubviewsConstraints()
    }

    func configureSubviews() {
        addSubview(accountSummaryView)
        addSubview(tableView)
    }

    func configureSubviewsConstraints() {
        NSLayoutConstraint.activate([
            accountSummaryView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            accountSummaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            accountSummaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: accountSummaryView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension HomeView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ActivityCellView = .createCell(for: tableView, at: indexPath),
              indexPath.row < activities.count else {
            return .init()
        }
        
        
        cell.updateValues(activity: activities[indexPath.row])
        return cell
    }
}

