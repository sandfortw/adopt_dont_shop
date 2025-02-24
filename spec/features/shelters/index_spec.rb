require 'rails_helper'

RSpec.describe 'the shelters index' do
  before(:each) do
    @shelter_1 = create(:shelter, name:'Aurora shelter')
    @shelter_2 = create(:shelter, name:'RGV animal shelter')
    @shelter_3 = create(:shelter, name: 'Fancy pets of Colorado' )
    create(:pet, shelter_id: @shelter_1.id)
    create(:pet, shelter_id: @shelter_1.id)
    create(:pet, shelter_id: @shelter_3.id)
  end

  it 'lists all the shelter names' do
    visit '/shelters'

    expect(page).to have_content(@shelter_1.name)
    expect(page).to have_content(@shelter_2.name)
    expect(page).to have_content(@shelter_3.name)
  end

  it 'lists the shelters by most recently created first' do
    visit '/shelters'

    oldest = find("#shelter-#{@shelter_1.id}")
    mid = find("#shelter-#{@shelter_2.id}")
    newest = find("#shelter-#{@shelter_3.id}")

    expect(newest).to appear_before(mid)
    expect(mid).to appear_before(oldest)

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_content("Created at: #{@shelter_1.created_at}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_content("Created at: #{@shelter_2.created_at}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_content("Created at: #{@shelter_3.created_at}")
    end
  end

  it 'has a link to sort shelters by the number of pets they have' do
    visit '/shelters'

    expect(page).to have_link('Sort by number of pets')
    click_link('Sort by number of pets')

    expect(page).to have_current_path('/shelters?sort=pet_count')
    expect(@shelter_1.name).to appear_before(@shelter_3.name)
    expect(@shelter_3.name).to appear_before(@shelter_2.name)
  end

  it 'has a link to update each shelter' do
    visit '/shelters'

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_link("Update #{@shelter_1.name}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_link("Update #{@shelter_2.name}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_link("Update #{@shelter_3.name}")
    end

    click_on("Update #{@shelter_1.name}")
    expect(page).to have_current_path("/shelters/#{@shelter_1.id}/edit")
  end

  it 'has a link to delete each shelter' do
    visit '/shelters'

    within "#shelter-#{@shelter_1.id}" do
      expect(page).to have_link("Delete #{@shelter_1.name}")
    end

    within "#shelter-#{@shelter_2.id}" do
      expect(page).to have_link("Delete #{@shelter_2.name}")
    end

    within "#shelter-#{@shelter_3.id}" do
      expect(page).to have_link("Delete #{@shelter_3.name}")
    end

    click_on("Delete #{@shelter_1.name}")
    expect(page).to have_current_path('/shelters')
    expect(page).to_not have_content(@shelter_1.name)
  end

  it 'has a text box to filter results by keyword' do
    visit '/shelters'
    expect(page).to have_button('Search')
  end

  it 'lists partial matches as search results' do
    visit '/shelters'

    fill_in 'Search', with: 'RGV'
    click_on('Search')

    expect(page).to have_content(@shelter_2.name)
    expect(page).to_not have_content(@shelter_1.name)
  end
end
