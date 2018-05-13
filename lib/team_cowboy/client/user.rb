module TeamCowboy
  module User
    
    def user
      params = { 
        userToken: self.user_token,
      }

      get("User_Get", params)
    end

    def teams
      params = { 
        userToken: self.user_token,
      }

      get("User_GetTeams", params)
    end

    def events(team_id: nil, include_rsvp_info: nil, start_date: nil, end_date: nil)
      params = {
        userToken:        self.user_token,
        teamId:           team_id,
        includeRSVPInfo:  include_rsvp_info,
        startDateTime:    start_date, # YYYY-MM-DD HH:MM:SS
        endDateTime:      end_date, # YYYY-MM-DD HH:MM:SS
      }
      get("User_GetTeamEvents", params)
    end
              
  end
end