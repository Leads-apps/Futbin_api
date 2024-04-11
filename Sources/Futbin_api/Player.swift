import Foundation

public struct Player {
    
    public let linkDetail : String
    public let name : String?
    public let playerPrice : String?
    public let popularity : String?
    public let baseStats : String?
    public let gameStats : String?
    
    public init(linkDetail: String,
                name: String? = nil,
                playerPrice: String? = nil,
                popularity: String? = nil,
                baseStats: String? = nil,
                gameStats: String? = nil) {
        self.linkDetail = linkDetail
        self.name = name
        self.playerPrice = playerPrice
        self.popularity = popularity
        self.baseStats = baseStats
        self.gameStats = gameStats
    }
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
    
    public init(player: Player? = nil,
                id: String = UUID().uuidString,
                name: String? = nil,
                playerImage: String? = nil,
                cardImage: String? = nil,
                clubName: String? = nil,
                clubImage: String? = nil,
                nationality: String? = nil,
                natioalityFlag: String? = nil,
                leagueName: String? = nil,
                leagueImage: String? = nil,
                rareType: String? = nil,
                rate: String? = nil,
                position: String? = nil,
                skills: String? = nil,
                weakFoot: String? = nil,
                attackWR: String? = nil,
                defenseWR: String? = nil,
                pace: String? = nil,
                shooting: String? = nil,
                passing: String? = nil,
                dribbling: String? = nil,
                defending: String? = nil,
                physicality: String? = nil,
                height: String? = nil,
                weight: String? = nil) {
        self.player = player
        self.id = id
        self.name = name
        self.playerImage = playerImage
        self.cardImage = cardImage
        self.clubName = clubName
        self.clubImage = clubImage
        self.nationality = nationality
        self.natioalityFlag = natioalityFlag
        self.leagueName = leagueName
        self.leagueImage = leagueImage
        self.rareType = rareType
        self.rate = rate
        self.position = position
        self.skills = skills
        self.weakFoot = weakFoot
        self.attackWR = attackWR
        self.defenseWR = defenseWR
        self.pace = pace
        self.shooting = shooting
        self.passing = passing
        self.dribbling = dribbling
        self.defending = defending
        self.physicality = physicality
        self.height = height
        self.weight = weight
    }
}
