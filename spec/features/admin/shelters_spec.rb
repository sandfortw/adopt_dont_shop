require 'rails_helper'

describe 'admin shelter index' do
  before(:each) do
    @shelter1 = Shelter.create!(
      foster_program: true,
      name: 'Alpha house',
      city: 'Springfield',
      rank: 1
    )
    @shelter2 = Shelter.create!(
      foster_program: true,
      name: 'Sigma house',
      city: 'Springfield',
      rank: 3
    )
    @shelter3 = Shelter.create!(
      foster_program: true,
      name: 'Beta house',
      city: 'Springfield',
      rank: 2
    )
    @shelter4 = Shelter.create!(
      foster_program: true,
      name: 'Omega house',
      city: 'Springfield',
      rank: 7
    )
  end
  # SQL Only Story
  # For this story, you should write your queries in raw sql. You can use the ActiveRecord find_by_sql method to execute raw sql queries: https://guides.rubyonrails.org/active_record_querying.html#finding-by-sql
  # 10. Admin Shelters Index
  # As a visitor
  # When I visit the admin shelter index ('/admin/shelters')
  # Then I see all Shelters in the system listed in reverse alphabetical order by name
  it 'lists all the shelters in reverse alphabetical order' do
    visit '/admin/shelters'
    expect(@shelter2.name).to appear_before(@shelter4.name)
    expect(@shelter4.name).to appear_before(@shelter3.name)
    expect(@shelter3.name).to appear_before(@shelter1.name)
  end

  # For this story, you should fully leverage ActiveRecord methods in your query.

  # 11. Shelters with Pending Applications
  # As a visitor
  # When I visit the admin shelter index ('/admin/shelters')
  # Then I see a section for "Shelters with Pending Applications"
  # And in this section I see the name of every shelter that has a pending application
  it 'has a section with shelters with pending applications' do
    app = Application.create!(name: 'John Smith',
                              address: '123 Fake Street',
                              city: 'Springfield',
                              state: 'IL',
                              zipcode: 12_345,
                              description: 'I like dogs.',
                              status: 'Pending')
    app2 = Application.create!(name: 'Mary Smith',
                               address: '123 Fake Street',
                               city: 'Springfield',
                               state: 'IL',
                               zipcode: 12_345,
                               description: 'I like cats.',
                               status: 'Pending')
    fido = @shelter1.pets.create!(
      adoptable: true,
      age: 1,
      breed: 'weiner',
      name: 'Fido'
    )
    bruno = @shelter2.pets.create!(
      adoptable: true,
      age: 3,
      breed: 'schnauzer',
      name: 'Bruno'
    )
    petapp1 = PetApplication.create!(application_id: app.id, pet_id: fido.id)
    petapp2 = PetApplication.create!(application_id: app2.id, pet_id: bruno.id)
    visit '/admin/shelters'
    expect(page).to have_content('Shelters with Pending Applications')
    expect('Shelters with Pending Applications').to appear_before(@shelter1)
    expect('Shelters with Pending Applications').to appear_before(@shelter2)
  end
end
