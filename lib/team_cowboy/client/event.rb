module TeamCowboy
  module Event
    
    def event(team_id:, event_id:, include_rsvp_info: nil)
      params = { 
        userToken:        self.user_token,
        teamId:           team_id,
        eventId:          event_id,
        includeRSVPInfo:  include_rsvp_info,
      }

      get("Event_Get", params)
    end

    def attendance(team_id:, event_id:)
      params = { 
        userToken:        self.user_token,
        teamId:           team_id,
        eventId:          event_id,
      }

      get("Event_GetAttendanceList", params)
    end

    def save_event_rsvp(team_id:, event_id:, status:, extra_male: nil, extra_female: nil, comments: nil, user_id: nil)
      params = { 
        userToken:    self.user_token,
        teamId:       team_id,
        eventId:      event_id,
        status:       status, # yes|maybe|available|no|noresponse

      }
      params[:'addlMale'] = extra_male if extra_male       # integer
      params[:'addlFemale'] = extra_female if extra_female # integer
      params[:'comments'] = comments if comments
      params[:'rsvpAsUserId'] = user_id if user_id

      post("Event_SaveRSVP", params)
    end
          
  end
end