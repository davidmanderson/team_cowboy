module TeamCowboy
  module Team
    
    def team(team_id: team_id)
      params = { 
        userToken:  self.user_token,
        teamId:     team_id
      }

      get("Team_Get", params)
    end
          
  end
end