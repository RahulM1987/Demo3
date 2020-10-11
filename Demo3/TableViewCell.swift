
import Foundation
import UIKit

enum constraintsConstants {
    static let spacing: CGFloat = 12.0
    static let bottom: CGFloat = 5.0
    static let top: CGFloat = 2.0
    static let imagewidth: CGFloat = 100.0
    static let titleHeight: CGFloat = 20.0
}

class CustomTableViewCell: UITableViewCell {

    var imageview = UIImageView()
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
        imageview.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraintsConstants.spacing).isActive = true
        imageview.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: constraintsConstants.spacing).isActive = true
        imageview.rightAnchor.constraint(equalTo: self.title.leftAnchor, constant: -constraintsConstants.spacing).isActive = true
        imageview.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constraintsConstants.bottom).isActive = true
        imageview.widthAnchor.constraint(equalToConstant: constraintsConstants.imagewidth).isActive = true
        imageview.contentMode = .scaleAspectFit
        imageview.layer.borderWidth = 0.5
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        
        //Title
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: constraintsConstants.spacing).isActive = true
        title.heightAnchor.constraint(equalToConstant: constraintsConstants.titleHeight).isActive = true
        title.leftAnchor.constraint(equalTo: self.imageview.rightAnchor, constant: constraintsConstants.spacing).isActive = true
        title.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -constraintsConstants.spacing).isActive = true
        
        //Description
        descript.topAnchor.constraint(equalTo: self.title.bottomAnchor, constant: constraintsConstants.top).isActive = true
        descript.leftAnchor.constraint(equalTo: self.imageview.rightAnchor, constant: constraintsConstants.spacing).isActive = true
        descript.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -constraintsConstants.spacing).isActive = true
        descript.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -constraintsConstants.bottom).isActive = true
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
        
    // Phase 2 Start
    let imageCache = NSCache<NSString, AnyObject>()
    var imageURLString: String?

        func downloadImageFrom(urlString: String) {
            guard let url = URL(string: urlString) else { return }
            downloadImageFromURL(url: url)
        }

        func downloadImageFromURL(url: URL) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                DispatchQueue.main.async {
                    self.imageview.image = cachedImage
                }
            } else {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else { return }
                        let imageToCache = UIImage(data: data)
                        if imageToCache != nil {
                            self.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                            DispatchQueue.main.async {
                                self.imageview.image = imageToCache
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.imageview.image = #imageLiteral(resourceName: "no-image-available") }

                            if let res = response as? HTTPURLResponse {
                                switch res.statusCode {
                                case 404:
                                    print("File not found")
                                    DispatchQueue.main.async {
                                        self.imageview.image = #imageLiteral(resourceName: "404") }
                                    break
                                case 403:
                                    DispatchQueue.main.async {
                                        self.imageview.image = #imageLiteral(resourceName: "403") }
                                    break
                                default:
                                    break
                                    
                                }
                            }
                        }
                }.resume()
            }
        }
    // Phase 2 End

    
}
