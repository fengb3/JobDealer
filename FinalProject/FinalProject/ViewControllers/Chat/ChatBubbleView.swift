//
//  ChatView.swift
//  FinalProject
//
//  Created by 生物球藻 on 4/24/23.
//

import SwiftUI

struct ChatMessage : Hashable
{
    var message:String
    var isCurrentUser: Bool
    var id: Int
    private static var count : Int = 0;
    
    init(_ contentMessage: String, _ isCurrentUser: Bool) {
        self.message = contentMessage
        self.isCurrentUser = isCurrentUser
        id = ChatMessage.count
        
        ChatMessage.count += 1
    }
}

struct ChatBubbleView: View {
    var chatMessage : ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15)
        {
            if(chatMessage.isCurrentUser)
            {
                Spacer()
            }
            Text(chatMessage.message)
                .padding(10)
                .foregroundColor(chatMessage.isCurrentUser ? Color.white : Color.black)
                .background(chatMessage.isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
                .cornerRadius(10)
            if(!chatMessage.isCurrentUser)
            {
                Spacer()
            }
        }
        .padding([.horizontal], 20)
        .padding([.vertical], 10)
    }
}

struct ChatBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubbleView(chatMessage: ChatMessage("hello this is a super long text", true))
    }
}
