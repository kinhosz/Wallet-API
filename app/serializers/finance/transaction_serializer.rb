class Finance::TransactionSerializer
    include JSONAPI::Serializer
    attributes :description, :occurred_at, :value

    attribute :category_name do |transaction|
        transaction.finance_category.name
    end
end
  