require 'spec_helper'

module Cms
  describe Cms::PagesController do
    describe 'GET pages' do
      before do
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

      it 'should render the page if it exists and is published even if redirect is set' do
        @page.update_attributes is_published: true, redirect_path: 'redirect/path'

        subject

        response.status.should == 200
      end

      it 'should redirect to 404 if the page does not exist' do
        @page.slug = "asdfasdfasfd"

        subject

        response.status.should == 404
        response.should render_template('render_404')
      end

      it 'should redirect to 404 if the page does exist but is not published and redirect path is nil' do
        @page.update_attributes is_published: false, redirect_path: nil

        subject

        response.status.should == 404
        response.should render_template('render_404')
      end

      it 'should redirect to 404 if the page does exist but is not published and redirect path is blank' do
        @page.update_attributes is_published: false, redirect_path: ""

        subject

        response.status.should == 404
        response.should render_template('render_404')
      end

      it 'it should 301 redirect to the redirect path if the page is disabled' do
        subject

        response.should redirect_to('/cms/redirect')
        response.status.should == 301
      end
    end
  end
end
