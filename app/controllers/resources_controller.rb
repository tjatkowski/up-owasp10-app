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

  def fetch
    url = fetch_param[:url]

    fetch_and_insert(url)

    @resources = Resource.all
    render 'resources'
  end

  private

  def fetch_and_insert(url)
    uri = URI.parse(url)

    return unless %w[http https].include?(uri.scheme)
    return unless %w[www.youtube.com youtube.com].include?(uri.host)
    return unless uri.path == '/watch'

    # Here should be some HTTP request
    Resource.create(key: 'youtube', value: uri.query)
  end

  def fetch_param
    params.require(:resource).permit(:url)

  end

  def search_param
    params.require(:search).permit(:key)
  end

  def permitted_params
    params.require(:resource).permit(:key, :value)
  end
end
