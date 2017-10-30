module TeamCowboy
    module Auth
      
      def authenticate(username, password)
        params = { 
          username: username,
          password: password,
          method: "Auth_GetUserToken",
        }
        post("", params).results
      end
            
    end
  end