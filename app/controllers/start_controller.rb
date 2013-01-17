class StartController < ApplicationController
  
  def index
    
  end
  
  def q
    method = 'taobao.taobaoke.items.get'
    p = {}
    p['fields'] = 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
    
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
    if !params[:cid].blank?
      p['cid'] = params[:cid]
    end
    p['keyword'] = @keyword
    query_api(method, p)
      
    method = 'taobao.taobaoke.shops.get'
    p = {}
    p['fields'] = "click_url, shop_title, seller_credit"
    p['keyword'] = @keyword
    get = Api.query(method, p)
    if get == 'error'
      redirect_to '/'
      return
    else
      get = JSON.parse(get)
      if get["taobaoke_shops_get_response"] && get["taobaoke_shops_get_response"]["taobaoke_shops"]
        @shops = get["taobaoke_shops_get_response"]["taobaoke_shops"]["taobaoke_shop"]
      end
    end
  end
  
  def c
    method = 'taobao.taobaoke.items.get'
    p = {}
    p['fields'] = 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
    
    if params[:id].blank?
      redirect_to "/"
      return
    else 
      if Catalog.find_by_cid(params[:id])
        @catalog = Catalog.find_by_cid(params[:id])
      else
        if Category.find_by_cid(params[:id])
          @catalog = Category.find_by_cid(params[:id])
        end
      end
      @catalogs = Catalog.find(:all, :conditions => ["parent_id = 0"], :order => 'id asc')
      
      p['cid'] = params[:id]
    end
    query_api(method, p)
  end
  
  def p
    if params[:id].blank?
      redirect_to '/'
      return
    end
    method = 'taobao.taobaoke.items.detail.get'
    p = {}
    p['fields'] = 'cid, title, desc, nick, pic_url, num, location, price, freight_payer, post_fee, express_fee, ems_fee, click_url, shop_click_url, seller_credit_score'
    p['num_iids'] = params[:id]
    get = Api.query(method, p)
    if get == 'error'
      redirect_to '/'
      return
    else
      @catalogs = Catalog.find(:all, :conditions => ["parent_id = 0"], :order => 'id asc')
      
      get = JSON.parse(get)
      if get["taobaoke_items_detail_get_response"] && get["taobaoke_items_detail_get_response"]["taobaoke_item_details"]
        @result = get["taobaoke_items_detail_get_response"]["taobaoke_item_details"]["taobaoke_item_detail"][0]
        @cid = @result["item"]["cid"].to_s
      else
        redirect_to '/'
        return
      end
      
      if Catalog.find_by_cid(@cid)
        @catalog = Catalog.find_by_cid(@cid)
      end
    end
  end
  
  def phone
    render :layout => false
  end
  
private
  
  def query_api(method, p)
    @page = params[:page] ? params[:page].to_i : 1
    @per_page = 28
    p['page_no'] = @page.to_s
    p['page_size'] = @per_page.to_s
    get = Api.query(method, p)
    if get == 'error'
      @result = 'error'
    else
      get = JSON.parse(get)
      if get["taobaoke_items_get_response"] && get["taobaoke_items_get_response"]["taobaoke_items"]
        @result = get["taobaoke_items_get_response"]["taobaoke_items"]["taobaoke_item"]
        @total = get["taobaoke_items_get_response"]["total_results"]
      else
        @result = 'error'
      end
    end    
  end
  
end
