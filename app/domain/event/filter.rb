#  Copyright (c) 2012-2021, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

class Event::Filter
  attr_reader :type, :filter, :group, :year, :sort_expression, :sort_expression_name

  def initialize(group, type, filter, year, sort_expression, sort_expression_name)
    @group = group
    @type = type
    @filter = filter
    @year = year
    @sort_expression = Arel.sql(sort_expression) if sort_expression.is_a?(String)
    @sort_expression_name = sort_expression_name
  end

  def list_entries    
    sort_expression ? scope.distinct.select('MAX(event_translations.name)')
                           .select(sort_expression).reorder(sort_expression_name) : scope.distinct
  end

  def scope
    # This must run as an explicite separate query.
    # If you merge this in the following relation, activerecord+kaminari
    # will mess up the queries (pagination is run on the wrong query).
    event_ids_for_relevant_groups = Event.with_group_id(relevant_group_ids).pluck(:id)

    Event # nesting restricts to parent, we want more
      .where(id: event_ids_for_relevant_groups)
      .list
      .where(type: type)
      .includes(:groups, :translations, :events_groups)
      .unscope(:select)
      .select('events.*' ,'MAX(event_dates.start_at)')
      .left_joins(:translations)
      .in_year(year)
      .preload_all_dates
  end

  def to_h
    { year: year,
      type: type,
      filter: filter,
      sort_expression: sort_expression }
  end

  private

  def relevant_group_ids
    case filter
    when 'layer' then [group.id] + descendants(layer: true).pluck(:id)
    else [group.id] + descendants.pluck(:id) # handles 'all' also
    end
  end

  def descendants(layer: false)
    scope = group.descendants
    layer ? scope.where(layer_group_id: group.layer_group_id) : scope
  end
end
