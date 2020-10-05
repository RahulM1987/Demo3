

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
                            SVProgressHUD.dismiss()
                            completion(self.datasource!)
                            
                        } catch {
                            NSLog("ERROR \(error.localizedDescription)")
                        }
                    }
                }
            }
        }.resume()
    }
}
