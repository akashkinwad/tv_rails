json.roles do
  json.partial! "api/v1/roles/role", collection: @roles, as: :role
end
