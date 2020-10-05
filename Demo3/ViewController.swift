

import UIKit
import AlamofireImage

class ViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var datasource: RootClass?
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main"
        self.view.backgroundColor = UIColor.lightGray
        let refreshButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(refresh))
        self.navigationItem.rightBarButtonItem  = refreshButtonItem
        self.httprequest()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.tableView.estimatedRowHeight = 150.0
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.rows?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        if let title =  datasource?.rows?[indexPath.row]{
            cell.title.text = title.title
            cell.title.font = UIFont.boldSystemFont(ofSize: 18)
            cell.descript.text = title.description
            cell.descript.font = UIFont.systemFont(ofSize: 13)
            cell.descript.lineBreakMode = .byWordWrapping
            cell.descript.numberOfLines = 0
            cell.descript.sizeToFit()
            cell.setupViews(height: cell.descript.frame.height)
           
            if let imageURL = URL(string: "\(datasource?.rows?[indexPath.row].imageHref ?? "")"), let placeholder = UIImage(named: "no-image-available") {
                cell.imageview.af.setImage(withURL: imageURL, placeholderImage: placeholder)
            } else {
//                print("no url, it was nil at \([indexPath.row])")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Value: \(String(describing: datasource?.rows?[indexPath.row]))")
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func httprequest() {
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
                MakeHttpRequest.sharedInstance.dataRequest { ( data ) in
                self.datasource = data
                DispatchQueue.main.async {
                    self.title = self.datasource?.title
                    self.tableView.reloadData()
                    self.tableView.setNeedsLayout()
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            }
        }else{
            print("Internet Connection not Available!")
        }
    }
    
    @objc func refresh() {
        self.httprequest()
        self.tableView.setContentOffset(.zero, animated: true)
    }
        
}
