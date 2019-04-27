class PostcodeServicer < Wallaby::ModelServicer
  def permit(params, action)
    params.fetch(:postcode, params).permit(model_decorator.form_field_names)
  end

  def collection(params)
    Postcode.all
  end

  def paginate(query, params)
    query
  end

  def new(params)
    Postcode.new
  end

  def find(id, params)
    Postcode.find id
  end

  def create(resource, params)
    resource.assign params
    Postcode.create resource
  end

  def update(resource, params)
    resource.assign params
    Postcode.update resource
  end

  def destroy(resource, params)
    Postcode.destroy resource
  end
end
