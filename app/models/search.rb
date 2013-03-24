class Search
  attr_accessor :query, :options
  attr_reader :result

  def initialize(query = nil, options = {})
    @query = query
    @options = {
      :count => 100,
      :result_type => 'recent'
    }.merge options
    @options.delete_if { |key, value| value.nil? }
  end

  def execute
    raise InvalidQuery if @query.blank?
    @result = SearchResult.new run_query(@options)
    @result.group_by_time if @result.present?
  end

  private

  def run_query(options = {})
    begin
      result = Twitter.search(@query, options)
      statuses = result.statuses
      next_max_id = get_next_max_id(result)
    rescue => e
      raise SearchError
    end
    { :statuses => statuses, :next_max_id => next_max_id }
  end

  def get_next_max_id(result)
    if result.attrs[:search_metadata][:next_results]
      result.attrs[:search_metadata][:next_results].match(/\?max_id=(.*?)&/)[1].to_i
    end
  end

end 