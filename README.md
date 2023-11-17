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
##App Example
![Simulator Screenshot - iPhone 14 Pro - 2023-11-17 at 15 51 19](https://github.com/Leads-apps/Futbin_api/assets/95756480/46383df2-7369-44d1-adaf-b2d80d1caf22)
