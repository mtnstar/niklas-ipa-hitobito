#  Copyright (c) 2014, hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class AddRepresentativeEventParticipantCount < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :representative_participant_count, :integer, default: 0
  end
end
