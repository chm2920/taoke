class AboutController < ApplicationController
  
  def cats
    @categories = Category.find(:all, :conditions => ['parent_id = 0'], :order => 'id asc')
  end
  
  def catalogs
    @catalogs = Catalog.find(:all, :conditions => ["parent_id = 0"], :order => 'id asc')
  end
  
  def shopcats
    @result = Api.shopcats
  end
  
  def itemcats
    @result = Api.itemcats('0')
  end
  
  def ct
    @cats = Api.itemcats(params[:id])
    if !@cats
      @cat = Api.itemcats_cid(params[:id])
      @cat && @cats = Api.itemcats(@cat["parent_cid"].to_s)
    end
    @page = params[:page] ? params[:page].to_i : 1
    @per_page = 28
    @result, @total = Api.items(params[:id], @page, @per_page)
  end
  
  def i
    @cats = Api.itemcats('0')
    @result = Api.item_detail(params[:id])
  end  
  
  def q
    case request.method
    when "POST"
      if params[:q].blank?
        redirect_to "/"
        return
      else
        @keyword = params[:q]
      end
    else      
      if params[:id].blank?
        redirect_to "/"
        return
      else
        @keyword = params[:id]
      end
    end
    @page = params[:page] ? params[:page].to_i : 1
    @per_page = 28
    @result, @total = Api.item_search(@keyword, @page, @per_page)
    @shops = Api.shops(@keyword)
  end
  
end
