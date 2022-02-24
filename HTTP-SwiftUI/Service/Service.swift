
import Foundation
import Combine
import Alamofire

protocol ServiceProtocol: AnyObject {
    func fetchData<Model: Decodable>(from url: String, by model: Model) -> AnyPublisher<DataResponse<Model, NetworkError>, Never>
}

class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {

    func fetchData<Model: Decodable>(from url: String, by model: Model) -> AnyPublisher<DataResponse<Model, NetworkError>, Never> {

        return AF.request(url, method: .get)
            .validate()
            .downloadProgress { progress in
                    print("totalUnitCount:\n", progress.totalUnitCount)
                    print("completedUnitCount:\n", progress.completedUnitCount)
                    print("fractionCompleted:\n", progress.fractionCompleted)
                    print("localizedDescription:\n", progress.localizedDescription ?? "")
                    print("---------------------------------------------")
                }
            .publishDecodable(type: Model.self).map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap {
                        try? JSONDecoder().decode(BackendError.self, from: $0)
                    }
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
