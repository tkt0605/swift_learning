import SwiftUI
struct MyNewView: View {
    var body: some View{
        Text("Hello, iOS World !!")
            .font(.title)
            .padding()
    }
}
@main //@mainがついている関数を一番に表示させている。
struct HelloApp: App {
    var body: some Scene{
        WindowGroup{
//            MyNewView()
            ContentView()
        }
    }
}
