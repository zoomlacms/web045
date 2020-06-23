<%@ Page Language="C#" AutoEventWireup="true" CodeFile="getOrderInfo.aspx.cs" Inherits="ZoomLaCMS.Cart.getOrderInfo"  MasterPageFile="~/Cart/order.master" EnableViewStateMac="true"%>
<asp:Content runat="server" ContentPlaceHolderID="head">
<script src="/JS/Controls/ZL_Dialog.js"></script>
<script src="/JS/ICMS/ZL_Common.js"></script>
<title>订单结算</title>
<style>
.head_div { padding-top:10px; padding-left:15px; padding-right:15px; background:#fff;}
.head_div img { height:auto; max-height:5em; max-width:100%;}
.getorder_title { padding-left:15px; padding-right:15px; padding-top:10px; padding-bottom:10px; font-size:1.285em; border-bottom:1px solid #ddd; text-align:center;}
.getorder_title span { display:none;}
.getorder_title img { max-width:50%;}
.addresssul .active { background:none;}
#Address_Div { }
.Address_Div_t { padding-left:15px; padding-right:15px; padding-top:10px; padding-bottom:10px; color:#000; border-bottom:1px solid #ddd; font-size:1.1em;}
.Address_Div_c { padding-left:15px; padding-right:15px; padding-bottom:10px; padding-bottom:10px; border-bottom:1px solid #ddd;}
.addresssul { margin-bottom:0;}
.addresssul li { padding-left:0;}
.getorder_prolist { }
.getorder_prolist .media { padding-left:15px; padding-right:15px; padding-top:10px; padding-bottom:10px; border-bottom:1px solid #f0f0f0;}
.getorder_prolist .media-heading { font-size:1.1em;}
.getorder_prolist .media-left img { width:72px; height:72px;}
.getorder_prolist .media-body p { margin-bottom:0; font-size:0.875em; color:#999;}
.getorder_pro {}
.getorder_pro_t { padding-left:15px; padding-right:15px; padding-top:10px; padding-bottom:10px; color:#000; border-bottom:1px solid #ddd; font-size:1.1em;}
.getorder_pro_t span { margin-top:3px; font-size:0.8em;}
.getorder_pro_t span a { }
.storename { padding-left:15px; padding-right:15px; padding-top:5px; padding-bottom:5px; border-bottom:1px solid #f0f0f0;}
.getorder_pro_s { margin-top:5px;}
.getorder_pro_p { margin-top:5px;}
.extenddiv { margin-left:0;}
#arrive_empty_div .alert { margin-top:10px; margin-bottom:10px;}
.extend_ul { margin-bottom:0; padding-left:15px; padding-right:15px; padding-top:10px; padding-bottom:10px; border-bottom:1px solid #ddd;}
.total_div { position:fixed; left:0; bottom:0; padding-top:8px; padding-bottom:8px; width:100%; height:auto; line-height:normal; border-top:1px solid #ddd;}
@media screen and (max-width:768px){ /*小于768px私有*/
.getorder_title span { float:none; display:block; text-align:center;}
.getorder_title img { float:right; max-width:100%;}

}
</style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">


<div class="container gray_border padding0_xs" style="background:#fff;">
<div class="getorder_title">
<span>填写并核对订单信息</span>
<img src="/App_Themes/User/step2.png" alt="购物流程" />
<div class="clearfix"></div>
</div>

<asp:HiddenField ID="address_HD" runat="server" Value="0" />
<div runat="server" id="Address_Div">
<div class="Address_Div_t"><i class="fa fa-pencil-square-o strong"></i> 收货人信息</div>
<div class="Address_Div_c">
<ul class="addresssul">
<asp:Repeater runat="server" ID="AddressRPT">
<ItemTemplate>
<li id="addli_<%#Eval("ID") %>">
<label class="normalw"><input type="radio" name="address_rad" value="<%#Eval("ID") %>" /><%#GetAddress() %></label>
<span>
<%#GetIsDef() %>
<a href="address.aspx?id=<%#Eval("ID") %>&ids=<%= Request.QueryString["ids"] %>&ProClass=<%= Request.QueryString["ProClass"] %>&remark=<%= Request.QueryString["remark"] %>">修改</a>
<a href="javascript:;" onclick="DelAddress(<%#Eval("ID") %>);">删除</a>
</span>
</li>
</ItemTemplate>
</asp:Repeater>
</ul>
<div runat="server" id="EmptyDiv" class="r_red" visible="false">你没有收货地址,请先填写收货地址</div>
<button type="button" class="btn btn-info btn-xs margin_l20" onclick="AddAddress();"><i class="fa fa-adn"></i> 添加新地址</button>
</div>
</div>
<div class="bordered" hidden>
<p><i class="fa fa-th strong"> 发票信息</i></p>
<div class="indent">
<label>
<input type="radio" name="invoice_rad" value="0" onclick="$('#invoice_div').hide();" checked="checked"/>不开发票</label>
<label><input type="radio" name="invoice_rad" value="1" onclick="$('#invoice_div').show();" />需要发票</label><br />
<div id="invoice_div">
<ul class="addresssul indent padding0">
<asp:Repeater ID="Invoice_RPT" runat="server">
<ItemTemplate>
<li>
<label class="normalw"><input class="invoice_item_rad" name="invoice_item_rad" type="radio" value='<%#Eval("Detail") %>' data-head="<%#Eval("Head") %>" /><%#Eval("Head") %></label>
</li>
</ItemTemplate>
<FooterTemplate> 
<li><label class="normalw"><input class="invoice_item_rad" name="invoice_item_rad" type="radio" value='' data-head=""/>使用新发票</label></li>
</FooterTemplate>
</asp:Repeater>
</ul>
<div>
<asp:TextBox runat="server" ID="InvoTitle_T" CssClass="form-control text_400 margin_t5" MaxLength="50" placeholder="发票抬头（个人或公司名称）"/> 
<asp:TextBox runat="server" ID="Invoice_T" TextMode="MultiLine" class="form-control invoice_t" MaxLength="180" placeholder="在此输入发票开具科目明细" />
</div>
</div>
</div>
</div>
<div class="getorder_pro">
<div class="getorder_pro_t"><i class="fa fa-cubes"></i>商品清单
<span class="pull-right">
<a runat="server" id="ReUrl_A1" visible="false" title="返回购物车">返回修改购物车</a>
<a runat="server" id="ReUrl_A2" visible="false">返回修改信息</a>
</span>
</div>
<div class="getorder_pro_c">
<asp:Repeater runat="server" ID="Store_RPT" OnItemDataBound="Store_RPT_ItemDataBound" EnableViewState="false">
<ItemTemplate>
<div class="storename"><%#Eval("StoreName") %></div>
<div class="getorder_prolist">
<asp:Repeater runat="server" ID="ProRPT" EnableViewState="false">
<ItemTemplate>
<div class="media" data-proid="<%# Eval("Proid") %>">
<div class="media-left media-middle"><a href="<%#GetShopUrl() %>" title="<%#Eval("Proname")%>"><img class="media-object" src="<%#GetImgUrl(Eval("Thumbnails"))%>" alt="<%#Eval("Proname")%>" /></a></div>
<div class="media-body">
<h4 class="media-heading"><a href="<%#GetShopUrl() %>" title="<%#Eval("ProName") %>"><%#Eval("ProName") %></a></h4>
<p>
数量：x <%#Eval("Pronum") %><br/>
优惠：<%#GetDisCount()%><br/>
总价：<span style="color:#c00;"><i class="fa fa-rmb"></i> <%#Eval("AllMoney","{0:F2}") %></span>
</p>
</div>
</div>
</ItemTemplate>
</asp:Repeater>
</div>
<div class="weui-cells weui-cells__form getorder_pro_s">
<div class="weui-cell">
<div class="weui-cell_hd"><label class="weui-label">配送方式</label></div>
<div class="weui-cell__bd weui-cell__primary">
<asp:Literal runat="server" ID="FareType_L" EnableViewState="false"></asp:Literal>
</div>
</div>
</div>

</ItemTemplate>
</asp:Repeater>
<div class="weui-cells getorder_pro_p">

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p><span runat="server" id="itemnum_span" class="r_red_x">1</span>件商品</p></div>
<div class="weui-cell__ft">总商品金额：<i class="fa fa-rmb"></i> <span runat="server" id="totalmoney_span1">0.00</span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>余额</p></div>
<div class="weui-cell__ft"><span id="totalPurse_sp"></span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>积分</p></div>
<div class="weui-cell__ft"><span id="totalPoint_sp"></span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>优惠卷</p></div>
<div class="weui-cell__ft"><i class="fa fa-rmb"></i> <span id="arrive_money_sp">0.00</span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>积分折扣</p></div>
<div class="weui-cell__ft"><i class="fa fa-rmb"></i> <span id="point_money_sp">0.00</span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>运费</p></div>
<div class="weui-cell__ft"><i class="fa fa-rmb"></i> <span id="fare_span">0.00</span></div>
</div>

<div class="weui-cell">
<div class="weui-cell__bd weui-cell__primary"><p>应付总额</p></div>
<div class="weui-cell__ft" style="color:#f00;"><i class="fa fa-rmb"></i> <span runat="server" id="totalmoney_span2">0.00</span></div>
</div>

</div>


<ul class="extend_ul">
<li runat="server" visible="false" id="userli">
<p><a href="javascript:;" onclick="$('#userlist_div').toggle();" title="显示顾客详情"><i class="fa fa-users"> 顾客与联系人列表</i></a></p>
<div id="userlist_div" class="extenddiv" style="display:block;">
<table class="table table-bordered">
<tr>
<td class="td_m">姓名</td><td>证件号</td><td>手机</td>
</tr>
<asp:Repeater runat="server" ID="UserRPT" EnableViewState="false">
<ItemTemplate><tr><td><%#Eval("Name") %></td><td><%#Eval("CertCode") %></td><td><%#Eval("Mobile") %></td></tr></ItemTemplate>
</asp:Repeater>
</table>
</div>
</li>
<li>
    <div><a href="javascript:;" onclick="$('#arrive_div').toggle();"><i class="fa fa-plus-circle">优惠券</i></a></div>
    <asp:Literal runat="server" ID="Arrive_Lit" EnableViewState="false"></asp:Literal>
</li>
<li id="point_li">
<div><a href="javascript:;" onclick="$('.point_div').toggle();"><i class="fa fa-plus-circle"></i> 积分抵扣</a></div>
<div id="point_body" runat="server" visible="false" class="extenddiv point_div">
共<asp:Label ID="Point_L" runat="server"></asp:Label>个积分,本次可用<span id="usepoint_span" class="r_red"></span>个积分,<asp:TextBox runat="server" ID="Point_T" Text="0" onkeyup="checkMyPoint(this);" CssClass="form-control text_150 num"/>
</div>
<div id="point_tips" runat="server" visible="false" class="alert alert-warning point_div extenddiv" role="alert">
<i class="fa fa-exclamation-circle"></i> 积分抵扣已关闭!
</div>
</li>
<li>
<div hidden><a href="javascript:;" onclick="$('#oremind_div').toggle();"><i class="fa fa-plus-circle"></i> 订单备注</a></div>
<div id="oremind_div" class="extenddiv" hidden>
<p>提示：有什么需要对商家说</p>
<asp:TextBox runat="server" TextMode="MultiLine" Rows="3" ID="ORemind_T" CssClass="form-control" MaxLength="100" placeholder="限100个字" />
</div>
</li>
</ul>
</div>
</div>
<div style="height:52px;"></div>

<div class="total_div">
<asp:Button runat="server" CssClass="btn btn-danger pull-right onSub" ID="AddOrder_Btn" Text="提交订单" OnClientClick="disBtn(this,5000);" OnClick="AddOrder_Btn_Click" />
<span class="total pull-right" style="margin-top:5px;">应付总额：<i class="fa fa-rmb"></i> <span runat="server" id="totalmoney_i" style="color:#f00; font-size:20px;">0.00</span></span>
<div class="clearfix"></div>
</div>
</div>
<asp:HiddenField ID="PointRate_Hid" runat="server" />
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
<script src="/JS/Modal/APIResult.js"></script>
<script>
$(function () {
	//地址
	if ($(".addresssul li").length > 0) {
		$(".addresssul li").click(function () {
			$(this).siblings().removeClass("active");
			$(this).addClass("active");
		});
		$(".addresssul li:first").click(); $(":radio[name=address_rad]")[0].checked = true;
	}
	//付款方式
	$(".methodul li").click(function () {
		$(this).siblings().removeClass("active");
		$(this).addClass("active");
		$(this).find(":radio")[0].checked = true;
	})
	$(".methodul li:first").click();
	//发票
	$(".invoice_item_rad").click(function () {
		$("#InvoTitle_T").val($(this).data("head"));
		$("#Invoice_T").val($(this).val());
	});
	$(".invoice_item_rad:first").click();
	//运费
	$(".fare_select").change(function () {
		UpdateTotalPrice();
	});
	//优惠券
	arrive.init();
	UpdateTotalPrice();
	IsDisBtn();
	ZL_Regex.B_Num(".num")
})
var diag = new ZL_Dialog();
diag.width = "minwidth";
diag.maxbtn = false;
function AddAddress() {
	diag.title = "添加新地址";
	diag.url = "address.aspx";
	diag.ShowModal();
}
function EditAddress(id) {
	diag.title = "修改地址";
	diag.url = "address.aspx?id=" + id;
	diag.ShowModal();
}
function DelAddress(myid) {
	if (confirm("确定要删除吗")) {
		$("#addli_" + myid).remove();
		$.post("ordercom.ashx", { action: "deladdress", id: myid }, function () {
		});
	}
}
function SelInvo(dp) {
	if ($(dp).val() != "") {
		$("#InvoTitle_T").val($(dp).find(":selected").text());
		$("#Invoice_T").val($(dp).val());
	}
}
//价格统计
function UpdateTotalPrice() {
    var total = parseFloat($("#totalmoney_span1").text());
    var arrive = parseFloat($("#arrive_money_sp").text());
    var point = parseFloat($("#point_money_sp").text());
    var fare = 0;
    //根据所选,计算运费
    $(".fare_select").each(function () {
        fare += parseFloat($(this).find("option:selected").data("price"));
    });
    total = (total + arrive + fare - point);
    total = total > 0 ? total : 0;
    $("#fare_span").text(fare.toFixed(2));
    $("#totalmoney_span2").text(total.toFixed(2));
    $("#totalmoney_i").text(total.toFixed(2));
    $("#totalPurse_sp").text(GetSumByFilter(".purse_sp"));
    $("#totalSicon_sp").text(GetSumByFilter(".sicon_sp"));
    $("#totalPoint_sp").text(GetSumByFilter(".point_sp"));
}
//计算可用积分抵扣
function SumByPoint(usepoint) {
    var point = parseFloat($("#Point_L").text());
    if (usepoint > point) { usepoint = point; };
    $("#usepoint_span").text(usepoint);
    $("#Point_T").change(function () {
        var point = Convert.ToDouble(this.value);
        if (point > usepoint) { point = usepoint; }
        this.value = point;
    });
}
function GetSumByFilter(filter) {
    var total = 0.00;
    $(filter).each(function () {
        var price = parseFloat($(this).text());
        if (price) total += price;
    });
    return total.toFixed(2);
}
//是否禁用按钮
function IsDisBtn() {
	var flag = false;
	if ($("#Address_Div").length > 0 && $(".addresssul li").length < 1) { flag = true; }
	if ($(".stockout").length > 0) { flag = true; }
	if ($(".getorder_prolist .media[data-proid='109']").length>0) { flag=false; }
	if (flag)
	{ disBtn(document.getElementById("AddOrder_Btn")); }
}
function Refresh() { diag.CloseModal(); location = location; }
function checkMyPoint(obj) {
    if (isNaN(parseFloat($(obj).val()))) { $(obj).val("0"); }
    var val = parseFloat($(obj).val());
    var usepoint = parseFloat($("#usepoint_span").text());//可用积分
    if (usepoint <= val) { val = usepoint;};
    var pointrate = parseFloat($("#PointRate_Hid").val());
    $("#point_money_sp").text((val * pointrate).toFixed(2));
    UpdateTotalPrice();
}
//--------------
var arrive = {};
arrive.init = function () {
    $("#arrive_active_ul .item").click(function () {
        var $this = $(this);
        if ($this.hasClass("choose")) {//取消使用
            $this.removeClass("choose");
            arrive.use("");
        }
        else {
            $(".arrive_o .item").removeClass("choose");
            $this.addClass("choose");
            arrive.use($this.data("flow"));
        }
    });
}
arrive.use = function (flow) {
    var model = { action: "arrive", "flow": flow, money: $("#totalmoney_span1").text(), ids: "<%=Request["ids"]%>" };
        if (flow == "") {
            $("#arrive_money_sp").text("-0.00"); $("#Arrive_Hid").val(flow); UpdateTotalPrice(); return;
        }
        $.post("ordercom.ashx", model, function (data) {
            var model = APIResult.getModel(data);
            if (APIResult.isok(model)) {
                $("#arrive_money_sp").text("-" + parseFloat(model.result.amount).toFixed(2));
            }
            else { $("#arrive_money_sp").text("-0.00"); alert(model.retmsg); }
            $("#Arrive_Hid").val(flow);
            UpdateTotalPrice();
        });
    }
$().ready(function(e) {
    $(".fare_select").addClass("form-control input-sm");
    if ($(".getorder_prolist .media[data-proid='109']").length>0) {
        $("#address_HD").val("1");
        $("#Address_Div").hide();
    }
});
</script>
</asp:Content>