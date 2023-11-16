# Futbin_api


## How to use?

Download all players from the specified number of pages. There are 30 players on one page.

```swift
        var players : [Player] = []

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
```

Get max number of pages

```swift
        var numberOfPage : Int = 1
        
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
```
