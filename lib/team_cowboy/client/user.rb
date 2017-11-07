module TeamCowboy
  module User
    
    def me
      params = { 
        userToken: TeamCowboy.user_token,
      }

      get("User_Get", params)
    end

    def teams
      params = { 
        userToken: TeamCowboy.user_token,
      }

      get("User_GetTeams", params)
    end

    def events(team_id: nil, include_rsvp_info: nil, start_date: nil, end_date: nil)
      params = {
        userToken:        TeamCowboy.user_token,
        teamId:           team_id,
        includeRSVPInfo:  include_rsvp_info,
        startDateTime:    start_date, # YYYY-MM-DD HH:MM:SS
        endDateTime:      end_date, # YYYY-MM-DD HH:MM:SS
      }
      get("User_GetTeamEvents", params)
    end

    def messages(team_id: nil, message_id: nil, offset: nil, quantity: nil, sort_by: nil, sort_direction: nil)
      params = {
        userToken:      TeamCowboy.user_token,
        teamId:         team_id,
        messageId:      message_id,
        offset:         offset, 
        qty:            quantity,
        sortBy:         sort_by, 
        sortDirection:  sort_direction,
      }
      get("User_GetTeamEvents", params)
    end
          
  end
end