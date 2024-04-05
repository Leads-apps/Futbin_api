# Futbin_api


## How to use?

Download all players from the specified number of pages. There are 30 players on one page.

```swift
        var players : [PlayerDetail] = []

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
```

Get max number of pages

```swift
        var numberOfPage : Int = 1
        
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
```
##App Example
![Simulator Screenshot - iPhone 14 Pro - 2024-04-05 at 13 29 19](https://github.com/Leads-apps/Futbin_api/assets/95756480/8b22689b-8fa9-434a-9519-c3588c23a0c8)
