def sign_in(admin = false)
  post '/users', params: {
    user: {
      username: 'testing',
      email: 'test@example.com',
      password: 'Abcdef@123'
    }
  }
  user = User.find_by(username: 'testing')
  user.toggle!(:admin) if admin
  return user
end

def new_article
  sign_in
  post '/articles', params: {
    article: {
      title: 'testing',
      description: 'article for testing only and should not be considered correct'
    }
  }
  return Article.find_by(title: 'testing')
end
