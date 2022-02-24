
import SwiftUI

struct ErrorAlert: ViewModifier {
    
    @Binding var showAlert: Bool
    let alertMessage: String
    
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}
