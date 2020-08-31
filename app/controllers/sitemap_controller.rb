require 'open-uri'

class SitemapController < ApplicationController
    def index
        url = 'https://cloud-cube.s3.amazonaws.com/y97vpchuzi86/public/sitemap.xml.gz'

        send_file open(url), filename: 'sitemap.xml.gz'
    end
end
