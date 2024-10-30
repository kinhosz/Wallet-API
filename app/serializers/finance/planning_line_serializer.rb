class Finance::PlanningLineSerializer
  include JSONAPI::Serializer
  attributes :value

  attribute :category do |object|
    object.finance_category.uuid
  end

  attribute :planning do |object|
    object.finance_planning.uuid
  end
end
