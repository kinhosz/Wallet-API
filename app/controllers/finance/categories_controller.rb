class Finance::CategoriesController < ApplicationController
    before_action :authenticate_user!
    respond_to :json

    def upsert
        category_params.key?(:uuid) ? update : create
    end

    def index
        categories = current_user.finance_categories
        render json: Finance::CategorySerializer.new(
            categories
        ).serializable_hash[:data].map { |category| category[:attributes] }, status: :ok
    end

    private

    def category_params
        params.require(:category).permit(:name, :description, :icon, :uuid)
    end

    def upsert_render(category, success)
        if success
            render json: Finance::CategorySerializer.new(
                category.reload
            ).serializable_hash[:data][:attributes], status: :created
        else
            render json: category.errors, status: :unprocessable_entity
        end
    end

    def create
        category = current_user.finance_categories.build(category_params)
        upsert_render(category, category.save)
    end

    def update
        category = current_user.finance_categories.find_by!(uuid: category_params[:uuid])
        success = category.update(
            category_params.slice(:name, :description, :icon).compact
        )
        upsert_render(category, success)
    end
end
