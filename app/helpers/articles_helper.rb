module ArticlesHelper

  def tag_list
    if article_params[:tag_list].blank?
      @articles = Article.all
    else
      @articles = Article.tag_list(params)
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, :tag_list, :image)
  end
end
