module TeamCowboy
  module Team
    
    def team(team_id)
      params = { 
        userToken:  TeamCowboy.user_token,
        teamId:     team_id
      }

      get("Team_Get", params)
    end
          
  end
end