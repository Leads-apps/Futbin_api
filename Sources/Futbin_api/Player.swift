import Foundation

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
    
    init() {
        id = UUID().uuidString
        name = nil
        playerImage = nil
        cardImage = nil
        clubName = nil
        clubImage = nil
        nationality = nil
        natioalityFlag = nil
        leagueName = nil
        leagueImage = nil
        rareType = nil
        rate = nil
        position = nil
        skills = nil
        weakFoot = nil
        attackWR = nil
        defenseWR = nil
        pace = nil
        shooting = nil
        passing = nil
        dribbling = nil
        defending = nil
        physicality = nil
        height = nil
        weight = nil
    }
}
