class HomeController < ApplicationController
  def index
    @time_slots = SearchResult::TIME_SLOTS.map do |duration|
      Tools.seconds_to_time(duration)
    end
  end

  def search
    search = Search.new params[:query]
    begin
      result = {
        :tweets => search.execute,
        :next_max_id => search.result.next_max_id
      }
      status = 200
    rescue SearchError => e
      result = "Something went wrong with the search! Please try again."
      status = 500
    rescue InvalidQuery => e
      result = "Please enter a valid query!"
      status = 400
    end

    respond_to do |format|
      format.js { render(:json => result, :status => status) }
    end
  end
end
