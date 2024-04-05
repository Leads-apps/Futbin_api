import Foundation

final class ContentViewModel: ObservableObject {
    
    @Published var players : [PlayerDetail] = []
    @Published var numberOfPage : Int = 1
    
    init() {
        Service.getPlayersFromPages(1) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let players):
                let dispatchQueue = DispatchQueue(label: "players_detail")
                let semaphore = DispatchSemaphore(value: 0)
                players.forEach { element in
                    dispatchQueue.async {
                        semaphore.signal()
                        Service.getPlayersDetailFor(player: element) {
                            switch $0 {
                            case .success(let playerDetail):
                                DispatchQueue.main.async {
                                    self.players.append(playerDetail)
                                }
                            default:
                                break
                            }
                            semaphore.wait()
                        }
                    }
                }
            default:
                break
            }
        }
        
        Service.maxNumberPages { [weak self] in
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
