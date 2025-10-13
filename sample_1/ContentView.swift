import SwiftUI
struct ContentView: View{
    @State private var count = 0
    
    var body: some View{
        VStack(spacing: 20){
            if(count == 10){
                Text("👍すごい!")
                Button("カウントリセット"){
                    count = 0
                }
                .font(.title3)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }else{
                Text("カウント: \(count)")
                    .font(.largeTitle)
                    .bold()
                Button("カウントアップ"){
                    count += 1
                }
                .font(.title2)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
