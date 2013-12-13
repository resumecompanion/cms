# -*- encoding : utf-8 -*-
namespace :cms do
  desc 'remove /posts/ from urls'
  task remove_posts_from_url: :environment do
    Cms::Page.find_each do |page| 
      puts page.inspect
      puts "changein page #{page.slug}"
      page.update_attributes content: page.content.gsub(%r(/posts/), '/')
    end
  end
  

  desc "Update child count" 
  task :update_child_count => :environment do
    Cms::Page.find_each do |page|
      page.update_child_count
    end
  end

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
    if I18n.default_locale == 'en-RC'.to_sym
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
    elsif I18n.default_locale == 'en-RG'.to_sym
      user = Cms::User.new(:nickname => "admin", :email => "admin@resumecompanion.com", :password => "123456", :password_confirmation => "123456")
      user.is_admin = true
      user.save

      puts "create admim"

      navigation = Cms::Navigation.create(:name => "Home", :link => "/resume", :link_title => "Home", :is_hidden => false, :position => 1)
      navigation = Cms::Navigation.create(:name => "Resume Companion", :link => "/resume/resume-examples", :link_title => "Home", :is_hidden => false, :position => 2)
      navigation = Cms::Navigation.create(:name => "About Resume Genius", :link => "/resume/about-resume-genius", :link_title => "Home", :is_hidden => false, :position => 3)

      puts "create navigations"

      setting = Cms::Setting.create(:key => "global:website_title", :value => "ResumeGenius", :description => "This will be your website name")
      setting = Cms::Setting.create(:key => "global:index", :value => "/resume/home", :description => "This is a path you want to be index page")
      setting = Cms::Setting.create(:key => "global:meta_title", :value => "ResumeGenius CMS", :description => "This is default title if we can't find tilte")
      setting = Cms::Setting.create(:key => "global:meta_description", :value => "ResumeGenius CMS", :description => "This is default meta description if we can't find meta description")
      setting = Cms::Setting.create(:key => "global:meta_keywords", :value => "ResumeGenius CMS", :description => "This is default meta description if we can't find meta description")
      setting = Cms::Setting.create(:key => "global:ga_account", :value => "UA-513849-6", :description => "This is GA account")
      setting = Cms::Setting.create(:key => "global:theme", :value => "resumegenius", :description => "This is Theme")

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

  task :meta_title => :environment do
    config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
    database_config = HashWithIndifferentAccess.new(config)

    client = Mysql2::Client.new(:host => database_config[:host] || "localhost", :username => database_config[:username], :password => database_config[:password], :database => database_config[:database])

    amount = 0

    Cms::Page.find_each do |page|
      result = client.query("select * from seo_meta where seo_meta_id = #{page.old_id} and seo_meta_type = 'Refinery::Page::Translation'", :as => :hash, :symbolize_keys => true).first
      if result.present? && result[:browser_title].present?
        amount += 1
        page.update_attributes(:meta_title => result[:browser_title])
        puts "#{page.title} => #{result[:browser_title]}"
      end
    end

    puts "Insert #{amount} meta_title"

  end

  task :convert_s3_url => :environment do
    Cms::Page.find_each do |page|
      body = Nokogiri::HTML.fragment(page.content)

      body.css('a').each do |link|
        link[:href] = link[:href].gsub("resumecompanionp-staging", "resumecompanionp") if link[:href] && link[:href].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      body.css('img').each do |img|
        img[:src] = img[:src].gsub("resumecompanionp-staging", "resumecompanionp") if img[:src] && img[:src].match(/resumecompanionp-staging\.s3\.amazonaws\.com/)
      end

      page.content = body.inner_html
      page.save
    end
  end

  task :convert_s3_url_to_staging => :environment do
    Cms::Page.find_each do |page|
      body = Nokogiri::HTML.fragment(page.content)

      body.css('a').each do |link|
        link[:href] = link[:href].gsub("resumecompanionp", "resumecompanionp-staging") if link[:href] && link[:href].match(/resumecompanionp\.s3\.amazonaws\.com/)
      end

      body.css('img').each do |img|
        img[:src] = img[:src].gsub("resumecompanionp", "resumecompanionp-staging") if img[:src] && img[:src].match(/resumecompanionp\.s3\.amazonaws\.com/)
      end

      page.content = body.inner_html
      page.save
    end
  end

  task :migrate_image => :environment do
    same_results = []

    Cms::Page.find_each do |page|
      body = Nokogiri::HTML.fragment(page.content)

      image_counter = 0

      body.css('img').each do |img|
        if img[:src] && match = img[:src].match(/resumecompanionp(\-staging)?\.s3\.amazonaws\.com\/uploads\/cms\/file\/image\/([0-9]*)\/(.*)/)
          file_id = match[2].to_i
          original_filename = match[3]

          puts "@@@@@@#{page.slug}"

          file = Cms::File.find(file_id) rescue nil
          if file.present?

            filename = page.slug
            filename += "-" + image_counter.to_s if image_counter != 0

            if file.image.rename(filename)

              result_filename = File.basename(file.image.path)

              img[:src] = img[:src].gsub(original_filename, result_filename)

              puts "@@@@@@#{file_id} - #{original_filename} => #{result_filename}"
              same_results << "@@@@@@#{file_id} - #{original_filename} => #{result_filename}" if original_filename == result_filename
              image_counter += 1
            end
          end
        end
      end

      page.content = body.inner_html
      page.save
    end

    puts "The same results: #{same_results.length}"
    puts same_results
  end

  task :remove_sub_category => :environment do
    puts "start to delete"
    Cms::Page.find_each do |page|
      body = Nokogiri::HTML.fragment(page.content)
      body.css(".sub-category").each do |node|
        node.remove
      end

      page.content = body.inner_html
      page.save
    end
  end

  task :download_resume_example_images => :environment do

    FileUtils.mkdir(File.join(Rails.root, "tmp", "resume_example")) unless Dir.exist?(File.join(Rails.root, "tmp", "resume_example"))

    Cms::File.find_each do |file|

      url = "https://resumecompanionp.s3.amazonaws.com"

      original_file = File.open open(url + file.image.to_s) rescue nil

      if original_file.present?

        width, height = `identify -format "%wx %h" #{original_file.path}`.split(/x/).map { |dim| dim.to_i }

        if width == 620

          match = file.image.to_s.match(/\/uploads\/cms\/file\/image\/(.*)\/(.*)/)

          original_id = match[1]
          original_filename = match[2].gsub("-large", "")
          original_extname = File.extname(original_filename)
          original_basename = File.basename(original_filename, original_extname)
          large_filename = original_basename + "-large" + original_extname
          thumb_filename = original_basename + "-thumb" + original_extname

          FileUtils.mkdir(File.join(Rails.root, "tmp", "resume_example", original_id)) unless Dir.exist?(File.join(Rails.root, "tmp", "resume_example", original_id))
          FileUtils.cp(original_file.path, File.join(Rails.root, "tmp", "resume_example", original_id, original_filename))
          FileUtils.cp(original_file.path, File.join(Rails.root, "tmp", "resume_example", original_id, large_filename))

          thumb_file = File.open open(url + "/uploads/cms/file/image/#{original_id}/#{thumb_filename}") rescue nil

          if thumb_file.present?
            FileUtils.cp(thumb_file.path, File.join(Rails.root, "tmp", "resume_example", original_id, thumb_filename))
          else
            puts "******"
            puts "#{file.image.to_s} - thumb is not exist"
            puts "******"
          end

          puts "========================================================"
          puts "#{original_id}/#{original_basename}"
          puts "#{original_id}/#{large_filename}"
          puts "#{original_id}/#{thumb_filename}"
          puts "========================================================"

        else
           puts "******"
            puts "#{file.image.to_s} is not resume example"
            puts "******"
        end

      else
        puts "******"
        puts "#{file.image.to_s} is not exist"
        puts "******"
      end

    end
  end

  task :convert_s3_url_to_rc => :environment do
    Cms::Page.find_each do |page|
      body = Nokogiri::HTML.fragment(page.content)

      body.css('img').each do |img|
        if img[:src] && img[:src].match(/resumecompanionp\.s3\.amazonaws\.com/)
          puts "======"
          puts img
          img[:src] = img[:src].gsub("https://resumecompanionp.s3.amazonaws.com", "http://images.resumecompanion.com")
          puts img
          puts "======"
        end
      end

      page.content = body.inner_html
      page.save
    end
  end

end
