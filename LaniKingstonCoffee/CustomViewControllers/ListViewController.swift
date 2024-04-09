//
//  ListViewController.swift
//  LaniKingstonCoffee
//
//  Created by Mackenzie Wacker on 1/6/23.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    
    var segueComplete = false
    var listCafes: [Cafe] = []
    
    override func viewDidLoad() {
        let queue = DispatchQueue(label: "ListView Q")
        
        queue.async {
            while !self.segueComplete {
//                self.view.backgroundColor = .cyan
            }
            DispatchQueue.main.async {
                super.viewDidLoad()
                self.listTableView.delegate = self
                self.listTableView.dataSource = self
                self.listTableView.reloadData()
            }
        }
        
    } // End ViewDidLoad
    
} // End VC



extension ListViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("ListTableViewCount:", listCafes.count)
            return listCafes.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
            let cafe = listCafes[indexPath.row]
            cell.nameLabel.text = cafe.name
            cell.testLabel.text = cafe.googlePlace?.isOpen
            cell.cellImageView.image = cafe.googlePlace?.image
            cell.cellImageView.contentMode = .scaleAspectFill
//            cell.testLabel.text = test
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 80
        }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCafeDetailView",
            let indexPath = listTableView.indexPathForSelectedRow,
            let destination = segue.destination as? CafeDetailViewController {
            let cafeToSend = listCafes[indexPath.row]
           print("******", cafeToSend)
            destination.cafe = cafeToSend
            
        }
        
    }
    
    
} // end Data Source Ex



extension  ListViewController: UITableViewDelegate {
//    throw up with data
//    row height. backgorund color
       //delegate - methods -functions
}
