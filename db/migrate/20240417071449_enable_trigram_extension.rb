#  Copyright (c) 2012-2024, Hitobito AG. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class EnableTrigramExtension < ActiveRecord::Migration[6.1]
  def change
    enable_extension :pg_trgm
  end
end
