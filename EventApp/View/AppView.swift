//
//  AppView.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 8/8/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import SwiftUI


enum AppTabViewItem : String{
    case home
    case news
    case gallery
    case talks
    case profile
}

struct AppView: View {
    
    @ObservedObject  var eventViewModel = EventViewModel()
    @ObservedObject  var dayViewModel = DayViewModel()
    @ObservedObject var newsViewModel = NewsViewModel()
    @ObservedObject var albumViewModel = AlbumViewModel()
    @ObservedObject var speakerViewModel = SpeakerViewModel()
    @ObservedObject var talkViewModel = TalkViewModel()
    @ObservedObject var featuredTalkViewModel = FeaturedTalkViewModel()
    
    
    @State private var tabSelected:AppTabViewItem = .home
    @State var isShowAbout = false
    
    var body: some View {
        
        TabView(selection: self.$tabSelected) {
            
            NavigationView {
                VStack {
                    HomeTabUIView(eventViewModel: self.eventViewModel,dayViewModel: self.dayViewModel, speakerViewModel: self.speakerViewModel)
                }
                .navigationBarTitle(Text(LocalizedStringKey("Home")),displayMode: .inline)
                
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tag(AppTabViewItem.home)
            .tabItem {
                Image(systemName: "house")
                Text(LocalizedStringKey("Home"))
            }
            
            TalksView(talkViewModel: self.talkViewModel, featuredTalkViewModel: self.featuredTalkViewModel)
                .tag(AppTabViewItem.talks)
                .tabItem {
                    Image(systemName: "music.mic")
                    Text(LocalizedStringKey("Talks"))
                }
            
            
            VStack {
                GalleryView(viewModel: self.albumViewModel)
            }
            .tag(AppTabViewItem.gallery)
            .tabItem {
                Image(systemName: "photo.on.rectangle")
                Text(LocalizedStringKey("Gallery"))
            }
            
            NewsView(viewModel: self.newsViewModel)
                .tag(AppTabViewItem.news)
                .tabItem {
                    Image(systemName: "newspaper")
                    Text(LocalizedStringKey("News"))
                    
                }
            
                ProfileTabBar()
                .tag(AppTabViewItem.profile)
                .tabItem {
                    Image(systemName: "person")
                    Text(LocalizedStringKey("Profile"))
                }
            
            
        }.accentColor(Colors.primaryRed)
    }
    
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppView()
        }
    }
}
