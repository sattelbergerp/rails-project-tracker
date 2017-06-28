module AccountHelpers
  #Visits the signup page, filles in the form, and clicks submit
  #Takes a usernma and password, then returns the created user (Assuming User.last is the created user)
  def create_and_login_user(username='45@54.68', password='123456')
    visit new_user_registration_path
    fill_in('user_email', with: username)
    fill_in('user_password', with: password)
    fill_in('user_password_confirmation', with: password)
    click_on "Sign up"
    User.last
  end
end
