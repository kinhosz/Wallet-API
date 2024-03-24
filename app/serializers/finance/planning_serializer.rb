class Finance::PlanningSerializer
    include JSONAPI::Serializer
    attributes :date_start, :date_end
end
  