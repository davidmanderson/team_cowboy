module TeamCowboy
    module Auth
      
      def authenticate(username:, password:)
        params = { 
          username: username,
          password: password,
        }
        
        post("Auth_GetUserToken", params, secure: true)
      end
            
    end
  end