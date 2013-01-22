module ApplicationHelper
  
  def show_title(title)
    title.gsub(/<(.*?)>/, '')
  end
  
  def well_paginate(total, page, per_page, keyword)
    if total > 500
      maxpage = 19
    else
      maxpage, m = total.divmod per_page
      if m != 0
        maxpage += 1
      end
    end
    arr = []
    1.upto maxpage-1 do |i|
      if i == page
        arr << "<em>#{i}</em>"
      else
        if params[:cid]
          url = "/q/#{keyword}?cid=#{params[:cid]}&page=#{i}"
        else
          url = "/q/#{keyword}?page=#{i}"
        end
        arr << "<a href='#{url}'>#{i}</a>"
      end
    end
    arr.join('').html_safe
  end
  
  def ct_paginate(total, page, per_page, cid)
    if total > 500
      maxpage = 19
    else
      maxpage, m = total.divmod per_page
      if m != 0
        maxpage += 1
      end
    end
    arr = []
    1.upto maxpage-1 do |i|
      if i == page
        arr << "<em>#{i}</em>"
      else
        arr << "<a href='/ct/#{cid}?page=#{i}'>#{i}</a>"
      end
    end
    arr.join('').html_safe
  end
  
  def h_load(text)
    text.gsub!(/src="(.*?)"/, 'src="/assets/loading_circle.gif" data-original="\1"')
    text.html_safe
  end
  
  def location(cid) 
    arr = []
    while cid != '0'
      cat = Api.itemcats_cid(cid)
      if !cat.nil?
        cid = cat["parent_cid"].to_s
        arr << " &gt;&gt; <a href=\"/ct/" + cat['cid'].to_s  + "\">" + cat['name'] + "</a>"
      else
        cid = '0'
      end
    end
    arr.reverse().join('').html_safe
  end  
  
end
