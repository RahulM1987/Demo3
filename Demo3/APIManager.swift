

import Foundation
import SVProgressHUD

class MakeHttpRequest {
    
    let httpURL =  "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    static let sharedInstance = MakeHttpRequest()
    var datasource: RootClass?
    
    func dataRequest(_ completion: @escaping (RootClass) -> ()) {
        SVProgressHUD.show()
        let url = httpURL
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, res, err) in
            if let error = err {
                print("ERROR \(error.localizedDescription)")
                SVProgressHUD.dismiss()
                SVProgressHUD.showError(withStatus: "ERROR \(error.localizedDescription)")
            } else {
                if let d = data {
                    if let value = String(data: d, encoding: String.Encoding.ascii) {
                        if let jsonData = value.data(using: String.Encoding.utf8) {
                            do {
                                _ = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                let flash = try! JSONDecoder().decode(RootClass.self, from: jsonData)
                                self.datasource = flash
                                for i in (0..<(self.datasource?.rows!.count)!-1){
                                    var new = self.datasource?.rows![i]
                                    if(((new?.title) != nil)) {
                                        //                                    print("Present")
                                    } else{
                                        //                                    print("Remove if nil")
                                        new = self.datasource?.rows?.remove(at: i)
                                    }
                                }
                                print("Count - \(String(describing: self.datasource?.rows?.count))")
                                SVProgressHUD.showSuccess(withStatus: "Success")
                                SVProgressHUD.dismiss(withDelay: 0.7)
                                completion(self.datasource!)
                            } catch {
                                print("ERROR \(error.localizedDescription)")
                                SVProgressHUD.showError(withStatus: "ERROR \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    
    func showAlertMessage(vc: UIViewController, titleS:String, messageS:String) -> Void {
        let alert = UIAlertController(title: titleS, message: messageS, preferredStyle: UIAlertController.Style.alert);
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                                        print("Action") }))
        vc.present(alert, animated: true, completion: nil)
    }
}
