module TeamCowboy
  module User
    
    def me
      params = { 
        userToken: TeamCowboy.user_token,
      }

      get("User_Get", params).body
    end

    def teams
      params = { 
        userToken: TeamCowboy.user_token,
      }

      get("User_GetTeams", params).body
    end
          
  end
end