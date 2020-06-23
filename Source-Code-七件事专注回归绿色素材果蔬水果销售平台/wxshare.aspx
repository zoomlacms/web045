<%@ Page Language="C#" AutoEventWireup="true" CodeFile="wxshare.aspx.cs" Inherits="wxshare" Debug="true" %>
<!DOCTYPE HTML>
<html>
<head runat="server">
<meta charset="utf-8">
<meta name="msapplication-TileColor" content="#1A0066"/>
<meta name="msapplication-TileImage" content="/images/win8_symbol_140x140.png"/>
<title>分享推广七件事生鲜</title>
<meta name="Keywords" content="META关键字">
<meta name="Description" content="META网页描述">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<link href="/dist/css/bootstrap.min.css" rel="stylesheet"/>
<!--[if lt IE 9]>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="/JS/jquery-1.11.1.min.js" ></script>
<script src="/dist/js/bootstrap.min.js"></script>
<link href="/dist/css/font-awesome.min.css" rel="stylesheet"/>
<link href="<%Call.Label("{$CssDir/}"); %>global.css" rel="stylesheet"/>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<link href="/dist/css/weui.min.css" rel="stylesheet"/>
<script>
    $.post("/API/UserCheck.ashx?action=HasLogged", "", function (data) {
        if (!data || data == "-1") {
            location = "/wxpromo.aspx?r=" + window.location.href;
        }
    });
    wx.config({
        appId: '<%=appMod.APPID%>', // 必填，公众号的唯一标识
        debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
        jsApiList: ["onMenuShareAppMessage", "onMenuShareTimeline"], // 必填，需要使用的JS接口列表，所有JS接口列表见附录2
        nonceStr: '<%=nonceStr%>', // 必填，生成签名的随机串
        signature: '<%=paySign%>',// 必填，签名，见附录1
        timestamp: '<%=timestr%>' // 必填，生成签名的时间戳
    });
    wx.ready(function () {
        // config信息验证后会执行ready方法，所有接口调用都必须在config接口获得结果之后，config是一个客户端的异步操作，所以如果需要在页面加载时就调用相关接口，则须把相关接口放在ready函数中调用来确保正确执行。对于用户触发时才调用的接口，则可以直接调用，不需要放在ready函数中。
        wx.onMenuShareAppMessage({
            title: '我是<%=NickName.Text%>,我为七件事生鲜代言', // 分享标题
            desc: '武汉生鲜配送七件事生活网是武汉第一家网上买菜网,集生鲜、蔬菜、水果网上订购超市,线下社区配送服务商,提供武汉生鲜配送,武汉网上买菜,武汉生鲜网,武汉蔬菜配送', // 分享描述
            link: '<%Call.Label("{$SiteURL/}");%>/wxpromo.aspx?r=/User/&userid=<%Call.Label("{ZL:GetuserID()/}"); %>', // 分享链接
            imgUrl: '<%Call.Label("{$SiteURL/}");%>/UploadFiles/bLOGO.jpg', // 分享图标
            type: '', // 分享类型,music、video或link，不填默认为link
            dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
            success: function () {
                // 用户确认分享后执行的回调函数
            },
            cancel: function () {
                // 用户取消分享后执行的回调函数
            }
        });
        wx.onMenuShareTimeline({
            title: '我是<%=NickName.Text%>,我为七件事生鲜代言', // 分享标题
            desc: '武汉生鲜配送七件事生活网是武汉第一家网上买菜网,集生鲜、蔬菜、水果网上订购超市,线下社区配送服务商,提供武汉生鲜配送,武汉网上买菜,武汉生鲜网,武汉蔬菜配送', // 分享描述
            link: '<%Call.Label("{$SiteURL/}");%>/wxpromo.aspx?r=/User/&userid=<%Call.Label("{ZL:GetuserID()/}"); %>', // 分享链接
            imgUrl: '<%Call.Label("{$SiteURL/}");%>/UploadFiles/bLOGO.jpg', // 分享图标
            success: function () {
                // 用户确认分享后执行的回调函数
            },
            cancel: function () {
                // 用户取消分享后执行的回调函数
            }
        });
    });
</script>
<style>
body { position:static; left:auto; right:auto;}
.mobile_footer li a { color:#ff7000;}
.weixin_bottom { background:rgba(239, 230, 231, 0.78);}
</style>
</head>
<body>
<form id="form1" runat="server">
<div class="tui_body">
<div class="tui_body_t">
<h1>七件事生鲜</h1>
<asp:Image ID="Image1" runat="server" AlternateText="推广二维码" Width="240" />
</div>
<div class="tui_body_b">
<h3>长按上图/识别图中二维码/轻松搞定!</h3>
<div class="media">
<div class="media-left"><img class="media-object" id="userface" runat="server" src="" alt="" onerror="javascript:this.src='/Images/userface/noface.png';" /></div>
<div class="media-body">
<h4 class="media-heading">我是<asp:Label ID="NickName" runat="server" Text=""></asp:Label></h4>
<p>我为<span>七件事生鲜</span>代言</p>
</div>
</div>
</div>
<%Call.Label("{ZL.Label id=\"微信底部\"/}");%>
</div>
</form>
</body>
</html>
<script>
//微信弹出菜单效果
$(function(){
	//menu float
	var menufloatclicknumber=0;
	function menufloatin(){
		$(".menu-c").removeClass("out");
		$("#menufloat").addClass("show")
		$(".mask_menu").fadeIn();
		$("#menufloat-c").show();
		$(".menu-c-inner").removeClass("outer");
		$(".menu-c-inner").addClass("in")
		$(".menu-c-inner a").show();
		menufloatclicknumber=1;
	}
	function menufloatout(){
		$("#menufloat").removeClass("show")
		$(".mask_menu").fadeOut();
		$(".menu-c-inner").removeClass("in")
		$(".menu-c-inner").addClass("outer")
		$(".menu-c-inner a").hide();
		$(".menu-c").addClass("out");
		menufloatclicknumber=0;		
	}
	$("#menufloat").click(function(){
		if(menufloatclicknumber==0){ menufloatin(); }
		else { menufloatout();}			 	
	})
	$(".mask_menu").click(function(){
		menufloatout(); 
	})
});
</script>