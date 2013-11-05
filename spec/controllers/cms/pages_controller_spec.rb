require 'spec_helper'

module Cms
  describe Cms::PagesController do
    describe 'GET pages' do
      before do
        Setting.create key: 'global:index', value: '/resume/home-page'
        author = User.create email: 'test@test.com', nickname: 'Test', password: 'testtest', password_confirmation: 'testtest'
        @page = Page.create title: 'test page', is_published: false, redirect_path: '/cms/redirect'
        @page.author = author
        @page.save
      end

      subject { get :show, id: @page.slug, use_route: 'cms' }
      it 'should render the page if it exists and is published' do
        @page.update_attributes is_published: true, redirect_path: nil

        subject

        response.status.should == 200
      end

      it 'should increment the page views if the page is rendered' do
        @page.update_attributes is_published: true, redirect_path: nil

        Page.any_instance.should_receive(:increment_views_and_calculate_popularity)

        subject
      end
      it 'should render the page if it exists and is published even if redirect is set' do
        @page.update_attributes is_published: true, redirect_path: 'redirect/path'

        subject

        response.status.should == 200
      end

      it 'should redirect to CMS index page if the page does not exist' do
        @page.slug = "asdfasdfasfd"

        subject

        response.should redirect_to('/resume/home-page')
        response.status.should == 301
      end

      it 'should redirect (301) to CMS index if the page does exist but is not published and redirect path is nil' do
        @page.update_attributes is_published: false, redirect_path: nil

        subject

        response.should redirect_to('/resume/home-page')
        response.status.should == 301
      end

      it 'should not increment page views if the page does exist but is not published and redirect path is nil' do
        @page.update_attributes is_published: false, redirect_path: nil

        Page.any_instance.should_not_receive(:increment_views_and_calculate_popularity)

        subject
      end

      it 'should 301 redirect to CMS index if the page does exist but is not published and redirect path is blank' do
        @page.update_attributes is_published: false, redirect_path: ""

        subject

        response.should redirect_to('/resume/home-page')
        response.status.should == 301
      end

      it 'it should 301 redirect to the asigned link if the page is disabled' do
        @page.update_attributes is_published: false
        subject

        response.should redirect_to('/cms/redirect')
        response.status.should == 301
      end

      it 'it should not increment page views if the page is redirected' do
        Page.any_instance.should_not_receive(:increment_views_and_calculate_popularity)

        subject
      end
    end
  end
end
