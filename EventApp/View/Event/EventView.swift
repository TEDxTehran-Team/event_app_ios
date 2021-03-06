//
//  EventView.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 9/25/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import SwiftUI

struct EventView: View {
  
  @State private var selectedTab = 0
  
  @ObservedObject var eventDetailViewModel: EventViewModel
  @ObservedObject var dayViewModel: DayViewModel
  
  var body: some View {
    
    VStack(spacing: 8) {
      
      TabBar(selectedTab: self.$selectedTab)
        .padding(.vertical, 4)
      
      if self.selectedTab == 0 {
        
        EventDetailView(viewModel: eventDetailViewModel)
        
      } else {
        
        TimeTableView(viewModel: dayViewModel)
          .background(Colors.primaryBackground)
          
      }
      
    }
    .background(Colors.primaryRed.edgesIgnoringSafeArea(.all))
  }
}

struct EventView_Previews: PreviewProvider {
  static var previews: some View {
    EventView(eventDetailViewModel: EventViewModel(), dayViewModel: DayViewModel())
  }
}
