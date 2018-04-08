module Helpscout
  class Folder
    attr_reader :id, :name, :type, :user_id, :total_count, :active_count,
                :modified_at

    def initialize(params)
      @id = params['id']
      @name = params['name']
      @type = params['type']
      @user_id = params['userId']
      @total_count = params['totalCount']
      @active_count = params['activeCount']
      @modified_at = params['modifiedAt']
    end
  end
end
