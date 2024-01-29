class Finance::CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :description, :is_recurring, :category_type
end
