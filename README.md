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

## Data points
```swift
public struct Player {
    
    public let linkDetail : String
    public let name : String?
    public let playerPrice : String?
    public let popularity : String?
    public let baseStats : String?
    public let gameStats : String?
}

public struct PlayerDetail: Identifiable {
    
    public var player: Player?
    public var id : String
    public var name : String?
    public var playerImage : String?
    public var cardImage : String?
    public var clubName : String?
    public var clubImage : String?
    public var nationality : String?
    public var natioalityFlag : String?
    public var leagueName : String?
    public var leagueImage : String?
    public var rareType : String?
    public var rate : String?
    public var position : String?
    public var skills : String?
    public var weakFoot : String?
    public var attackWR : String?
    public var defenseWR : String?
    public var pace : String?
    public var shooting : String?
    public var passing : String?
    public var dribbling : String?
    public var defending : String?
    public var physicality : String?
    public var height : String?
    public var weight : String?
}
```
##App Example
![Simulator Screenshot - iPhone 14 Pro - 2024-04-05 at 13 29 19](https://github.com/Leads-apps/Futbin_api/assets/95756480/8b22689b-8fa9-434a-9519-c3588c23a0c8)
