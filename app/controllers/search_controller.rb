# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    searcher = GlobalSearcher.new(search_params[:global_search])

    @results = searcher.call!
    @results_paginated = Kaminari.paginate_array(@results).page(params[:page])
  end

  private

  def search_params
    params.permit(:global_search)
  end
end
