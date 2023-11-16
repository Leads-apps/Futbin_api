import Foundation
import SwiftSoup

public struct Parser {
    
    //MARK: - nested enum
    
    private enum ParserError: Error {
        case badURL
        case sessionError(error: Error)
        case noData
    }
    
    private enum ParserProperty: String {
        case pageNumber = "page-item"
        case player1 = "player_tr_1"
        case player2 = "player_tr_2"
        
        var name : String {
            rawValue
        }
    }
    
    private enum ParserClass: String {
        case playerName = "player_name_players_table get-tp"
        case playerClub = "players_club_nation"
        case playerImage = "d-inline"
        case playerPosition = "font-weight-bold"
        
        var name : String {
            rawValue
        }
    }
    
    private enum ParserAttributeKey: String {
        case title = "data-original-title"
        case data = "data-original"
        case src = "src"
        
        var key : String {
            rawValue
        }
    }
    
    private enum ParserTag: String {
        case a = "a"
        case img = "img"
        case span = "span"
        case td = "td"
        case div = "div"
        
        var tag : String {
            rawValue
        }
    }
    
    //MARK: - private properties
    
    private static var mainLink : String { "https://www.futbin.com/players" }
    private static let playersQueue = DispatchQueue(label: "Players")
    private static let pageNumbersQueue = DispatchQueue(label: "PageNumbers")
    private static let groupQueue = DispatchQueue(label: "Group")
    
    //MARK: - public methods
    ///Download all players from the specified number of pages. There are 30 players on one page.
    public static func getAllPlayersFromPages(_ pagesCount: Int, result: @escaping (Result<[Player], Error>) -> ()) {
        var players : [Player] = []
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        playersQueue.async {
            for pageNumber in 1...pagesCount {
                let link = mainLink + "?page=" + String(pageNumber)
                getPlayers(from: link) { inputResult in
                    switch inputResult {
                        case .success(let inputPlayers):
                            players.append(contentsOf: inputPlayers)
                        case .failure(let error):
                            result(.failure(error))
                    }
                    dispatchSemaphore.signal()
                }
                dispatchSemaphore.wait()
            }
            result(.success(players))
        }
    }
    ///Download 30 players in turn from the specified number of pages
    public static func getAsyncGroupPlayersFromPages(_ pagesCount: Int, result: @escaping (Result<[Player], Error>) -> ()) {
        for pageNumber in 1...pagesCount {
            let link = mainLink + "?page=" + String(pageNumber)
            getPlayers(from: link) { inputResult in
                switch inputResult {
                    case .success(let inputPlayers):
                        result(.success(inputPlayers))
                    case .failure(let error):
                        result(.failure(error))
                }
            }
        }
    }
    ///Get max number of pages
    public static func maxNumberPages(result: @escaping (Result<Int, Error>) -> ()){
        getHTML(from: mainLink) { complition in
            pageNumbersQueue.async {
                switch complition {
                    case .success(let html):
                        do {
                            let document = try SwiftSoup.parse(html)
                            let elements : Elements = try document.getElementsByClass(ParserProperty.pageNumber.name)
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
    
    private static func getPlayers(from link: String, result: @escaping (Result<[Player], Error>) -> ()) {
        getHTML(from: link) { complition in
            switch complition {
                case .success(let html):
                    do {
                        let document = try SwiftSoup.parse(html)
                        let playersElements = try getPlayersElements(from: document)
                        let players = try getContentForPlayers(from: playersElements)
                        result(.success(players))
                    } catch {
                        result(.failure(error))
                    }
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    private static func getPlayersElements(from document: Document) throws -> [Elements] {
        do {
            var playersElements : [Elements] = .init()
            let player1Elements : Elements = try document.getElementsByClass(ParserProperty.player1.name)
            let player2Elements : Elements = try document.getElementsByClass(ParserProperty.player2.name)
            playersElements.append(contentsOf: [player1Elements, player2Elements])
            return playersElements
        } catch {
            throw error
        }
    }
    
    private static func getContentForPlayers(from playersElements: [Elements]) throws -> [Player] {
        do {
            var players : [Player] = .init()
            for playerElements in playersElements {
                for element in playerElements {
                    let nameElement = try element.getElementsByClass(ParserClass.playerName.name)
                    guard let name = try nameElement.first()?.text() else { return players }
                    
                    let imageElement = try element.getElementsByClass(ParserClass.playerImage.name)
                    let tagElement = try imageElement.select(ParserTag.img.tag)
                    let image = try tagElement.attr(ParserAttributeKey.data.key)
                    
                    let clubElements = try element.getElementsByClass(ParserClass.playerClub.name).first()
                    let clubElement = try clubElements?.getElementsByTag(ParserTag.a.tag)
                    guard let clubName = try clubElement?[0].attr(ParserAttributeKey.title.key),
                          let clubImage = try clubElement?[0].select(ParserTag.img.tag).attr(ParserAttributeKey.src.key),
                          let nationality = try clubElement?[1].attr(ParserAttributeKey.title.key),
                          let natioalityFlag = try clubElement?[1].select(ParserTag.img.tag).attr(ParserAttributeKey.src.key),
                          let leagueName = try clubElement?[2].attr(ParserAttributeKey.title.key),
                          let leagueImage = try clubElement?[2].select(ParserTag.img.tag).attr(ParserAttributeKey.src.key) else { return players }
                    
                    
                    guard let position = try element.getElementsByClass(ParserClass.playerPosition.name).first()?.text() else { return players }
                    
                    let snapElements = try element.select(ParserTag.span.tag)
                    let rate = try snapElements[2].text()
                    let playerPrice = try snapElements[3].text()
                    
                    let tdElements = try element.select(ParserTag.td.tag)
                    let skills = try tdElements[6].text()
                    let weakFoot = try tdElements[7].text()
                    let attackDefense = try tdElements[8].text()
                    let pace = try tdElements[9].text()
                    let shooting = try tdElements[10].text()
                    let passing = try tdElements[11].text()
                    let dribbling = try tdElements[12].text()
                    let defending = try tdElements[13].text()
                    let physicality = try tdElements[14].text()
                    let heightWeight = try tdElements[15].text()
                    let popularity = try tdElements[16].text()
                    let baseStats = try tdElements[17].text()
                    let gameStats = try tdElements[18].text()
                    
                    let player : Player = .init(name: name,
                                                playerImage: image,
                                                clubName: clubName,
                                                clubImage: clubImage,
                                                nationality: nationality,
                                                natioalityFlag: natioalityFlag,
                                                leagueName: leagueName,
                                                leagueImage: leagueImage,
                                                rate: Int(rate) ?? .zero,
                                                position: position,
                                                playerPrice: playerPrice,
                                                skills: Int(skills) ?? .zero,
                                                weakFoot: Int(weakFoot)  ?? .zero,
                                                attackDefense: attackDefense,
                                                pace: Int(pace) ?? .zero,
                                                shooting: Int(shooting) ?? .zero,
                                                passing: Int(passing) ?? .zero,
                                                dribbling: Int(dribbling) ?? .zero,
                                                defending: Int(defending) ?? .zero,
                                                physicality: Int(physicality) ?? .zero,
                                                heightWeight: heightWeight,
                                                popularity: Int(popularity) ?? .zero,
                                                baseStats: Int(baseStats) ?? .zero,
                                                gameStats: Int(gameStats) ?? .zero)
                    players.append(player)
                }
            }
            return players
        } catch {
            throw error
        }
    }
    
    private static func getHTML(from link: String, complition: @escaping (_ complition: Result<String, ParserError>) -> ()) {
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
