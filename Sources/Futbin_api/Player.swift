import Foundation

public struct Player {
    
    public let linkDetail : String
    public var playerPrice : String?
    public var popularity : String?
    public var baseStats : String?
    public var gameStats : String?
}

public struct PlayerDetail: Identifiable {
    
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
    public var playerPrice : String?
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
    public var popularity : String?
    public var baseStats : String?
    public var gameStats : String?
    
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
        playerPrice = nil
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
        popularity = nil
        baseStats = nil
        gameStats = nil
    }
}
