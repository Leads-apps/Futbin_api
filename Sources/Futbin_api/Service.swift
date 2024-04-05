import Foundation
import SwiftSoup

public struct Service {
    
    //MARK: - nested enum
    
    private enum ServiceError: Error {
        case badURL
        case sessionError(error: Error)
        case noData
    }
    
    private enum ServiceProperty: String {
        case pageNumber = "page-item"
        case player1 = "player_tr_1"
        case player2 = "player_tr_2"
        
        var name : String {
            rawValue
        }
    }
    
    private enum ServiceClass: String {
        case table = "table  table-info"
        case club = "pcdisplay-club"
        case league = "pcdisplay-league"
        case country = "pcdisplay-country"
        case position = "pcdisplay-pos"
        case rate = "pcdisplay-rat"
        case playerImage = "pcdisplay-picture-width"
        case price = "font-weight-bold"
        case playerCards = "download-prices-player-name-holder"
        
        var name : String {
            rawValue
        }
    }
    
    private enum ServiceID: String {
        case pace = "main-pace-val-0"
        case shooting = "main-shooting-val-0"
        case passing = "main-passing-val-0"
        case dribbling = "main-dribblingp-val-0"
        case defending = "main-defending-val-0"
        case physicality = "main-heading-val-0"
        case table = "repTb"
        
        var id : String {
            rawValue
        }
    }
    
    private enum ServiceAttributeKey: String {
        case src = "src"
        case url = "data-url"
        
        var key : String {
            rawValue
        }
    }
    
    private enum ServiceTag: String {
        case a = "a"
        case img = "img"
        case span = "span"
        case td = "td"
        case div = "div"
        case tbody = "tbody"
        
        var tag : String {
            rawValue
        }
    }
    
    //MARK: - private properties
    
    private static var playersLink : String { "https://www.futbin.com/players" }
    private static var mainLink : String { "https://www.futbin.com" }
    private static let playersQueue = DispatchQueue(label: "Players")
    private static let pageNumbersQueue = DispatchQueue(label: "PageNumbers")
    private static let groupQueue = DispatchQueue(label: "Group")
    
