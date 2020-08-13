class SitemapController < ApplicationController
    def index
        @companies = Company.all
    end
end
