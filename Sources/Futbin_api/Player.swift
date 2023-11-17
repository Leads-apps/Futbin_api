import Foundation

public struct Player {
    
    public let name : String
    public let playerImage : String
    public let clubName : String
    public let clubImage : String
    public let nationality : String
    public let natioalityFlag : String
    public let leagueName : String
    public let leagueImage : String
    public let technicalImage : String
    public let rareType : RareType
    public let rate : Int
    public let position : String
    public let playerPrice : String
    public let skills : Int
    public let weakFoot : Int
    public let attackDefense : String
    public let pace : Int
    public let shooting : Int
    public let passing : Int
    public let dribbling : Int
    public let defending : Int
    public let physicality : Int
    public let heightWeight : String
    public let popularity : Int
    public let baseStats : Int
    public let gameStats : Int
}

public enum RareType: String, CaseIterable {
    case tripleThreatGoldRare = "form rating ut24 triple_threat gold rare"
    case tripleThreatHeroGoldRare = "form rating ut24 triple_threat_hero gold rare"
    case punditPickGoldRare = "form rating ut24 pundit_pick gold rare"
    case trailblazersGoldRare = "form rating ut24 trailblazers gold rare"
    case uclLiveGoldRare = "form rating ut24 ucl_live gold rare"
    case europaLiveGoldRare = "form rating ut24 europa_live gold rare"
    case conferenceGoldRare = "form rating ut24 conference gold rare"
    case uclWGoldRare = "form rating ut24 ucl_w gold rare"
    case centurionsGoldRare = "form rating ut24 centurions gold rare"
    case centurionsIconGoldRare = "form rating ut24 centurions_icon gold rare"
    case uefaHeroesMenGoldRare = "form rating ut24 uefa_heroes_men gold rare"
    case uefaHeroesWomenGoldRare = "form rating ut24 uefa_heroes_women gold rare"
    case nikeGoldRare = "form rating ut24 nike gold rare"
    case fMomentGoldRare = "form rating ut24 f_moment gold rare"
    case dynamicDuoGoldRare = "form rating ut24 dynamic_duo gold rare"
    case sbcFlashbackGoldRare = "form rating ut24 sbc_flashback gold rare"
    case heroesGoldRare = "form rating ut24 heroes gold rare"
    case goldRare = "form rating ut24 gold rare"
    case goldNonRare = "form rating ut24  gold non-rare"
    case silverRare = "form rating ut24  silver rare"
    case silverNonRare = "form rating ut24  silver non-rare"
    case bronzeRare = "form rating ut24  bronze rare"
    case bronzeNonRare = "form rating ut24  bronze non-rare"
    case ifGoldRare = "form rating ut24 if gold rare"
    case potmEplGoldRare = "form rating ut24 potm_epl gold rare"
    case potmBundesligaGoldRare = "form rating ut24 potm_bundesliga gold rare"
    case potmLigue1GoldRare = "form rating ut24 potm_ligue1 gold rare"
    case potmLaligaGoldRare = "form rating ut24 potm_laliga gold rare"
    case objectiveRewardGoldRare = "form rating ut24 objective_reward gold rare"
    case libertadoresBGoldRare = "form rating ut24 libertadores_b gold rare"
    case sudamericanaGoldRare = "form rating ut24 sudamericana gold rare"
}
