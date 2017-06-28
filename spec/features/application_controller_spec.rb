require 'rails_helper'

RSpec.feature "ApplicationController", type: :feature do
  describe "Homepage" do
    it "loads the homepage" do
      visit root_path
      expect(page).to have_content("Project Tracker")
      expect(page).to have_content("Login")
      expect(page).to have_content("Signup")
    end
  end
  describe "Signup" do
    it "Sends the user to their projects page" do
      visit  new_user_registration_path
      fill_in('user_email', with: 'email@email.test')
      fill_in('user_password', with: 'Test Password')
      fill_in('user_password_confirmation', with: 'Test Password')
      click_on "Sign up"
      expect(page).to have_current_path("/projects")
    end
    it "Does not allow a user with an empty email" do
      visit new_user_registration_path
      fill_in('user_email', with: '')
      fill_in('user_password', with: 'Test Password')
      fill_in('user_password_confirmation', with: 'Test Password')
      click_on "Sign up"
      expect(page).to have_current_path(user_registration_path)
    end
    it "Does not allow a user with an empty password" do
      visit new_user_registration_path
      fill_in('user_email', with: '')
      fill_in('user_password', with: '')
      fill_in('user_password_confirmation', with: '')
      click_on "Sign up"
      expect(page).to have_current_path(user_registration_path)
    end
  end

  describe "Login" do
    it "Sends the user to their projects page" do
      User.create(email: "e@e.e", password: "Password1")
      visit new_user_session_path
      fill_in('user_email', with: 'e@e.e')
      fill_in('user_password', with: 'Password1')
      click_on "Log in"
      expect(page).to have_current_path("/projects")
    end
    it "Does not allow the user to use an incorrect username" do
      visit new_user_session_path
      fill_in('user_email', with: 'a@e.e')
      fill_in('user_password', with: 'Password1')
      click_on "Log in"
      expect(page).to have_current_path(user_session_path)
    end
    it "Does not allow the user to use an incorrect password" do
      visit new_user_session_path
      fill_in('user_email', with: 'e@e.e')
      fill_in('user_password', with: 'Password2')
      click_on "Log in"
      expect(page).to have_current_path(user_session_path)
    end
    it "Redirects to the projects index if already signed in" do
      user = create_and_login_user('user@a.a','password')
      visit new_user_session_path
      expect(page).to have_current_path("/projects")
    end
  end

end
