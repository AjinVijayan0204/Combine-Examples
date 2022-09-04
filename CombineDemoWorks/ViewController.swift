//
//  ViewController.swift
//  CombineDemoWorks
//
//  Created by Ajin on 31/08/22.
//

import UIKit
import Combine
import Foundation


class ViewController: UIViewController {
    

//        private var posts: [Post] = [] {
//            didSet {
//                print("posts --> \(self.posts.count)")
//            }
//        }
    
    private var cancellable: AnyCancellable?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: - Publisher with just
        //creating a publisher using just
        /*
        let _ = Just("Hello World")
            .sink { (value) in
                print("value is \(value)")
            }
         */
        
        //MARK: - Publisher using map
        //to square values in an array
        
        /*
        [1,2,4,5]
            .publisher
            .map { (val) in
                val * val
            }
            .sink{print($0)}
         
         */
        
        print("ViewDid load")
        
//                let cancellable = URLSession.shared.dataTaskPublisher(for: url)
//                .map { $0.data }
//                .decode(type: [Post].self, decoder: JSONDecoder())
//                .replaceError(with: [])
////                .eraseToAnyPublisher()
//                .assign(to: \.posts, on: self)
        
        
        //MARK: - Assign
        
        /*
        let lable = UILabel()
        Just("Ajin")
            .map{"My name is \($0)"}
            .assign(to: \.text, on: lable)
        print(lable.text)
        
        */
        
        
       
        
        
    }
    
    
    
    @IBAction func fetchData(_ sender: UIButton) {
        print("Clicked")
        
        //MARK: - URL publisher
        
        
        let url = URL(string: "https://1jsonplaceholder.typicode.com/posts")!

        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { data in
                data.data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
        
        cancellable = publisher
        //subscribe on diff thread
            .subscribe(on: DispatchQueue(label: "a queue"))
        
        //receive on diff thread
//            .receive(on: DispatchQueue.main)// receives in main thread
        //to try mutliple times
            .retry(2)
        //to list the errors
            .mapError({ error -> Error in
                switch error {
                case URLError.cannotFindHost:
                    return ApiError.NetworkError(error: error.localizedDescription)
                default:
                    return ApiError.NoResponseError(error: error.localizedDescription)
                }
                
            })
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { items in
                print(items.count)
                print(items[0].title)
            })
         
         
        
        //try map and catch
        Just(2)
            .tryMap { data in
                throw ApiError.UnknownError
            }.catch { result in
                Just(2)
            }
            .sink{print($0)}
        
        
        //MARK: - SUBJECT
        //both publisher and subscriber combined
        // send is used to emit values to one or more subscribers
        //types -
        //1. current value subject - persists inital value for subscribers
        //2. passthrough value subject
        
        /*
        //creating pass thru
        var subject = PassthroughSubject<Int, Never>()
        
        //adding subscriber
        cancellable = subject.sink { (data) in
            print(data)
        }
        
        //adding publisher
        subject.send(20)
        
        //using just
        Just(29)
            .subscribe(subject)
        
         */
        
        
        /*
        //current value
        let anotherSubject = CurrentValueSubject<String,Never>("My name is")
        
        cancellable = anotherSubject
            .sink(receiveValue: { (data) in
                print(data)
            })
        
        anotherSubject.send("Ajin")
         
         */
        
        
        //MARK: - Just and Future
        
        //just - emits single value before termination or fail (primitive data type)
        //future - wraps request response to single result, as a result or error
        //       - used in asychronous call
        // promise - result from future
        
        
        // the error component of future
        /*
        enum FutureError: Error{
            case notMultiple
        }
        let future = Future<String, FutureError>{ promise in
            let calender = Calendar.current
            let sec = calender.component(.second, from: Date())
            print(sec)
            
            if (sec.isMultiple(of: 2)){
                promise(.success("Done"))
            }
            else{
                promise(.failure(.notMultiple))
            }
            
        }.catch({ err in
            Just("error is \(err)")
        })
            
        
            .delay(for: .init(integerLiteral: 1), scheduler: RunLoop.main)
            .eraseToAnyPublisher()//donot expose inner workings of publisher
        
        cancellable = future.sink(receiveCompletion: { data in
            print(data)
        }, receiveValue: { value in
            print("value is \(value)")
        })
        */
        
        
        
    }
}

enum ApiError:Error{
    case NetworkError(error:String)
    case NoResponseError(error: String)
    case UnknownError
}

struct Post: Codable {

    let id: Int
    let title: String
    let body: String
    let userId: Int
}

//MARK: - rest request
/*
public class APIService{
    private var cancellable: AnyCancellable?
    
    public static func getPosts() -> AnyPublisher<[Post],Error>{
        let url = URL(string: "https://1jsonplaceholder.typicode.com/posts")!

        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map { data in
                data.data
            }
            .decode(type: [Post].self, decoder: JSONDecoder())
        
        cancellable = publisher
        //to try mutliple times
            .retry(2)
        //to list the errors
            .mapError({ error -> Error in
                switch error {
                case URLError.cannotFindHost:
                    return ApiError.NetworkError(error: error.localizedDescription)
                default:
                    return ApiError.NoResponseError(error: error.localizedDescription)
                }
                
            })
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { items in
                print(items.count)
                print(items[0].title)
            })
         
    }
}
 */
