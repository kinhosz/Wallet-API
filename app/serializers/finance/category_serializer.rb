class Finance::CategorySerializer
  include JSONAPI::Serializer
  attributes :name, :description, :uuid
end
