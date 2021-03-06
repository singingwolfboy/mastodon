# frozen_string_literal: true

class Api::V1::FollowsController < ApiController
  before_action -> { doorkeeper_authorize! :follow }
  before_action :require_user!

  respond_to :json

  def create
    raise ActiveRecord::RecordNotFound if params[:uri].blank?

    @account = FollowService.new.call(current_user.account, target_uri).try(:target_account)
    render action: :show
  end

  private

  def target_uri
    params[:uri].strip.gsub(/\A@/, '')
  end
end
