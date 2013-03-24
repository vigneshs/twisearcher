class TwisearcherError < StandardError; end
class SearchError < TwisearcherError; end
class InvalidQuery < TwisearcherError; end