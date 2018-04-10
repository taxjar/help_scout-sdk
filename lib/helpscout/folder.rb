# frozen_string_literal: true

module Helpscout
  class Folder < Helpscout::Base
    attr_reader :id, :name, :type, :user_id, :total_count, :active_count,
                :modified_at

    def initialize(params)
      @id = params[:id]
      @name = params[:name]
      @type = params[:type]
      @user_id = params[:user_id]
      @total_count = params[:total_count]
      @active_count = params[:active_count]
      @modified_at = params[:modified_at]
    end
  end
end
