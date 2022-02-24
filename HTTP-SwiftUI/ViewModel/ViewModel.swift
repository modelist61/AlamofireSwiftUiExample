
import Foundation
import Combine

class ViewModel: ObservableObject {
    
    @Published var movies =  [PopularMovieList]()
    @Published var users = [UsersModel]()
    @Published var errorAlertMessage: String = ""
    @Published var showAlert: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var dataManager: ServiceProtocol
    
    init(dataManager: ServiceProtocol = Service.shared) {
        self.dataManager = dataManager
        getApiAnswer()
        getUsersApiAnswer()
    }
    
// First MoveAPI
    let url = "https://api.themoviedb.org/3/movie/popular?api_key=0ca2f1cf8f508f5c8b381ac091438d5c"
    
    func getApiAnswer() {
        dataManager.fetchData(from: url, by: MainModelFetcher(results: movies))
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    self.movies = dataResponse.value!.results
                }
            }.store(in: &cancellableSet)
    }

// Second UsersAPI
    let userUrl = "https://gorest.co.in/public/v2/users?access-token=d870033a77b9d3e0084fa3d63f4f20c9ad909d7c2078a70b7446dc291b719d8b"

    func getUsersApiAnswer() {

        var usersArray: [UsersModel] = []

        dataManager.fetchData(from: userUrl, by: usersArray)
            .sink { (dataResponse) in
                if dataResponse.error != nil {
                    self.createAlert(with: dataResponse.error!)
                } else {
                    dataResponse.value?.forEach {
                        usersArray.append($0)
                    }
                    self.users = usersArray
                }
            }.store(in: &cancellableSet)
        
    }
    
    func createAlert( with error: NetworkError ) {
        errorAlertMessage = error.backendError == nil ?
                            error.initialError.localizedDescription :
                            error.backendError!.message
        self.showAlert = true
    }
}
