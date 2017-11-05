module TeamCowboy
    module Auth
      
      def authenticate(username, password)
        params = { 
          username: username,
          password: password,
        }
        
        result = post("Auth_GetUserToken", params, secure: true)
        if result.success 
          TeamCowboy.user_token = result.body.token
        end
      end
            
    end
  end