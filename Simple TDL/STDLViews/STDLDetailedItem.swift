//
//  Simple TDL
//
//  Created by Mariusz Przeczek on 27.11.23.
//

import SwiftUI

struct STDLDetailedItem: View {
    let category: String
    let value: String
    
    var body: some View {
        HStack (alignment: .top) {
            Text(category)
                .frame(width: UIScreen.main.bounds.size.width * 0.3,
                       alignment: .trailing)
                .bold()
            
            Text(value)
                .frame(maxWidth: .infinity,
                       alignment: .leading)
        }
        .frame(width: UIScreen.main.bounds.size.width , alignment: .leading)
        .padding(.vertical, 1)
    }
}
