require 'spec_helper'

module Cms
  describe Page do
    let(:page) do
      author = User.create email: 'test@test.com', nickname: 'Test', password: 'testtest', password_confirmation: 'testtest'
      page = Page.create title: 'test page', is_published: false, redirect_path: '/cms/redirect'
      page.author = author
      page.save
      page
    end

    describe '.five_msot_popular' do
      before do
        author = User.create email: 'test@test.com', nickname: 'Test', password: 'testtest', password_confirmation: 'testtest'
        10.times do |n|
          page = Page.create title: "test page #{n}", is_published: false, redirect_path: "/cms/redirect"
          page.popularity = n
          page.author = author
          page.save
        end
      end

      it 'should limit to 5' do
        Page.five_most_popular.count.should == 5
      end

      it 'should return the 5 most popular posts' do
        Page.five_most_popular.collect {|post| post.title }.should == ['test page 9', 'test page 8', 'test page 7', 'test page 6', 'test page 5']
      end
    end
    
    describe '#increment_views_and_calculate_popularity' do
      subject { page.increment_views_and_calculate_popularity } 

      it 'should increment the view count' do
        expect { subject }.to change {page.views}.by(1)
      end

      it 'should update the popularity' do
        page.created_at = Time.now - 15.days
        page.views = 1123

        subject
        page.popularity.should be_within(0.2).of(74.8)
      end

      it 'should save the changes' do
        subject.persisted?.should be_true
      end
    end

    describe '#days_since_creation' do
      subject { page.days_since_creation }
      it 'should caluate the days since creation' do
        page.created_at = Time.now - 35.days

        subject.should == 35
      end

      it 'should return 1 if there are zero days' do
        page.created_at = Time.now

        subject.should == 1
      end

      it 'should return 1 id created_at is not set' do
        page.created_at= nil

        subject.should == 1
        page.created_at.should == nil
      end
    end
    describe '#sample_of_childern' do
      subject do
        author = User.create email: 'test@test.com', nickname: 'Test', password: 'testtest', password_confirmation: 'testtest'
        @parent = Page.create title: 'test page', is_published: false, redirect_path: '/cms/redirect'
        @parent.author = author


        @number_of_children.times do |n|
          @page = Page.create title: "test page #{n}", is_published: true
          @page.parent = @parent
          @page.author = author
          @page.save
        end

        @parent.sample_of_children(@page)
      end

      it 'should exclude the given page' do
        @number_of_children = 4

        subject.should_not include(@page)
      end

      it 'should only return 5 pages' do
        @number_of_children = 10

        subject.should have(5).children
      end

      it 'should not return unpublished pages' do
        @number_of_children = 10

        subject
        @parent.children.each {|c| c.update_attributes is_published: false}
        @parent.sample_of_children(@page).should have(0).children
      end
    end
  end
end
