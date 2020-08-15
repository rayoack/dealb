class SitemapController < ApplicationController
    def index
        redirect_to 'https://cloud-cube.s3.amazonaws.com/y97vpchuzi86/public/sitemap.xml.gz'
    end
end
