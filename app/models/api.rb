class Api
    
  AppKey = APP_CONFIG['AppKey']
  AppSecret = APP_CONFIG['AppSecret']
  PID = APP_CONFIG['PID']
  
  def self.itemcats_cid(cid)
    method = 'taobao.itemcats.get'
    p = {}
    p['fields'] = 'cid,parent_cid,name,is_parent'
    p['cids'] = cid
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else      
      get = JSON.parse(get)
      if get["itemcats_get_response"] && get["itemcats_get_response"]["item_cats"]
        re = get["itemcats_get_response"]["item_cats"]["item_cat"][0]
      else
        re = nil
      end
    end
    re
  end
  
  def self.itemcats(parent_cid)
    method = 'taobao.itemcats.get'
    p = {}
    p['fields'] = 'cid,parent_cid,name,is_parent'
    p['parent_cid'] = parent_cid
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else      
      get = JSON.parse(get)
      if get["itemcats_get_response"] && get["itemcats_get_response"]["item_cats"]
        re = get["itemcats_get_response"]["item_cats"]["item_cat"]
      else
        re = nil
      end
    end
    re
  end
  
  def self.shopcats
    method = 'taobao.shopcats.list.get'
    p = {}
    p['fields'] = 'cid,parent_cid,name,is_parent'

    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else      
      get = JSON.parse(get)
      if get["shopcats_list_get_response"] && get["shopcats_list_get_response"]["shop_cats"]
        re = get["shopcats_list_get_response"]["shop_cats"]["shop_cat"]
      else
        re = nil
      end
    end
    re
  end
  
  def self.items(cid, page, per_page)
    re = nil
    total = nil
    method = 'taobao.taobaoke.items.get'
    p = {}
    p['fields'] = 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
    p['cid'] = cid
    p['page_no'] = page.to_s
    p['page_size'] = per_page.to_s
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else
      get = JSON.parse(get)
      if get["taobaoke_items_get_response"] && get["taobaoke_items_get_response"]["taobaoke_items"]
        re = get["taobaoke_items_get_response"]["taobaoke_items"]["taobaoke_item"]
        total = get["taobaoke_items_get_response"]["total_results"]
      else
        re = nil
      end
    end 
    [re, total]
  end
  
  def self.item_detail(cid)
    method = 'taobao.taobaoke.items.detail.get'
    p = {}
    p['fields'] = 'cid, title, desc, nick, pic_url, num, location, price, freight_payer, post_fee, express_fee, ems_fee, click_url, shop_click_url, seller_credit_score, detail_url, num_iid, seller_cids, props, property_alias, input_pids, input_str, item_imgs, prop_imgs'
    p['num_iids'] = cid
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else
      get = JSON.parse(get)
      if get["taobaoke_items_detail_get_response"] && get["taobaoke_items_detail_get_response"]["taobaoke_item_details"]
        re = get["taobaoke_items_detail_get_response"]["taobaoke_item_details"]["taobaoke_item_detail"][0]
      else
        re = nil
      end
    end
    re
  end
  
  def self.item_search(keyword, page, per_page)
    re = nil
    total = nil
    method = 'taobao.taobaoke.items.get'
    p = {}
    p['fields'] = 'num_iid,title,nick,pic_url,price,click_url,commission,commission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume'
    p['keyword'] = keyword
    p['page_no'] = page.to_s
    p['page_size'] = per_page.to_s
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else
      get = JSON.parse(get)
      if get["taobaoke_items_get_response"] && get["taobaoke_items_get_response"]["taobaoke_items"]
        re = get["taobaoke_items_get_response"]["taobaoke_items"]["taobaoke_item"]
        total = get["taobaoke_items_get_response"]["total_results"]
      else
        re = nil
      end
    end 
    [re, total]
  end
  
  def self.shops(keyword)
    method = 'taobao.taobaoke.shops.get'
    p = {}
    p['fields'] = "click_url, shop_title, seller_credit"
    p['keyword'] = keyword
    get = Api.query(method, p)
    if get == 'error'
      re = nil
    else
      get = JSON.parse(get)
      if get["taobaoke_shops_get_response"] && get["taobaoke_shops_get_response"]["taobaoke_shops"]
        re = get["taobaoke_shops_get_response"]["taobaoke_shops"]["taobaoke_shop"]
      else
        re = nil
      end
    end
    re
  end
  
  #######################################
  
  def self.session
    require "open-uri"
    require "digest/md5"
    require "cgi"
    url = "http://container.open.taobao.com/container?appkey=" + AppKey
    begin
      get = open(url).read
    rescue
      get = 'error'
    ensure
      
    end
    puts get
    get
  end
  
  def self.query(method, params)
    require "open-uri"
    require "digest/md5"
    require "cgi"
    
    url = "http://gw.api.taobao.com/router/rest?"
    #url = "http://gw.api.tbsandbox.com/router/rest?"
    
    p = {}
    
    p['method'] = method
    p['timestamp'] = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    p['format'] = 'json'
    p['app_key'] = AppKey
    p['v'] = '2.0'
    p['sign_method'] = 'md5'
    p['pid'] = PID
    
    p.merge!(params)
    
    p = self.add_sign(p)    
    url += p.to_url_params
    puts url
    
    begin
      get = open(url).read
    rescue
      get = 'error'
    ensure
    end
    get
  end
    
  def self.add_sign(params)
    sign = params.sort.map{|t|t.join('')}.join('')
    sign = AppSecret + sign + AppSecret
    sign = Digest::MD5.hexdigest(sign).upcase
    params['sign'] = sign
    params
  end
  
end

class Hash
  def to_url_params
    elements = []
    keys.size.times do |i|
      elements << "#{CGI::escape(keys[i])}=#{CGI::escape(values[i])}"
    end
    elements.join('&')
  end

  def self.from_url_params(url_params)
    result = {}.with_indifferent_access
    url_params.split('&').each do |element|
      element = element.split('=')
      result[element[0]] = element[1]
    end
    result
  end
end
