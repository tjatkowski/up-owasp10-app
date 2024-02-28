class ResourcesController < UserController
  def index
    @resource = Resource.new
    @resources = Resource.all
  end

  def create
    @resource = Resource.create(permitted_params)
    @resources = Resource.all

    render 'resources'
  end

  def search
    key = search_param[:key]
    if key.blank?
      @resources = Resource.all
    else
      @resources = Resource.where(key: key)
    end

    render 'resources'
  end

  private

  def search_param
    params.require(:search).permit(:key)
  end

  def permitted_params
    params.require(:resource).permit(:key, :value)
  end
end
