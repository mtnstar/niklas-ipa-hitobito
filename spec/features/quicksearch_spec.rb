#  Copyright (c) 2012-2024, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

require 'spec_helper'

describe 'Quicksearch' do
  context 'with pg_search' do
    it 'finds people and groups', js: true do
      obsolete_node_safe do
        sign_in
        visit root_path

        fill_in 'quicksearch', with: 'top'

        dropdown = find('ul[role="listbox"]')
        expect(dropdown).to have_content('Top Leader, Supertown')
        expect(dropdown).to have_content('Top → TopGroup')

        fill_in 'quicksearch', with: 'Top Leader'
        expect(dropdown).to have_content('Top Leader, Supertown')
        expect(dropdown).not_to have_content('Top → TopGroup')

        fill_in 'quicksearch', with: 'TopGroup'
        expect(dropdown).not_to have_content('Top Leader, Supertown')
        expect(dropdown).to have_content('Top → TopGroup')

        fill_in 'quicksearch', with: 'Supertown'
        expect(dropdown).to have_content('Top Leader, Supertown')
        expect(dropdown).not_to have_content('Top → TopGroup')
      end
    end
  end

  it 'renders clickable tables when submitting form via click', js: true do
    sign_in
    visit root_path
    fill_in 'quicksearch', with: 'top'
    find('button i.fa-search').click
    expect(page).not_to have_content 'TopGroup'
    within('.nav') { click_on 'Gruppen' }
    expect(page).to have_link 'TopGroup'
  end
end
