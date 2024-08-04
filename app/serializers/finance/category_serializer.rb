class Finance::CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :description,
    :category_type, :uuid
end
