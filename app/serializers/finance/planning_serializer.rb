class Finance::PlanningSerializer
    include JSONAPI::Serializer
    attributes :currency, :date_start, :date_end
end
  