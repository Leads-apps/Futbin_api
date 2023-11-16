import SwiftUI
import Futbin_api
import Kingfisher

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Page count:")
                
                Spacer()
                
                Text("\(viewModel.numberOfPage)")
            }
            .font(.title)
            .padding()
            
            List(viewModel.players, id: \.playerImage) { player in
                ListRow(player: player)
            }
        }
    }
}

struct ListRow: View {
    
    let player : Player
    
    var body: some View {
        VStack {
            HStack {
                KFImage(URL(string: player.playerImage))
                    .resizable()
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    HStack {
                        KFImage(URL(string: player.clubImage))
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(player.clubName)
                    }
                    
                    HStack {
                        KFImage(URL(string: player.natioalityFlag))
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(player.nationality)
                    }
                    
                    HStack {
                        KFImage(URL(string: player.leagueImage))
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text(player.leagueName)
                    }
                }
                .font(.caption)
                
                VStack {
                    HStack {
                        Text("Rate")
                        
                        Spacer()
                        
                        Text("\(player.rate)")
                    }
                    
                    HStack {
                        Text("Position")
                        
                        Spacer()
                        
                        Text(player.position)
                        
                    }
                    
                    HStack {
                        Text("Price")
                        
                        Spacer()
                        
                        Text(player.playerPrice)
                    }
                    
                    HStack {
                        Text("Skills ★")
                        
                        Spacer()
                        
                        Text("\(player.skills)")
                    }
                    
                    HStack {
                        Text("Weak Foot ★")
                        
                        Spacer()
                        
                        Text("\(player.weakFoot)")
                    }
                    
                    HStack {
                        Text("Attack | Defense")
                        
                        Spacer()
                        
                        Text(player.attackDefense)
                    }
                    
                    HStack {
                        Text("Pace")
                        
                        Spacer()
                        
                        Text("\(player.pace)")
                    }
                    
                    HStack {
                        Text("Shooting")
                        
                        Spacer()
                        
                        Text("\(player.shooting)")
                    }
                    
                    HStack {
                        Text("Passing")
                        
                        Spacer()
                        
                        Text("\(player.passing)")
                    }
                    
                    HStack {
                        Text("Dribbling")
                        
                        Spacer()
                        
                        Text("\(player.dribbling)")
                    }
                    
                    HStack {
                        Text("Defending")
                        
                        Spacer()
                        
                        Text("\(player.defending)")
                    }
                    
                    HStack {
                        Text("Physicality")
                        
                        Spacer()
                        
                        Text("\(player.physicality)")
                    }
                    
                    HStack {
                        Text("Height | Weight")
                        
                        Spacer()
                        
                        Text(player.heightWeight)
                    }
                }
                .font(.caption2)
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .center) {
                    Text("Popularity")
                    
                    Text("\(player.physicality)")
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Base Status")
                    
                    Text("\(player.baseStats)")
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Game Status")
                    
                    Text("\(player.gameStats)")
                }
            }
            .font(.caption)
        }
    }
}
