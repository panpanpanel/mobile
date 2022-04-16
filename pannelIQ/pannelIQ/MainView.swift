//
//  MainView.swift
//  pannelIQ
//
//  Created by Jack MacKinnon on 2022-03-11.
//

import SwiftUI

struct MainView: View {
    
    enum TabItems: Hashable {
        case home, notification, insights, control
    }
    
    @State var selectedTab = TabItems.home
    @EnvironmentObject var energyMeasurements: EnergyMeasurements
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .environmentObject(energyMeasurements)
//                .selectedTab(selectedTab)
                .tag(TabItems.home)
                .tabItem {
                    //Image("tab_home")
                    Image(systemName: "house")
                }
            NotificationView()
                .tabItem {
                    //Image("tab_notification")
                    Image(systemName: "bell")
                }
                .tag(TabItems.notification)
            InsightsView()
                .tabItem {
                    //Image("tab_insights")
                    Image("insights")
                }
                .tag(TabItems.insights)
            ControlView()
                .tabItem {
                    //Image("tab_control")
                    Image("bolt")
                }
                .tag(TabItems.control)
        }
        .accentColor(Color("pannelPurple"))
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
