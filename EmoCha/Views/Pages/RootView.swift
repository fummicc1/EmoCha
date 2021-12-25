import SwiftUI
import Application

struct RootView: View {

    @ObservedObject var model: RootModel

    var body: some View {
        VStack {
            if model.isLoggedIn {
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
