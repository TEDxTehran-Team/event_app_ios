//
//  TalkDetailView.swift
//  TEDxConnect
//
//  Created by Tadeh Alexani on 9/10/20.
//  Copyright © 2020 Alexani. All rights reserved.
//

import SwiftUI
import AVKit
import struct Kingfisher.KFImage

struct TalkDetailView: View {
    
    let id: String
    @ObservedObject var viewModel = TalkDetailViewModel()
    @State private var titleLocalizedKey = ""
    
    var body: some View {
        ScrollView(.vertical) {
            ZStack {
                if self.viewModel.statusView == .complete {
                    TalkDetailView.ContentX(viewModel: viewModel)
                }
                if self.viewModel.statusView == .error {
                    ErrorView(errorText: self.viewModel.errorMessage)
                        .onTapGesture {
                            self.viewModel.setup(withId: Int(self.id) ?? 0)
                        }
                }
                if self.viewModel.statusView == .loading {
                    Indicator()
                }
            } // ZStack
            .frame(maxWidth: .infinity)
        } // ScrollView
        .navigationBarTitle(Text(self.viewModel.repository.talk.speakers.map { $0.title }.joined(separator: ", ")))
        .onAppear {
            self.viewModel.setup(withId: Int(self.id) ?? 0)
        }
    }
    
    struct ContentX: View {
        
        @State var isPlaying = false
        @ObservedObject var viewModel: TalkDetailViewModel
        @State var height:CGFloat = 210
        
        var body: some View {
            VStack(alignment: .trailing) {
                Button(action: {
                    isPlaying = true
                    height = 420
                }) {
                    if isPlaying {
                        ZStack {
                            AVPlayerView(videoURL: URL(string: viewModel.repository.talk.videoLink ?? Configuration.placeholderUrl)!)
                                .scaledToFill()
                                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                                .frame(height: height)
                                .padding(.top, 70)
                            Button(action: {
                                if let  url = URL(string: viewModel.repository.talk.videoLink ?? Configuration.placeholderUrl) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                            }){
                                Image(systemName: "globe")
                            }
                            .fixedSize()
                            .frame(width: 30, height: 30, alignment: .top)
                            .padding(.bottom, height)
                        }
                    } else {
                        ZStack {
                            KFImage(URL(string: Images.urlExtension + (self.viewModel.repository.talk.section.image)))
                                .placeholder {
                                    ImagePlaceholder()
                                }
                                .resizable()
                                .scaledToFill()
                                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                                .frame(height: height)
                                .clipped()
                            Rectangle()
                                .fill(Color.gray.opacity(0.35))
                                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                                .frame(height: height)
                                .overlay(
                                    Image(systemName: "play")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50))
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                VStack(alignment: TalkDetailView.alignment,spacing: 10) {
                    Text(self.viewModel.repository.talk.title)
                        .customFont(name: Configuration.shabnam, style: .title3, weight: .bold)
                        .foregroundColor(Colors.primaryDarkGray)
                        .multilineTextAlignment(TalkDetailView.textAlignment)
                    
                    Text(self.viewModel.repository.talk.speakers.map { $0.title }.joined(separator: ", "))
                        .customFont(name: Configuration.shabnamBold, style: .subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(minWidth: 0, idealWidth: 0, maxWidth: .infinity)
                .padding(.horizontal)
                
                VStack(alignment: TalkDetailView.alignment,spacing: 10) {
                    HStack {
                        Text(LocalizedStringKey("Description"))
                            .foregroundColor(.secondary)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom)
                                        .foregroundColor(Colors.primaryRed), alignment: .bottom)
                            .customFont(name: Configuration.shabnam, style: .body)
                        
                        Spacer()
                    }
                    Text(self.viewModel.repository.talk.description ?? "")
                        .foregroundColor(.secondary)
                        .customFont(name: Configuration.shabnamBold, style: .body)
                }
                .environment(\.layoutDirection, Configuration.direction)
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                VStack(spacing: 10) {
                    HStack {
                        Text(LocalizedStringKey("Related Talks"))
                            .foregroundColor(.secondary)
                            .overlay(Rectangle().frame(width: nil, height: 1, alignment: .bottom)
                                        .foregroundColor(Colors.primaryRed), alignment: .bottom)
                            .padding(.horizontal)
                            .customFont(name: Configuration.shabnam, style: .body)
                        
                        Spacer()
                        
                        
                    }
                    
                    TalksRow(talks: self.viewModel.repository.suggestedTalks)
                        .padding(.top)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .layoutPriority(1)
                .environment(\.layoutDirection, Configuration.direction)
            } // VStack
        }
    }
}

struct TalkDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TalkDetailView(id: "0")
    }
}


struct AVPlayerView: UIViewControllerRepresentable {
    
    var videoURL: URL
    let controller = AVPlayerViewController()
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<AVPlayerView>) -> AVPlayerViewController {
        controller.player = AVPlayer(url: videoURL)
        controller.videoGravity = .resizeAspect
        addPeriodicTimeObserver()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
    
    func addPeriodicTimeObserver() {
        self.controller.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (currentTime) in
            if let endTime = self.controller.player?.currentItem?.duration {
                if currentTime == endTime {
                    // Reset the player
                    self.controller.player = AVPlayer(url: self.videoURL)
                    self.addPeriodicTimeObserver()
                }
            }
        })
    }
}
