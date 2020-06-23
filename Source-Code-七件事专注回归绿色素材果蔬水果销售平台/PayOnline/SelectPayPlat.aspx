﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SelectPayPlat.aspx.cs" Inherits="ZoomLaCMS.PayOnline.SelectPayPlat" EnableViewStateMac="false" MasterPageFile="~/Common/Master/UserEmpty.Master"%>

<asp:Content runat="server" ContentPlaceHolderID="head">
<title>用户充值</title>
<link href="/dist/css/weui.min.css" rel="stylesheet" />
<link href="/Template/7esy/style/global.css?Version=20150909" rel="stylesheet"/>
<style>
.money_list li { margin-top:10px;}
.money_list li a { display:block; padding:15px 15px; box-shadow:0 0 5px rgba(0,0,0,0.40); border-radius:4px; color:#666; line-height:50px; text-decoration:none; background:#fff;}
.money_list li a span.pull-right { margin-top:3px;}
.money_list li a i { color:#999; font-size:2em;}
.money_list li a span.pull-left { display:block; margin-right:5px; width:50px; height:50px; background:#ff7000; border-radius:50px; text-align:center; color:#fff; font-size:1.5em;}
.money_list li:nth-child(1) a span.pull-left { background:#ff302d;}
.money_list li:nth-child(2) a span.pull-left { background:#8e00fe;}
.money_list li:nth-child(3) a span.pull-left { background:#19b2ff;}
.money_list li:nth-child(4) a span.pull-left { background:#ff3968;}
.money_list li:nth-child(5) a span.pull-left { background:#f02c2b;}
</style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
<div class="container padding0_xs">
<div class="user_top">
<div class="user_top_t"><a href="/User/Info/Index"><img src="<%Call.Label("{ZL.Label id=\"获取当前会员头像\"/}");%>" alt="<%Call.Label("{ZL.Label id=\"获取当前用户真实姓名\"/}");%>" onerror="shownoface(this);" /></a></div>
<div class="user_top_p">
会员名称：<%Call.Label("{ZL.Label id=\"获取当前用户真实姓名\"/}");%><br/>
会员组：<%Call.Label("{ZL.Label id=\"获取当前用户会员组\"/}");%><br/>
余额：<a href="/user/Info/ConsumeDetail?SType=1" title="点击查看资金明细"><%Call.Label("{ZL.Label id=\"获取当前用户余额\"/}");%></a>
<span>积分：<%Call.Label("{ZL.Label id=\"获取当前用户积分\"/}");%></span>
</div>
</div>
</div>

<div id="pageflag" data-nav="home" data-ban="UserInfo"></div>
<div class="container padding0_xs hidden-xs">
<ol class="breadcrumb">
<li><a title="会员中心" href="/User/Default">会员中心</a></li>
<li><a href="/User/Info/UserInfo">账户管理</a></li>
<li class="active">用户充值</li>
</ol>
</div>
<div class="container">
<ul class="money_list">
<ZL:ExRepeater runat="server" ID="RPT" PageSize="14" PagePre="<div class='clearfix'></div><div class='text-center'>" PageEnd="</div>">
<ItemTemplate>
<li>
<a href="/PayOnline/OrderPay.aspx?Money=<%# Eval("Min","{0:f2}") %>">
<span class="pull-left"><%# GetIcon() %></span>
充值<%# Eval("Min","{0:f2}") %>元送<%# Eval("Purse","{0:f2}") %>元+<%# Eval("Point","{0:f2}") %>积分 <span class="pull-right"><i class="fa fa-angle-right"></i></span>
</a>
</li>
</ItemTemplate>
</ZL:ExRepeater>
</ul>

<div class="weui-cells weui-cells_form hidden">
<div class="weui-cell">
<div class="weui-cell__hd"><label class="weui-label">用户充值</label></div>
<div class="weui-cell__bd">
<asp:TextBox ID="Money_T" CssClass="form-control" Text="100" runat="server"></asp:TextBox>
<asp:RequiredFieldValidator ID="R2" CssClass="tips" runat="server" ControlToValidate="Money_T" Display="Dynamic" ForeColor="Red" ErrorMessage="金额不能为空" />
<asp:RegularExpressionValidator CssClass="tips" ID="R1" runat="server" ControlToValidate="Money_T" Display="Dynamic" ForeColor="Red" ErrorMessage="金额数值不正确" ValidationExpression="^\d+(\.\d{1,2})?$" />
</div>
</div>
</div>

<div class="weui-btn-area" hidden>
<asp:Button ID="BtnSubmit" CssClass="weui-btn weui-btn_primary" runat="server" Text="前往充值" OnClick="BtnSubmit_Click" />
</div>

</div>
<div style="height:56px;"></div>
<%Call.Label("{ZL.Label id=\"微信底部  \"/}");%>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<script>
             
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
		  if(menufloatclicknumber==0){
		     menufloatin();
			 }
		  else{
		  	 menufloatout();
			  }			 	
		  })
		$(".mask_menu").click(function(){
			menufloatout();
			})
            
</script>
</asp:Content>
