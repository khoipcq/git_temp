class AppointmentsController < ApplicationController

  def index
    arel_user = User.arel_table
    @list_user = User.where(arel_user[:id].not_eq(current_user.id).and(arel_user[:organization_id].eq(current_user.organization_id)))
  end
end
