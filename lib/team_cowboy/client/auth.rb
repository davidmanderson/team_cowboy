module TeamCowboy
    module Auth
      
      def authenticate(username:, password:)
        params = { 
          username: username,
          password: password,
        }
        
        result = post("Auth_GetUserToken", params, secure: true)
        TeamCowboy.user_token = result.token if result
        result
      end
            
    end
  end