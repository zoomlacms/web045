﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TemplateSet.aspx.cs" Inherits="ZoomLaCMS.Manage.Template.TemplateSet" MasterPageFile="~/Manage/I/Default.master" %>
<asp:Content runat="server" ContentPlaceHolderID="head">
    <title>方案设置</title>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="Content">
    <ol class="breadcrumb navbar-fixed-top" id="breadcrumb">
        <li><a href="<%=CustomerPageAction.customPath2 %>Main.aspx">工作台</a></li>
        <li><a href="TemplateSet.aspx">模板风格</a></li>
        <li class="active">方案列表</li>
        <div class="pull-right"><a href="TemplateSetOfficial.aspx"><i class="fa fa-cloud-download"></i> 云模板下载 </a></div>
    </ol>
    <div class="template">
        <div class="panel panel-default" style="padding: 0px;">
            <div class="panel-body" style="padding: 0px;">
                <ul class="list-unstyled margin_t10">
                    <ZL:ExRepeater runat="server" ID="RPT" PageSize="12" BoxType="dp" PagePre="</div> <div class='panel-footer text-center'>" PageEnd="</div>" OnItemCommand="RPT_ItemCommand">
                        <ItemTemplate>
                            <li class="padding5">
                                <div class="Template_box">
                                    <div class="tempthumil"><a href="TemplateManage.aspx?setTemplate=<%#Eval("name") %>" title="点击进入模板管理">
                                        <img onmouseover="this.style.border='1px solid #9ac7f0';" onmouseout="this.style.border='1px solid #eeeeee';" alt="点击进入模板管理" onerror="shownopic(this);" src="/Template/<%#Eval("name") %>/view.jpg"></a></div>
                                    <ul class="list_unstyled">
                                        <li class="temp_author"><a href="#" title="作者:<%# GetTlpName("Author")%>"><i class="fa fa-copyright"></i></a><a href="TemplateManage.aspx?setTemplate=<%#Eval("name") %>"><%# GetTlpName("Project")%></a></li>
                                        <li class="temp_isuse">
                                            <asp:LinkButton runat="server" ID="isUse" CommandArgument='<%#Eval("name") %>' CommandName="set"><%#IsDefaultTlp() %></asp:LinkButton></li>
                                        <li class="temp_del">
                                         <a href='/Template/<%#Eval("name") %>/view.jpg' class="lightbox"> <i class="fa fa-eye"></i></a>
                                            <asp:LinkButton runat="server" CommandArgument='<%#Eval("name") %>' CommandName="del2" OnClientClick="return confirm('你确定删除吗');"> <i class="fa fa-trash-o"></i> 删除 </asp:LinkButton>
                                            </li>
                                    </ul>
                                    </span>
                                    <div class="clearfix"></div>
                                </div>
                            </li>
                        </ItemTemplate>
                        <FooterTemplate>
                            <div class="clearfix"></div>
                        </FooterTemplate>
                    </ZL:ExRepeater>
            </div>
            </ul>
        </div>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="ScriptContent">
    <link href="/Plugins/JqueryUI/LightBox/css/lightbox.css" rel="stylesheet" media="screen" />
    <script src="/Plugins/JqueryUI/LightBox/jquery.lightbox.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            base_url = document.location.href.substring(0, document.location.href.indexOf('index.html'), 0);
            $(".lightbox").lightbox({
                fitToScreen: true,
                imageClickClose: false
            });
        });
    </script>
</asp:Content>