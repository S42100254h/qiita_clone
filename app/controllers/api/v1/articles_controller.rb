class Api::V1::ArticlesController < Api::V1::ApiController
  def index
    articles = Article.all
    render json: articles
  end

  def show
    article = Article.find(params[:id])
    render json: article
  end
end
