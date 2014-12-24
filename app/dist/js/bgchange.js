// 背景图片设置插件 作者：陈劲全 QQ：820094076
$(document).ready(function() {
	//读取背景图片设置
	var bgnum;
	var lStorge = window.localStorage;
	if(lStorge){
		bgnum = lStorge.getItem("bgnum");
		}else{
		bgnum =	$.cookie("bgnum");
			}
	if(bgnum==null){
			$("#web_bg img").attr("src", "dist/img/bg2.jpg");
			}else{
				$("#web_bg img").attr("src", "dist/img/bg" + bgnum + ".jpg");
				}
	
	
	});
	function chbg(num){
	//切换背景
	//$.cookie("bgnum",null); 
	$("#web_bg img").attr("src","dist/img/bg"+num+".jpg");
	var lStorge = window.localStorage;
	if(lStorge){
	lStorge.setItem("bgnum",num);//优先设置HTML5本地存储	
	}else{
	$.cookie("bgnum",num,{expires:7});  //设置背景保存cookie10天
	}
	}