module TeamCowboy
  module Event
    
    def event(team_id:, event_id:, include_rsvp_info: nil)
      params = { 
        userToken:        TeamCowboy.user_token,
        teamId:           team_id,
        eventId:          event_id,
        includeRSVPInfo:  include_rsvp_info,
      }

      get("Team_Get", params)
    end

    def save_event_rsvp(team_id:, event_id:, status:, add_male: nil, add_femail: nil, comments: nil)
      params = { 
        userToken:  TeamCowboy.user_token,
        teamId:     team_id,
        eventId:    event_id,
        status:     status, # yes|maybe|available|no|noresponse
        addMale:    add_male, # integer
        addFemale:  add_female, # integer
        comments:   comments
      }

      post("Team_Get", params)
    end
          
  end
end