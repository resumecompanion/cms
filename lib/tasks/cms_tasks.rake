# -*- encoding : utf-8 -*-
namespace :cms do
  desc "Import Pages"
  task :import => :environment do
    config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
    database_config = HashWithIndifferentAccess.new(config)

    client = Mysql2::Client.new(:host => database_config[:host] || "localhost", :username => database_config[:username], :password => database_config[:password], :database => database_config[:database])

    results = client.query("select * from refinery_pages order by lft", :as => :hash, :symbolize_keys => true)

    results.each do |result|
      result_content = client.query("select refinery_page_part_translations.body from refinery_page_part_translations inner join refinery_page_parts on refinery_page_part_translations.refinery_page_part_id = refinery_page_parts.id  where refinery_page_parts.refinery_page_id = #{result[:id]} and refinery_page_parts.title = 'Body'", :as => :hash, :symbolize_keys => true).first
      result_attribute = client.query("select * from refinery_page_translations where refinery_page_id = #{result[:id]}", :as => :hash, :symbolize_keys => true).first
      result_seo = client.query("select * from seo_meta where seo_meta_id = #{result[:id]} and seo_meta_type = 'Refinery::Page::Translation'", :as => :hash, :symbolize_keys => true).first

      doc = Nokogiri::HTML.fragment(result_content[:body])

      doc.css('a').each do |link|
        match = link[:href].match(/^http:\/\/resumecompanion.com\/resume\/pages(.*)/) || link[:href].match(/^\/resume\/pages(.*)/) || link[:href].match(/^\/resume\/home(.*)/) if link[:href].present?
        link[:href] = "/resume/#{match[1].split("/").last}" if match.present?
      end

      doc.css('img').each do |img|
        url = "http://resumecompanion.com#{img[:src]}"

        puts url

        temp_file = File.open open(url)
        file = Cms::File.new
        file.cms_user_id = 1
        file.title = img[:title] if img[:title].present?
        file.image = temp_file
        file.save

        img[:src] = file.image.url
      end

      page = Cms::Page.new
      page.parent_id = result[:parent_id]
      page.author_id = 1
      page.sidebar_id = 1
      page.title = result_attribute[:title]
      page.slug = result_attribute[:slug]
      if result_seo.present?
        page.meta_description = result_seo[:meta_description]
        page.meta_keywords = result_seo[:meta_keywords]
      end
      page.content = doc.inner_html
      page.is_published = !!result[:draft]
      page.old_id = result[:id]
      page.generate_slug = false
      page.save

    end

    pages = Cms::Page.all

    pages.each do |page|
      if page.parent_id.present?
        parent_page = Cms::Page.find_by_old_id(page.parent_id)
        page.update_attributes(:parent_id => parent_page.id)
      end
    end
  end

  desc "create default data"
  task :seed => :environment do
    user = Cms::User.new(:nickname => "admin", :email => "admin@resumecompanion.com", :password => "123456", :password_confirmation => "123456")
    user.is_admin = true
    user.save

    puts "create admim"

    navigation = Cms::Navigation.create(:name => "Home", :link => "/resume", :link_title => "Home", :is_hidden => false, :position => 1)
    navigation = Cms::Navigation.create(:name => "Resume Companion", :link => "/resume/resume-examples", :link_title => "Home", :is_hidden => false, :position => 2)
    navigation = Cms::Navigation.create(:name => "About Resume Companion", :link => "/resume/about-resume-companion", :link_title => "Home", :is_hidden => false, :position => 3)

    puts "create navigations"

    setting = Cms::Setting.create(:key => "global:website_title", :value => "ResumeCompanion", :description => "This will be your website name")
    setting = Cms::Setting.create(:key => "global:index", :value => "/resume/home", :description => "This is a path you want to be index page")
    setting = Cms::Setting.create(:key => "global:meta_title", :value => "ResumeCompanion CMS", :description => "This is default title if we can't find tilte")
    setting = Cms::Setting.create(:key => "global:meta_description", :value => "ResumeCompanion CMS", :description => "This is default meta description if we can't find meta description")
    setting = Cms::Setting.create(:key => "global:meta_keywords", :value => "ResumeCompanion CMS", :description => "This is default meta description if we can't find meta description")
    setting = Cms::Setting.create(:key => "global:ga_account", :value => "UA-513849-6", :description => "This is GA account")

    puts "create settings"

    sidebar = Cms::Sidebar.new
    sidebar.name = "default sidebar"
    sidebar.content = '
    <div class="banner">
      Your Can add banner here
    </div>

    <div class="links">
      <ul>
        <li>You can add link here</li>
      </ul>
    </div>
    '
    sidebar.save

    puts "create sidebar"
  end
end