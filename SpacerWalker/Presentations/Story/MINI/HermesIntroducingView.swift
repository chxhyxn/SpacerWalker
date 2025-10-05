//  Copyright © 2025 NASA INTERNATIONAL SPACE APPS CHALLENGE Team SPACEWALK. All rights reserved.

import SwiftUI

struct HermesIntroducingView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                
                VStack(spacing: 16) {
                    HStack {
                        HStack(spacing: 4) {
                            Image("hermes")
                                .resizable()
                                .frame(
                                    width: 52,
                                    height: 42
                                )
                            
                            Text("Hermes's Message")
                                .font(.oneMobile20)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(Color.hermes)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        
                        Spacer()
                        
                        Button {
                            isPresented = false
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.gray)
                                .frame(width: 44, height: 44)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    
                    Image("hermesImage")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 16)
                    
                    Text("Hi! I'm HERMES, the little space weather fairy!")
                        .font(.oneMobile24)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 28)
                .frame(
                    width: min(geometry.size.width * 0.85, 800),
                    height: min(geometry.size.height * 0.7, 600)
                )
                .background(Color(red: 0.9, green: 0.95, blue: 0.93))
                .clipShape(RoundedRectangle(cornerRadius: 24))
            }
        }
    }
}
