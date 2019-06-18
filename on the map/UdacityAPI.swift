import Foundation
import MapKit

class UdacityAPI{
    
    
    static func postSession(with email: String, Password: String, completion: @escaping ([String:Any]?, Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        //request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(Password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                completion(nil, statusCodeError)
                return
            }
            
            guard (statusCode >= 200  && statusCode <= 299) else {
                print("Status code is not 2xx!")
                completion (nil, nil)
                return
            }
            let newData = data!.subdata(in: 5..<data! .count)
            let result = try! JSONSerialization.jsonObject(with: newData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
            completion(result, nil)
        }
        task.resume()
    }
    
    static func deletSession(completion : @escaping ([String:Any]?, Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (nil, error)
                return
            }
            let newData = data!.subdata(in: 5..<data! .count)
            print(String(data: newData, encoding: .utf8)!)
            completion (nil, error)
            
        }
        task.resume()
        
    }
    
    static func putSession(completion: @escaping ([String:Any]?, Error?) -> ()){
        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    // static func postStudentLocations(link: String, locationCoordinate: CLLocationCoordinate2D, locationName: String, completion: @escaping (Error?) -> ())
    class parse {
        static func postStudentLocations(_ location: StudentLocation, completion: @escaping (Error?) -> ()){
            
            var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \(location.mediaURL),\"latitude\": \(location.latitude), \"longitude\": \(location.longitude)}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                var errorStrin: String?
                if let stausCode = (response as? HTTPURLResponse)?.statusCode{
                    if stausCode >= 400 {
                        errorStrin = "coudnt post ur location"}
                }else {
                    errorStrin = "check ur connection"}

                DispatchQueue.main.async {
                    completion((errorStrin as! Error))
                }
            }
            task.resume()
            
        }
        
        
        //limit: Int = 100, skip: Int = 0, orderBy = .updatedAt ,

        static func getStudentLocations( completion: @escaping ([StudentLocation]?, Error?) -> ()){
            var request = URLRequest (url: URL (string: "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100&&skip=0&&order=-updatedAt")!)
            request.httpMethod = "GET"
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            let task = URLSession.shared.dataTask(with: request) {data, response, error in
                if error != nil {
                    
                    completion (nil, error)
                    return
                }
                print (String(data: data!, encoding: .utf8)!)
                var studentLocations: [StudentLocation] = []
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    // TODO: Call the completion handler and send the error so it can be handled on the UI, also call "return" so the code next to this block won't be executed (you need to call return in let guard's else body anyway)
                    let statusCodeError = NSError(domain: NSURLErrorDomain, code: 0, userInfo: nil)
                    
                    completion (nil, statusCodeError)
                    return
                }
                if statusCode >= 200 && statusCode < 300 {
                    
                    //Get an object based on the received data in JSON format
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: []), let jsonDictionary = jsonObject as? [String : Any] , let results = jsonDictionary["results"] as? [Any] {
                        //Check if the result array is nil using guard let, if it's return, otherwise continue
                        
                        //Use JSONDecoder to convert dataObject to an array of structs
                        for array in results {
                            let dataObject = try! JSONSerialization.data(withJSONObject: array)
                            let studentsLocation = try! JSONDecoder().decode(StudentLocation.self, from: dataObject)
                            studentLocations.append(studentsLocation)
                        }
                    }}
                DispatchQueue.main.async {
                    completion(studentLocations,nil)
                }
            }
            task.resume()
            
        }
        
    }
}
