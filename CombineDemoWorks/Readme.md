#  Readme

ERRORS


error types are declared in advance

expected errors are handled with mapError operator

network errors are handled with retry operator

to ignore errors use - catch or ReplaceError


        //MARK: - Challenge 1
        /*
        var datas = [true, false, true, true, false, true]

        var textField = UITextField()
        let publisher = datas.publisher
        let subscriber = publisher.assign(to: \.isEnabled , on: textField)
        textField.publisher(for: \.isEnabled)
            .sink { val in
                print("data \(val)")
            }
        publisher.dropFirst(2).sink { data in
            print(data)
        }
         */
         
         
         challenge 2
         
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

let cancellable: AnyCancellable?

let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!

let emptyPost = Post(id: 0, title: "", body: "Empty", userId: 0)

let publisher = URLSession.shared.dataTaskPublisher(for: url)
    .map { data in
        data.data
    }
    .decode(type: [Post].self, decoder: JSONDecoder())
    .map{ data in
        data.first
    }
    .replaceNil(with: emptyPost)
    .map { data in
        data.title
    }

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
        print(items)
    })
 
         
