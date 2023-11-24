import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isSoundOn") private var isSoundOn = true
    @AppStorage("rollAnimationOn") private var rollAnimationOn = true
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    @AppStorage("aiOpposerSpeed") private var aiOpposerSpeed: Double = 0.8
    @State private var showResetAlert: Bool = false
    
    var appVersionAndBuild: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            return "Version \(version)"
        }
        return "Unknown Version"
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .edgesIgnoringSafeArea(.all)
            List {
                Section(header: Text("SOUND AND VIBRATION")) {
                    Toggle(isOn: $isSoundOn, label: {
                        Text("Sound")
                    })
                    
                    Toggle(isOn: $isVibrationOn, label: {
                        Text("Vibration")
                    })
                }
                .textCase(nil)
                Section(header: Text("GAME SETTINGS")) {
                    Toggle(isOn: $rollAnimationOn, label: {
                        Text("Roll animation")
                    })
                    VStack(alignment: .leading) {
                        Text("Virtual player speed")
                        Slider(value: $aiOpposerSpeed, in: 0.5...2.0, step: 0.1) {
                            Text("AI Opposer Speed Slider")
                        }
                        
                        HStack {
                            Spacer()
                            Text("\(aiOpposerSpeed, specifier: "%.1f")s")
                        }
                    }
                }
                .textCase(nil)
            }
            .listStyle(GroupedListStyle())
            VStack(spacing: 8) {
                Spacer()
                Text(appVersionAndBuild)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .background(.clear)
                    .edgesIgnoringSafeArea(.horizontal)
                
                Button(action: {
                    self.showResetAlert = true
                }) {
                    Text("Reset Stats")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .background(.clear)
                .edgesIgnoringSafeArea(.horizontal)
            }
            .padding(.vertical, 16)
        }
        
        .alert(isPresented: $showResetAlert) {
            Alert(title: Text("Reset Stats?"),
                  message: Text("All stats will be deleted and are non-recoverable. Are you sure?"),
                  primaryButton: .default(Text("Confirm"), action: {
                StatsModel.shared.clearUserDataFromiCloud()
            }),
                  secondaryButton: .cancel())
        }
    }
}
