module TeamCowboy
  module Team
    
    def team(team_id:)
      params = { 
        userToken:  self.user_token,
        teamId:     team_id
      }

      get("Team_Get", params)
    end

    def messages(team_id:, page: nil, count: nil, sort_by: nil, sort_direction: nil)
      params = { 
        userToken:      self.user_token,
        teamId:         team_id,
        offset:         page,
        qty:            count,
        sort_by:        sort_by, # title|lastUpdated|type|
        sort_direction: sort_direction, # ASC|DESC
      }

      get("Team_GetMessages", params)
    end

    def roster(team_id:, user_id: nil, include_inactive:nil, sort_by: nil, sort_direction: nil)
      params = {
        userToken:      self.user_token,
        teamId:         team_id,
        userId:         user_id,
        sort_by:        sort_by, # firstName|playerType|sex
        sort_direction: sort_direction, # ASC|DESC
      }

      get("Team_GetRoster", params)
    end
          
  end
end