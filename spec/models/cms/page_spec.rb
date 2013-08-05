require 'spec_helper'

module Cms
  describe Page do
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
