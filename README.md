# ResumeCompanion CMS

This is a CMS engine provide by ResumeCompanion.

## Install

### 1. Add CMS To Gemfile

```ruby
if File.exists?("your-path/cms") && File.directory?("your-path/cms") && ENV['REMOTE_GEM'] != "true"
  gem 'cms', "0.0.2", :path => 'your-path/cms'
else
  gem 'cms', "0.0.2", :git => 'git@github.com:resumecompanion/cms.git'
end
```

This is an easier way for development. But, when you commit code in main application, **don't forget** to check if you still use the gem at local. **It's very important!**

### 2. Install The Gem

```ruby
# When you want install the gem by local
bundle install

# When you want install the gem by github
REMOTE_GEM=true bundle install
```

When you are developing, you can enter ```bundle install```, but, **before you commit the code in main appliaction**, please enter ```REMOTE_GEM=true bundle install```.

### 3. Generate Migration

```ruby
rails g cms:install # Generate default migration
rails g cms:add_meta_title # Generate meta title migration
rake db:migrate
```

### 4.Generate Seed Data

```ruby
rake cms:seed
```

This will generate some default settings and an admin account.

### 5. Mount CMS In ```routes.rb```

```ruby
mount Cms::Engine => '/resume', :at => 'cms'
```

You can change the path you want.

## Getting Start

### 1. Login

**http://localhost:3000/resume/users/login**

```
id => admin@resumecompanion.com
password => 123456
```

### 2. Setting

**http://localhost:3000/resume/admin/settings**

You can setup website name, index page, default meta title, default meta description, default meta keywords, and GA account here. **We don't provid create new key by user**.

### 3. User

**http://localhost:3000/resume/admin/users**

You can create new admin user here. Don't forget to set the admin attribute to be true.

### 4. Navigation

**http://localhost:3000/resume/admin/navigations**

You can setup navigation here. **Please be careful to setup the link and avoid infinity loop**.

### 5. Image

**http://localhost:3000/resume/admin/images**

You can upload, edit, and delete images here.

### 6. Page

**http://localhost:3000/resume/admin/pages**

You can create, edit, and delete pages here.

### 7. Sidebar

**http://localhost:3000/resume/admin/sidebars**

You can create, edit, and delete sidebar here.

## Notice

### 1. Logout Method

The default logout method on devise is **"Delete"**, but, we use require_ssl in ResumeCompanion, it will modify the default method to **"Get"** (if redirection is happened). So, the logout will be broken when you install it to the new project.

### 2. Micro Code

We have three type of micro code in ```pages_helper.rb``` :

***&lt;page_link&gt;home&lt;/page_link&gt;***

This micro code provide you set the page slug between ***page_link*** tag, it will replace with the page link.

***&lt;children_count&gt;home&lt;/children_count&gt;***

This micro code provide you set the page slug between ***children_count*** tag, it will replace with the children count.

***&lt;children_pages&gt;home&lt;/children_pages&gt;***

This micro code provide you set the page slug between ***children_count*** tag, it will replace with the children page list.

ps: The **"home"** in the example is page slug, you can replace it with the page slug you want.

### 3. Migrate The Content

The default template is almost gone, so we can't migrate the content easily. Unless you make sure every thing will be all right, please don't migrate the data. **It'll have a lot of accidents.**


