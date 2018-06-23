//
//  OrderDetailsViewController.swift
//  FlexConnect
//
//  Created by Peter Gosling on 5/19/18.
//  Copyright © 2018 Peter Gosling. All rights reserved.
//

import UIKit

protocol OrderDetailsDelegate: class {
    func userDidTapEnroute(_ bool: Bool, _ delivery: Delivery)
    func userDidTapDelivered(_ delivery: Delivery, _ guid: String, photoStringBase64: String, comments: String)
    func userDidTapDirections(for order: Delivery)
    func attachPhoto(_ detailsController: OrderDetailsViewController)
}

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate: OrderDetailsDelegate?
    var order: Delivery
    var deliveryStatus: CDDeliveryStatus?
    
    init(_ order: Delivery) {
        self.order = order
        self.deliveryStatus = CoreData.shared.fetchDelivery(self.order.guid)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "DetailsCell", bundle: nil), forCellReuseIdentifier: "DetailsCell")
        self.tableView.register(UINib.init(nibName: "DistanceEstimatedCommentsCell", bundle: nil), forCellReuseIdentifier: "DistanceEstimatedCommentsCell")
        self.tableView.register(UINib.init(nibName: "StatusWithDirectionsCell", bundle: nil), forCellReuseIdentifier: "StatusWithDirectionsCell")
        self.tableView.reloadData()
        self.tableView.backgroundColor = Colors.background
        self.tableView.tableFooterView = UIView()
        self.order.orderIsEnroute(true)
    }


}

extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let details = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
            details.configure(self.order)
            details.delegate = self
            return details
        case 1:
            let distanceEstimated = tableView.dequeueReusableCell(withIdentifier: "DistanceEstimatedCommentsCell", for: indexPath) as! DistanceEstimatedCommentsCell
            distanceEstimated.configure(self.order)
            return distanceEstimated
        case 2:
            let statusWithDirections = tableView.dequeueReusableCell(withIdentifier: "StatusWithDirectionsCell", for: indexPath) as! StatusWithDirectionsCell
            if let deliveryStatus = CoreData.shared.fetchDelivery(self.order.guid) {
                 statusWithDirections.configure(deliveryStatus)
            }
            statusWithDirections.delegate = self
            return statusWithDirections
        default:
            break
        }
        return UITableViewCell()
    }
}

extension OrderDetailsViewController: StatusCellProtocol {
    func didSwitchEnroute(_ bool: Bool) {
        self.delegate?.userDidTapEnroute(bool, self.order)
    }
    
    func didSwitchDelivered() {
        if self.deliveryStatus?.attachedPicture == nil {
            let alertController = UIAlertController.init(title: "Attach an image?", message: "Do you want to attach an image?", preferredStyle: .alert)
            let noAction = UIAlertAction.init(title: "No", style: .default, handler: { action in
                self.delegate?.userDidTapDelivered(self.order, self.order.guid, photoStringBase64: self.deliveryStatus?.attachedPicture ?? "", comments: "")
            })
            let addPhotoAction = UIAlertAction.init(title: "Yes", style: .default) { (action) in
                self.delegate?.attachPhoto(self)
            }
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(noAction)
            alertController.addAction(addPhotoAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        self.delegate?.userDidTapDelivered(self.order, self.order.guid, photoStringBase64: self.deliveryStatus?.attachedPicture ?? "", comments: self.order.comments)
    }
    
    func attachPhoto() {
        self.delegate?.attachPhoto(self)
    }
    
}

extension OrderDetailsViewController: DirectionsDelegate {
    func didTapDirections() {
        self.delegate?.userDidTapDirections(for: self.order)
    }
}

extension OrderDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.navigationController?.presentedViewController?.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let resizedImage = ImageUtility.resizeImage(image: image, targetSize: CGSize.init(width: 500, height: 500))
        guard let imageData = UIImageJPEGRepresentation(resizedImage, 0.4) else {
            fatalError("Error converting image to data")
        }
        
        let base64Image = imageData.base64EncodedString().addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed)!
        self.delegate?.userDidTapDelivered(self.order, self.order.guid, photoStringBase64: base64Image, comments: self.order.comments)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
