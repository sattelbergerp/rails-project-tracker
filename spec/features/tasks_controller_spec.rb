require 'rails_helper'

RSpec.feature "TasksController", type: :feature do
  describe "task index" do
    it "Allows a logged in user to view only their tasks" do
      user = create_and_login_user('user','pass')
      user2 = User.create(email:'a@b.c',password:'afgjuf')
      tasks = [Task.create(name:"Task 1", user:user, complete_by: Date.jd(Date.today.jd-5)),
               Task.create(name:"Task 2", user:user, completed:true),
               Task.create(name:"Task 4", user:user, complete_by: Date.jd(Date.today.jd+1))]
      dates = ['5 days ago', '', 'in 1 day']
      Task.create(name:"Task 3", user:user2)
      visit "/tasks"
      all('.list-group-item').each_with_index do |item, index|
        expect(item).to have_content(tasks[index].name)
        expect(item).to have_content(dates[index])
        expect([:class].include?("task-completed")).to eq(!!tasks[index].completed)#Rspec treats nil differed from false
      end
      expect(page).not_to have_content("Task 3")
    end
  end
  describe "new task" do
    it "Allows a logged in user to create a new task" do
      date = Date.today
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      project2 = Project.create(name: "Project 2", user:user)
      project3 = Project.create(name: "Project 3", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: date.rfc822
      check "completed"
      check "project_2"
      check "project_3"
      click_on "create-task"

      task = Task.last
      expect(task.name).to eq("Test Task")
      expect(task.description).to eq("Test Description")
      expect(task.completed).to eq(true)
      expect(task.complete_by.strftime('%s')).to eq(date.strftime('%s'))
      expect(task.projects.include?(project2)).to eq(true)
      expect(task.projects.include?(project3)).to eq(true)
      expect(task.projects.include?(project1)).to eq(false)
      expect(page).to have_current_path("/tasks/#{task.id}")
    end
    it "Does not allow the name to be blank" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      visit "/tasks/new"
      fill_in "name", with: ""
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: Date.today.rfc822
      check "project_1"
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "Requires at least one project to be checked" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Name"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: Date.rfc822
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "does not allow an invalid date" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      visit "/tasks/new"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: "sdfgh"
      check "project_1"
      click_on "create-task"
      expect(page).to have_current_path("/tasks/new")
    end
    it "Does not allow a user who is not logged in to create a new task" do
      visit "/tasks/new"
      expect(page).to have_current_path("/")
    end
  end

  describe "view task" do
    it "Allows the user to view a task they created" do
      date = Date.jd(Date.today.jd+5)
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      task = project1.tasks.create(name: "Sample Task", description: "Sample Description", complete_by: date, completed: true, user:user)
      project2 = task.projects.create(name: "Project 2", user:user)
      visit "/tasks/#{task.id}"

      expect(page).to have_content("Sample Task")
      expect(page).to have_content("Sample Description")
      expect(page).to have_content("5 day(s) from now")
      expect(page).to have_content("Completed: Yes")
      expect(page).to have_content("Project 1")
      expect(page).to have_content("Project 2")
    end
    it "shows completed_by as today if the complete_by date is today" do
      user = create_and_login_user('user','pass')
      date = Date.jd(Date.today.jd)
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: date, user:user)
      visit "/tasks/#{task.id}"
      expect(page).to have_content("today")
    end
    it "shows completed_by as x days ago if the complete_by date is erlier than today" do
      user = create_and_login_user('user','pass')
      date = Date.jd(Date.today.jd-5)
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: date, user:user)
      visit "/tasks/#{task.id}"
      expect(page).to have_content("5 day(s) ago")
    end
    it "does not let a user who did not create it view it" do
      user = create_and_login_user('user','pass')
      creator = User.create(name:'a',email:'a',password:'a')
      task = Task.create(name: "Sample Task", description: "Sample Description", complete_by: Date.today, user:creator)
        visit "/tasks/#{task.id}"
        expect(page).to have_current_path("/tasks")
    end
  end
  describe "edit task" do
    it "Allows a user to edit their own task" do
      user = create_and_login_user('user','pass')
      task = Task.create(name: "Initial Name", description: "Initial Description", complete_by: Date.today, completed: true,user:user)
      project1 = task.projects.create(name: "Project 1", user:user)
      project2 = Project.create(name: "Project 2", user:user)
      project3 = task.projects.create(name: "Project 3", user:user)
      visit "/tasks/#{task.id}/edit"
      fill_in "name", with: "Updated Name"
      fill_in "description", with: "Updated Description"
      fill_in "complete-by", with: Date.rfc822 # Returns date of Mon, 1 Jan -4712
      uncheck "project_1"
      check "project_2"
      uncheck "completed"
      click_on "update-task"
      expect(page).to have_current_path("/tasks/#{task.id}")
      task.reload
      expect(task.name).to eq("Updated Name")
      expect(task.description).to eq("Updated Description")
      expect(task.completed).to eq(false)
      expect(task.complete_by).to eq(Date.rfc822)
      expect(task.projects.include?(project1)).to eq(false)
      expect(task.projects.include?(project2)).to eq(true)
      expect(task.projects.include?(project3)).to eq(true)
    end
    it "requires there to be a name" do
      user = create_and_login_user('user','pass')
      task = Task.create(name: "Initial Name", description: "Initial Description", complete_by: Date.today, user:user)
      project1 = task.projects.create(name: "Project 1", user:user)
      visit "/tasks/#{task.id}/edit"
      fill_in "name", with: ""
      click_on "update-task"
      expect(page).to have_current_path("/tasks/#{task.id}/edit")
    end
    it "requires at least one project" do
      user = create_and_login_user('user','pass')
      task = Task.create(name: "Initial Name", description: "Initial Description", complete_by: Date.today, user:user)
      project1 = task.projects.create(name: "Project 1", user:user)
      visit "/tasks/#{task.id}/edit"
      uncheck "project_1"
      click_on "update-task"
      expect(page).to have_current_path("/tasks/#{task.id}/edit")
    end
    it "does not allow an invalid date" do
      user = create_and_login_user('user','pass')
      project1 = Project.create(name: "Project 1", user:user)
      task = project1.tasks.create(name:'a', user:user)
      visit "/tasks/#{task.id}/edit"
      fill_in "name", with: "Test Task"
      fill_in "description", with: "Test Description"
      fill_in "complete-by", with: "sfhdgjh"
      check "project_1"
      click_on "update-task"
      expect(page).to have_current_path("/tasks/#{task.id}/edit")
    end
    it "only lets a user edit a project they created" do
      user = create_and_login_user('user','pass')
      creator = User.create(name:'a',email:'a',password:'a')
      task = Task.create(name: "Initial Name", description: "Initial Description", complete_by: Date.today, user:creator)
      visit "/tasks/#{task.id}/edit"
      expect(page).to have_current_path("/tasks")
    end
  end
  describe "delete task" do
    it "deletes the task" do
      user = create_and_login_user('user','pass')
      task = Task.create(name: "Initial Name", description: "Initial Description", complete_by: Date.today, user:user)
      visit "/tasks/#{task.id}"
      click_on "delete-task"
      expect(page).to have_current_path("/tasks")
      expect(Task.find_by(id: task.id)).to eq(nil)
    end
  end
end
