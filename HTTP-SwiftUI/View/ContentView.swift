import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            Text("UsersApiCount - \(viewModel.users.count)")
            ScrollView {
                ForEach(viewModel.users) { user in
                    LazyVStack {
                        Text(user.name)
                        Text(user.email)
                    }.padding()
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color.yellow)
                        .border(Color.black, width: 2)
                }
            }
            .modifier(ErrorAlert(
                showAlert: $viewModel.showAlert,
                alertMessage: viewModel.errorAlertMessage
            ))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
