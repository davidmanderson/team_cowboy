module TeamCowboy
  module Message
    
    def message(message_id:, team_id:, load_comments: nil)
      params = { 
        userToken:    self.user_token,
        messageId:    message_id, 
        teamId:       team_id,
        loadComments: load_comments,
      }

      get("Message_Get", params)
    end

    def save_message(team_id:, title:, body:, message_id: nil, is_pinned: nil, send_notifications: nil, is_hidden: nil, allow_comments: nil)
      params = { 
        userToken:          self.user_token,
        teamId:             team_id, 
        title:              title,
        body:               body,
      }
      params[:messageId] = message_id if message_id
      params[:isPinned] = is_pinned unless is_pinned.nil?
      params[:sendNotifications] = send_notifications unless send_notifications.nil?
      params[:allowComments] = allow_comments unless allow_comments.nil?

      post("Message_Save", params)
    end

    def save_message_comment(message_id:, team_id:, comment:)
      params = { 
        userToken:  self.user_token,
        messageId:  message_id,
        teamId:     team_id, 
        comment:    comment,
      }

      post("MessageComment_Add", params)
    end
          
  end
end