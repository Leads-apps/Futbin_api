import Foundation
import Futbin_api

final class ContentViewModel: ObservableObject {
    
    @Published var players : [Player] = []
    @Published var numberOfPage : Int = 1
    
    init() {
        Parser.getAsyncGroupPlayersFromPages(1) { [weak self] in
            guard let self else { return }
            switch $0 {
                case .success(let players):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.players += players
                    }
                default:
                    break
            }
        }
        
        Parser.maxNumberPages { [weak self] in
            guard let self else { return }
            switch $0 {
                case .success(let number):
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.numberOfPage = number
                    }
                default:
                    break
            }
        }
    }
}
