# == Schema Information
#
# Table name: social_accounts
#
#  id               :integer          not null, primary key
#  contactable_id   :integer          not null
#  contactable_type :string(255)      not null
#  name             :string(255)      not null
#  label            :string(255)
#  public           :boolean          default(TRUE), not null
#

Fabricator(:phone_number) do
  contactable { Fabricate(:person) }
  number { Faker::PhoneNumber.phone_number }
  label { Settings.phone_number.predefined_labels.shuffle.first }
end
