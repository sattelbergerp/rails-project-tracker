require 'rails_helper'

RSpec.feature "ProjectsController", type: :feature do
  describe "Projects index" do
    it "lists the users projects when logged in" do
      user = create_and_login_user()
      projects = [user.projects.create(name:"Test_Project_1"), user.projects.create(name:"Test_Project_2")]

      visit "/projects"
      projects.each do |project|
        expect(page).to have_content(project.name)
      end
    end
    it "does not list other users projects" do
      user = User.create(email: "mail@mail.mail", password: "passwrod")
      user2 = create_and_login_user()
      projects = [user.projects.create(name:"Test_Project_1"), user.projects.create(name:"Test_Project_2")]

      visit "/projects"
      projects.each do |project|
        expect(page).not_to have_content(project.name)
      end
    end
    it "returns 403 when not logged in" do
      visit projects_path
      expect(page.status_code).to be(403)
    end
  end

  describe "Creating Projects" do
    it "Allows the user to create a project" do
      user = create_and_login_user()
      visit new_project_path
      fill_in "project_name", with: "Test Project"
      fill_in "project_description", with: "Test Description"
      click_on "Create Project"
      project = Project.last
      expect(page).to have_current_path(project_path(project))
      expect(project.name).to eq("Test Project")
      expect(project.description).to eq("Test Description")
      expect(project.user).to eq(user)
    end
    it "returns 403 when not logged in" do
      visit new_project_path
      expect(page.status_code).to be(403)
    end
    it "Doesn't let a user create a project with an empty name" do
      user = create_and_login_user()
      visit new_project_path
      fill_in "project_name", with: ""
      fill_in "project_description", with: "Test Description"
      click_on "Create Project"
      expect(page).to have_current_path(projects_path)
    end
  end

  describe "project view" do
    it "Shows the project and task infomation when logged in as the user that created it" do
      user = create_and_login_user()
      project = Project.create(name: 'Test Project', description: "Test Description", user: user)
      project.tasks.create(name: 'Test Task 1', user: user, complete_by: Date.today)
      project.tasks.create(name: 'Test Task 2', user: user)

      visit "/projects/#{project.id}"
      expect(page).to have_content(project.name)
      expect(page).to have_content(project.description)

      project.tasks.each do |task|
        expect(page).to have_content(task.name)
        expect(page).to have_content(task.complete_by_str)
      end
    end
    it "does not let a user view a project they did not create" do
      user = create_and_login_user()
      creator = User.create(name:"a",email:"a",password:"a")
      project = Project.create(name: 'Test Project', description: "Test Description", user: creator)
      visit "/projects/#{project.id}"
      expect(page).to have_current_path("/projects")
    end
  end
  describe "project editing" do
    it "allows the user to edit a project they created" do
      user = create_and_login_user()
      project = Project.create(name:"Initial Name", description:"Initial Description", user: user)
      visit "/projects/#{project.id}/edit"
      fill_in "name", with: "Updated Name"
      fill_in "description", with: "Updated Description"
      click_on "update-project"
      project = Project.find(project.id)
      expect(page).to have_current_path("/projects/#{project.id}")
      expect(project.name).to eq("Updated Name")
      expect(project.description).to eq("Updated Description")
    end
    it "Doesn't allow another user to edit the project" do
      user = create_and_login_user()
      creator = User.create(name:"a",email:"a",password:"a")
      project = Project.create(name: 'Test Project', description: "Test Description", user: creator)
      visit "/projects/#{project.id}/edit"
      expect(page).to have_current_path("/projects")
    end
  end
  describe "project deleting" do
    it "allows the user to delete a project they created" do
      user = create_and_login_user()
      project = Project.create(name:"Name", description:"Description", user: user)
      visit "/projects/#{project.id}"
      click_on "delete-project"
      project2 = Project.find_by(project.id)
      expect(project2).to be(nil)
    end
    it "deletes tasks only associated with itself" do
      user = create_and_login_user()
      project = Project.create(name:"Name", description:"Description", user: user)
      project2 = Project.create(name:"Name2", description:"Description", user: user)
      task1 = project.tasks.create(name:'Task 1', user: user)
      task2 = project.tasks.create(name:'Task 2', user: user)
      task3 = project.tasks.create(name:'Task 3', user: user)
      task1.projects.append(project2)
      task3.projects.append(project2)
      visit "/projects/#{project.id}"
      click_on "delete-project"
      expect(Task.find_by(id: task1.id)).to eq(task1)
      expect(Task.find_by(id: task2.id)).to eq(nil)
      expect(Task.find_by(id: task3.id)).to eq(task3)
    end
  end
end
