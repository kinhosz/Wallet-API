class Finance::CategoriesController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def create
        category = current_user.finance_categories.build(category_params)

        if category.save
            render json: Finance::CategorySerializer.new(
                category.reload
            ).serializable_hash[:data][:attributes], status: :created
        else
            render json: category.errors, status: :unprocessable_entity
        end
    end

    private

    def category_params
        params.require(:category).permit(:name, :description, :is_recurring, :category_type)
    end
end
