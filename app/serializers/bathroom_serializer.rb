# BathroomSerializer
# Formats bathrooms when serializing to JSON.
#
class BathroomSerializer < ActiveModel::Serializer
  attributes :id, :name, :sparkcore_id, :status, :status_updated_at
end
