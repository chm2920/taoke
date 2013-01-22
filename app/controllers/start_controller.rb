class StartController < ApplicationController
  
  def index
    
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
