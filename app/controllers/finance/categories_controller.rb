class Finance::CategoriesController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def index
        categories = current_user.finance_categories
        render json: Finance::CategorySerializer.new(categories).serializable_hash[:data].map { |category| category[:attributes] }
    end

    def create
        category = current_user.finance_categories.build(category_params)

        if category.save
            render json: Finance::CategorySerializer.new(category.reload).serializable_hash[:data][:attributes], status: :created
        else
            render json: category.errors, status: :unprocessable_entity
        end
    end

    private

    def category_params
        params.require(:category).permit(:name, :description)
    end
end
