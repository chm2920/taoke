
var tk = {
	init: function(){
		this.bind();
	},
	bind: function(){
		var self = this;
		$('#q').keyup(function(event){
			if(event.keyCode=="13"){
				var t = $.trim($('#q').val());
				if(t != ''){
					self.search(t);
				}
			}
		});
		$('#btn_q').click(function(event){
			event.preventDefault();
			event.stopPropagation();
			var t = $.trim($('#q').val());
			if(t != ''){
				self.search(t);
			}
		});
	},
	search: function(q){
		$('#content').empty();
		$.ajax({
			type : "POST",
			dataType : 'json',
			context : this,
			url : '/q',
			data : {
				'q': q
			},
			success : function(data) {
				if(data && data.taobaoke_items_get_response){
					
				} else {
					
				}
			}
		});
	},
	pager: function () {
		var page = this.page, len = _self.cartList.materials.length, perpage = 5, maxpage = parseInt(len / perpage, 10) + (len % perpage == 0 ? 0 : 1);
		var pager = $('#pager'), pagenum = $('#pagenum'), pageNext = $('#pager #next'), pagePre = $('#pager #pre');
		if(maxpage > 1) {
			var pageTmpl = '<a class="general-btn{{if $data == $item.cur}} cur{{/if}}" href="javascript:;" rel="e:${$data}"><span>${$data}</span></a>';
			pagenum.empty();
			$.tmpl(pageTmpl, 1, {
				cur : this.page
			}).appendTo(pagenum);
			if(maxpage <= 5) {
				for( i = 2; i < maxpage; i++) {
					$.tmpl(pageTmpl, i, {
						cur : page
					}).appendTo(pagenum);
				}
			} else {
				var ellipsis = '<span class="ellipsis">…</span>'
				if(page > 4 && (maxpage - page) > 3) {
					$('#pagenum').append(ellipsis);
					for(var i = page - 2; i <= page + 2; i++) {
						$.tmpl(pageTmpl, i, {
							cur : page
						}).appendTo(pagenum);
					}
					$('#pagenum').append(ellipsis);
				} else if(page <= 4) {
					for(var i = 2; i < 6; i++) {
						$.tmpl(pageTmpl, i, {
							cur : page
						}).appendTo(pagenum);
					}
					if(maxpage > 6) {
						$('#pagenum').append(ellipsis);
					}
				} else if((maxpage - page) <= 4) {
					if(maxpage > 6) {
						$('#pagenum').append(ellipsis);
					}
					for(var i = maxpage - 4; i < maxpage; i++) {
						$.tmpl(pageTmpl, i, {
							cur : page
						}).appendTo(pagenum);
					}
				}
			}
			$.tmpl(pageTmpl, maxpage, {
				cur : page
			}).appendTo(pagenum);
	
			if(page == maxpage) {
				pageNext.addClass('hidden');
			} else {
				pageNext.removeClass('hidden');
			}
			if(page == 1) {
				pagePre.addClass('hidden');
			} else {
				pagePre.removeClass('hidden');
			}
			var p = this;
			$('#pre').unbind().click(function(event) {
				p.page -= 1;
				p.render();
			});
			$('#next').unbind().click(function(event) {
				p.page += 1;
				p.render();
			});
			$('#pagenum a').click(function(event) {
				var action = this.rel.replace('e:', '');
				p.page = parseInt(action);
				p.render();
			});
			$('#pager').show().removeClass('hidden');
		} else {
			$('#pager').addClass('hidden');
		}
	}
};

$(document).ready(function(){
	//tk.init();
});