    //MARK: - public methods
    ///Get detail player info (PlayerDetail) with input model Player
    static func getPlayersDetailFor(player: Player, result: @escaping (Result<PlayerDetail, Error>) -> ()) {
        let link = mainLink + player.linkDetail
        getHTML(from: link) { complition in
            switch complition {
            case .success(let html):
                do {
                    let document = try SwiftSoup.parse(html)
                    let elements = try document.getAllElements()
                    
                    getPlaersDetailFrom(elements) { complition in
                        switch complition {
                        case .success(let playerDetail):
                            var playerDetail = playerDetail
                            playerDetail.playerPrice = player.playerPrice
                            playerDetail.popularity = player.popularity
                            playerDetail.baseStats = player.baseStats
                            playerDetail.gameStats = player.gameStats
                            
                            result(.success(playerDetail))
                        case .failure(let error):
                            result(.failure(error))
                        }
                    }
                } catch {
                    result(.failure(error))
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    ///Download 30 players in turn from the specified number of pages
    public static func getPlayersFromPages(_ pageNumber: Int, result: @escaping (Result<[Player], Error>) -> ()) {
        let link = playersLink + "?page=" + String(pageNumber)
        getPlayersList(from: link) { inputResult in
            switch inputResult {
            case .success(let inputPlayers):
                result(.success(inputPlayers))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    ///Get max number of pages
    public static func maxNumberPages(result: @escaping (Result<Int, Error>) -> ()){
        getHTML(from: playersLink) { complition in
            pageNumbersQueue.async {
                switch complition {
                case .success(let html):
                    do {
                        let document = try SwiftSoup.parse(html)
                        let elements : Elements = try document.getElementsByClass(ServiceProperty.pageNumber.name)
                        var pages : [Int] = .init()
                        for element in elements {
                            let text = try element.text()
                            if let number = Int(text) {
                                pages.append(number)
                            }
                        }
                        let numbersOfPage = pages.max() ?? 1
                        result(.success(numbersOfPage))
                    } catch {
                        result(.failure(error))
                    }
                case .failure(let error):
                    result(.failure(error))
                }
            }
        }
    }
    
    //MARK: - private methods
    
    private static func getPlaersDetailFrom(_ elements: Elements, result: @escaping (Result<PlayerDetail, Error>) -> ()) {
        do {
            var playerDetail = PlayerDetail()
            let table = try elements.first()?.getElementsByClass(ServiceClass.table.name)
            let selectTdTag = try table?.select(ServiceTag.tbody.tag).select(ServiceTag.td.tag)
            let name = selectTdTag?[safe: 0]
            playerDetail.name = try name?.text()
            let clubElement = selectTdTag?[safe: 2]
            let clubName = try clubElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.clubName = clubName
            let clubImage = try elements.first()?.getElementsByClass(ServiceClass.club.name).first()?.select(ServiceTag.img.tag).array().first?.attr(ServiceAttributeKey.src.key)
            playerDetail.clubImage = clubImage
            let leagueElement = selectTdTag?[safe: 4]
            let leagueName = try leagueElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.leagueName = leagueName
            let leagueImage = try elements.first()?.getElementsByClass(ServiceClass.league.name).first()?.select(ServiceTag.img.tag).array().first?.attr(ServiceAttributeKey.src.key)
            playerDetail.leagueImage = leagueImage
            let nationalityElement = selectTdTag?[safe: 3]
            let nationality = try nationalityElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.nationality = nationality
            let natioalityFlag = try elements.first()?.getElementsByClass(ServiceClass.country.name).first()?.select(ServiceTag.img.tag).array().first?.attr(ServiceAttributeKey.src.key)
            playerDetail.natioalityFlag = natioalityFlag
            let skillsElement = selectTdTag?[safe: 5]
            let skills = try skillsElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.skills = skills
            let weakFootElement = selectTdTag?[safe: 6]
            let weakFoot = try weakFootElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.weakFoot = weakFoot
            let position = try elements.first()?.getElementsByClass(ServiceClass.position.name).first()?.text()
            playerDetail.position = position
            let rate = try elements.first()?.getElementsByClass(ServiceClass.rate.name).first()?.text()
            playerDetail.rate = rate
            let playerImage = try elements.first()?.getElementsByClass(ServiceClass.playerImage.name).first()?.select(ServiceTag.img.tag).array().first?.attr(ServiceAttributeKey.src.key)
            playerDetail.playerImage = playerImage
            let cardImage = try elements.first()?.getElementsByClass(ServiceClass.playerCards.name).first()?.select(ServiceTag.img.tag).array().first?.attr(ServiceAttributeKey.src.key)
            playerDetail.cardImage = mainLink + (cardImage ?? "")
            let attackWRElement = selectTdTag?[safe: 12]
            let attackWR = try attackWRElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.attackWR = attackWR
            let defenseWRElement = selectTdTag?[safe: 13]
            let defenseWR = try defenseWRElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.defenseWR = defenseWR
            let pace = try elements.first()?.getElementById(ServiceID.pace.id)?.text()
            playerDetail.pace = pace
            let shooting = try elements.first()?.getElementById(ServiceID.shooting.id)?.text()
            playerDetail.shooting = shooting
            let passing = try elements.first()?.getElementById(ServiceID.passing.id)?.text()
            playerDetail.passing = passing
            let dribbling = try elements.first()?.getElementById(ServiceID.dribbling.id)?.text()
            playerDetail.dribbling = dribbling
            let defending = try elements.first()?.getElementById(ServiceID.defending.id)?.text()
            playerDetail.defending = defending
            let physicality = try elements.first()?.getElementById(ServiceID.physicality.id)?.text()
            playerDetail.physicality = physicality
            let heightWRElement = selectTdTag?[safe: 9]
            let height = try heightWRElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.height = height
            let weightWRElement = selectTdTag?[safe: 10]
            let weight = try weightWRElement?.tagName(ServiceTag.a.tag).text()
            playerDetail.weight = weight
            result(.success(playerDetail))
        } catch {
            result(.failure(error))
        }
    }
    
    private static func getPlayersList(from link: String, result: @escaping (Result<[Player], Error>) -> ()) {
        getHTML(from: link) { complition in
            switch complition {
            case .success(let html):
                do {
                    let document = try SwiftSoup.parse(html)
                    let elements = try getElements(from: document)
                    let players = try getPlayersLinks(from: elements)
                    result(.success(players))
                } catch {
                    result(.failure(error))
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    private static func getElements(from document: Document) throws -> [Elements] {
        do {
            var playersElements : [Elements] = .init()
            let player1Elements : Elements = try document.getElementsByClass(ServiceProperty.player1.name)
            let player2Elements : Elements = try document.getElementsByClass(ServiceProperty.player2.name)
            playersElements.append(contentsOf: [player1Elements, player2Elements])
            return playersElements
        } catch {
            throw error
        }
    }
    
    private static func getPlayersLinks(from playersElements: [Elements]) throws -> [Player] {
        do {
            var players : [Player] = .init()
            for playerElements in playersElements {
                for element in playerElements {
                    let link = try element.attr(ServiceAttributeKey.url.key)
                    let name = try element.getElementsByTag(ServiceTag.td.tag)[safe: 1]?.text()
                    let playerPrice = try element.getElementsByClass(ServiceClass.price.name).select(ServiceTag.span.tag).text()
                    let popularity = try element.getElementsByTag(ServiceTag.td.tag)[safe: 16]?.text()
                    let baseStats = try element.getElementsByTag(ServiceTag.td.tag)[safe: 17]?.text()
                    let gameStats = try element.getElementsByTag(ServiceTag.td.tag)[safe: 18]?.text()
                    let player : Player = .init(linkDetail: link,
                                                name: name,
                                                playerPrice: playerPrice,
                                                popularity: popularity,
                                                baseStats: baseStats,
                                                gameStats: gameStats)
                    players.append(player)
                }
            }
            return players
        } catch {
            throw error
        }
    }
    
    private static func getHTML(from link: String, complition: @escaping (_ complition: Result<String, ServiceError>) -> ()) {
        guard let url = URL(string: link) else {
            complition(.failure(.badURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request) { data, response, error in
            if let error {
                complition(.failure(.sessionError(error: error)))
            }
            if let data = data, let content = String(data: data, encoding: .utf8) {
                complition(.success(content))
            } else {
                complition(.failure(.noData))
            }
        }.resume()
    }
}

extension Elements {
    subscript(safe index: Int) -> Element? {
        guard index >= 0 && index < count else {
            return nil
        }
        return self[index]
    }
}
