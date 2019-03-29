module Api
  class CompaniesController < ApiController
    def info
      @company = Company.find_by(id: params[:id])
      @last_deal = @company&.deals&.last

      render(json: { errors: 'Company ID is invalid.' }) if @company.blank?
    end
  end
end
