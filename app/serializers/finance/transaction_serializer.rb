class Finance::TransactionSerializer
    include JSONAPI::Serializer
    attributes :description, :occurred_at, :value

    attribute :category do |object|
        object.finance_category.uuid
    end
end
  