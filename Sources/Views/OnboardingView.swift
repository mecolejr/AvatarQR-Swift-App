import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct OnboardingView: View {
    @Binding var isOnboardingCompleted: Bool
    @State private var currentPage = 0
    @State private var animateIcon = false
    @State private var animateTitle = false
    @State private var animateDescription = false
    @State private var animateButtons = false
    
    // Define onboarding pages
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to AvatarQR",
            description: "Create, customize, and share unique avatars with friends using QR codes.",
            imageName: "person.crop.circle.fill.badge.plus",
            backgroundColor: .blue
        ),
        OnboardingPage(
            title: "Customize Your Avatar",
            description: "Choose from a variety of hairstyles, facial features, accessories, and colors to create your perfect avatar.",
            imageName: "person.fill.viewfinder",
            backgroundColor: .purple
        ),
        OnboardingPage(
            title: "Share with QR Codes",
            description: "Generate QR codes for your avatars and share them with friends. Scan QR codes to import avatars.",
            imageName: "qrcode",
            backgroundColor: .green
        ),
        OnboardingPage(
            title: "Save Multiple Avatars",
            description: "Create and save multiple avatars for different occasions or moods.",
            imageName: "person.3.fill",
            backgroundColor: .orange
        )
    ]
    
    var body: some View {
        ZStack {
            // Background color based on current page
            pages[currentPage].backgroundColor
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .opacity(animateButtons ? 1 : 0)
                }
                
                Spacer()
                
                // Page content
                #if os(iOS)
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        pageView(for: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .onChange(of: currentPage) { _ in
                    resetAnimations()
                    animateContent()
                }
                #else
                // macOS alternative
                VStack {
                    pageView(for: pages[currentPage])
                    
                    // Page indicators for macOS
                    HStack(spacing: 10) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.white : Color.white.opacity(0.5))
                                .frame(width: 10, height: 10)
                                .onTapGesture {
                                    withAnimation {
                                        currentPage = index
                                    }
                                }
                        }
                    }
                    .padding()
                    .opacity(animateButtons ? 1 : 0)
                }
                #endif
                
                Spacer()
                
                HStack {
                    // Back button (except on first page)
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .font(.headline)
                        .foregroundColor(pages[currentPage].backgroundColor)
                        .padding()
                        .padding(.horizontal, 30)
                        .background(Color.white)
                        .cornerRadius(30)
                        .shadow(radius: 5)
                        .opacity(animateButtons ? 1 : 0)
                        .offset(x: animateButtons ? 0 : -20)
                    }
                    
                    Spacer()
                    
                    // Next/Get Started button
                    Button(currentPage == pages.count - 1 ? "Get Started" : "Next") {
                        if currentPage == pages.count - 1 {
                            completeOnboarding()
                        } else {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }
                    .font(.headline)
                    .foregroundColor(pages[currentPage].backgroundColor)
                    .padding()
                    .padding(.horizontal, 30)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(radius: 5)
                    .opacity(animateButtons ? 1 : 0)
                    .offset(x: animateButtons ? 0 : 20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
        }
        .onAppear {
            animateContent()
        }
    }
    
    private func pageView(for page: OnboardingPage) -> some View {
        VStack(spacing: 20) {
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.white)
                .scaleEffect(animateIcon ? 1 : 0.5)
                .opacity(animateIcon ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0).delay(0.1), value: animateIcon)
            
            Text(page.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .opacity(animateTitle ? 1 : 0)
                .offset(y: animateTitle ? 0 : 20)
                .animation(.easeOut(duration: 0.4).delay(0.3), value: animateTitle)
            
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .opacity(animateDescription ? 1 : 0)
                .offset(y: animateDescription ? 0 : 20)
                .animation(.easeOut(duration: 0.4).delay(0.5), value: animateDescription)
        }
        .padding()
    }
    
    private func completeOnboarding() {
        withAnimation {
            isOnboardingCompleted = true
        }
    }
    
    private func resetAnimations() {
        animateIcon = false
        animateTitle = false
        animateDescription = false
        animateButtons = false
    }
    
    private func animateContent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            animateIcon = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            animateTitle = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animateDescription = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            animateButtons = true
        }
    }
}

// Model for onboarding page data
struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

#if DEBUG
@available(macOS 11.0, iOS 14.0, *)
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingCompleted: .constant(false))
    }
}
#endif
