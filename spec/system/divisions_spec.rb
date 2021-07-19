require 'rails_helper'

RSpec.describe 'Divisions', type: :system do
  let(:user) { create :admin }
  let(:division) { create :division, owner: user }

  before { login_as user, scope: :user }

  describe 'new' do
    it 'renders the new template' do
      visit new_division_path
      expect(page).to have_content('New Division')
    end

    it 'shows presence error on autocomplete field' do
      visit new_division_path
      click_button 'Save'
      expect(page).to have_content('must exist')
    end

    describe 'single attachment validation' do
      let(:file) { 'spec/fixtures/test.pdf' }

      before do
        visit new_division_path
        fill_in 'Name', with: 'Foo'
        fill_in 'Code', with: 'BAR'
        page.attach_file('Icon', file)
        click_on 'Save'
      end

      context 'when invalid due to content type' do
        it 'validates' do
          expect(page).to have_content 'Icon has an invalid content type of application/pdf, must be PNG'
          expect(division.icon.attached?).to be false
        end
      end

      context 'when invalid due to file size' do
        let(:file) { 'spec/fixtures/large_logo.png' }

        it 'validates' do
          expect(page).to have_content 'Icon must be less than 50 KB'
          expect(division.icon.attached?).to be false
        end
      end
    end
  end

  describe 'edit' do
    it 'renders the edit template' do
      visit edit_division_path(division)
      expect(page).to have_content('Editing Division')
    end

    it 'displays error for owner field when blank', js: true do
      visit edit_division_path(division)
      fill_in 'owner_name_search', with: ''
      click_button 'Save'

      if ENV['CI']
        # TODO: fix this so it works locally
        expect(page).to have_content 'Owner must exist and Owner can\'t be blank'
      end
    end
  end

  describe 'index' do
    it 'displays the divisions' do
      division
      visit divisions_path(search: { division_status: 1 })
      expect(page).to have_content(division.to_s)
    end

    it 'handles date filter errors' do
      visit divisions_path

      fill_in 'search_created_at_start', with: '01/32/2020'
      click_button 'Apply Filters'
      expect(page).to have_content('Invalid date entered')
    end

    context 'with hidden filter' do
      it 'shows header' do
        visit divisions_path(search: { show_header: true })
        expect(page.body).to have_content 'Showing header'
        visit divisions_path
        expect(page.body).not_to have_content 'Showing header'
      end
    end
  end

  describe 'show' do
    before { visit division_path(division) }

    it 'shows the division' do
      expect(page).to have_content(division.to_s)
    end

    it 'shows the right actions' do
      expect(page).to have_content('Right Button')
    end

    it 'shows translated version of field name' do
      expect(page).to have_content 'Additional data'
      expect(page).not_to have_content 'Additional info'
    end

    context 'with attachments' do
      let(:prompt) { 'Are you sure? Attachment cannot be recovered.' }
      let(:file) { File.open Rails.root.join('app/assets/images/app_logo.png') }

      before do
        division.logo.attach(io: file, filename: 'logo.png')
        visit division_path(division)
      end

      it 'allows attachment to be deleted', js: true do
        expect(ActiveStorage::Attachment.count).to eq 1

        page.accept_alert prompt do
          first('dd .fa-times').click
        end

        division.reload
        expect(page).to have_content 'Attachment successfully deleted'
        expect(ActiveStorage::Attachment.count).to eq 0
        expect(division.logo.attached?).to be false
      end
    end
  end
end
