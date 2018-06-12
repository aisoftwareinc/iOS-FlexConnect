//
//  OrderViewController.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/12/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

protocol OrderControllerProtocol: class {
    func didTapOrder(_ order: Delivery)
    func checkForNewDeliveries(for orderController: OrderViewController)
    func updateDeliveries() -> [Delivery]
    func logOut()
}

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var orders = [Delivery]()
    let refreshControl = UIRefreshControl.init()
    
    //Delegate callback for AppCoordinator
    weak var delegate: OrderControllerProtocol?
    
    init(_ orders: [Delivery]) {
        self.orders = orders
        super.init(nibName: nil, bundle: nil)
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib.init(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        self.tableView.register(UINib.init(nibName: "AppDescriptionCell", bundle: nil), forCellReuseIdentifier: "AppDescriptionCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
        
        //Register pull to refresh
        self.refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString.init(string: "Checking for new deliveries...")
        self.tableView.addSubview(self.refreshControl)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Log Out", style: .plain, target: self, action: #selector(self.logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.orders = self.delegate!.updateDeliveries()
        self.tableView.reloadData()
    }
    
    @objc
    func pullToRefresh() {
        self.delegate?.checkForNewDeliveries(for: self)
    }
    
    func refresh(_ orders: [Delivery]) {
        self.orders = orders
        self.tableView.reloadData()
    }
    
    @objc
    func logout() {
        self.delegate?.logOut()
    }
}

extension OrderViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orders.count == 0 {
            return 1
        }
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.orders.count == 0 {
            let appDescriptionCell = tableView.dequeueReusableCell(withIdentifier: "AppDescriptionCell", for: indexPath) as! AppDescriptionCell
            appDescriptionCell.cellDescription.text = "No deliveries for phone number. \n Pull down to Refresh."
            appDescriptionCell.isUserInteractionEnabled = false
            return appDescriptionCell
        }
        
        let order = self.orders[indexPath.row]
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        orderCell.configureCell(order)
        return orderCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let order = self.orders[indexPath.row]
        self.delegate?.didTapOrder(order)
    }
}
