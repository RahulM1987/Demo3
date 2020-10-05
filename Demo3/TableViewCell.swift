
import Foundation
import UIKit


class CustomTableViewCell: UITableViewCell {

    let imageview = UIImageView()
    let title = UILabel()
    let descript = UILabel()
    var myViewHeightConstraint: NSLayoutConstraint!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imageview.layer.cornerRadius = 10
        imageview.layer.masksToBounds = true
        imageview.image = #imageLiteral(resourceName: "no-image-available")
        imageview.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        descript.translatesAutoresizingMaskIntoConstraints = false

        self.addSubViewsAndlayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubViewsAndlayout() {
        contentView.addSubview(imageview)
        contentView.addSubview(title)
        contentView.addSubview(descript)
        
        //ImageView
        imageview.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12.0).isActive = true
        imageview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 12).isActive = true
        imageview.rightAnchor.constraint(equalTo: self.title.leftAnchor, constant: -12).isActive = true
        imageview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageview.contentMode = .scaleAspectFit
        
        //Title
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12.0).isActive = true
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.leftAnchor.constraint(equalTo: self.imageview.rightAnchor, constant: 12).isActive = true
        title.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        
        //Description
        descript.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: 2.0).isActive = true
        descript.leftAnchor.constraint(equalTo: self.imageview.rightAnchor, constant: 12).isActive = true
        descript.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
        descript.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5).isActive = true
                myViewHeightConstraint = descript.heightAnchor.constraint(equalToConstant: 50)
                myViewHeightConstraint.priority = UILayoutPriority.init(999)
                myViewHeightConstraint.isActive = true
        
    }
    private var task: URLSessionDataTask?

    override func prepareForReuse() {
        super.prepareForReuse()
        task?.cancel()
        imageview.image = nil
    }
    
    func setupViews(height:CGFloat) {
            myViewHeightConstraint.constant = height
        }
    
}
