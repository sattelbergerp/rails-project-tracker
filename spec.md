# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [X] Include at least one has_many relationship (project as many project messages)
- [X] Include at least one belongs_to relationship (Project belongs to User)
- [X] Include at least one has_many through relationship (Project and tasks are many-to many)
- [ ] The "through" part of the has_many through includes at least one user submittable attribute (So cant really see a way to do this with my current application that would make any degree of sense. 100% my bad for not reading this file first thing)
- [X] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
- [X] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
- [X] (Can it use accepts nested attributes for?)Include a nested form writing to an associated model using a custom attribute writer (form URL, model name e.g. /recipe/new, Item)
- [X] Include signup (Devise)
- [X] Include login (Devise)
- [X] Include logout (Devise)
- [X] Include third party signup/login (Devise+OmniAuth to github)
- [X] Include nested resource show or index (URL e.g. users/2/recipes)
- [X] Include nested resource "new" form (URL e.g. recipes/1/ingredients)
- [X] Include form display of validation errors (form URL e.g. /recipes/new)

Confirm:
- [X] The application is pretty DRY
- [X] Limited logic in controllers
- [X] Views use helper methods if appropriate
- [X] Views use partials if appropriate
