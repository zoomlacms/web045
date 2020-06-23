<%@ WebHandler Language="C#" Class="wxapp" %>
using Newtonsoft.Json;
using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ZoomLa.BLL.API;
using ZoomLa.SQLDAL;
using ZoomLa.SQLDAL.SQL;
using ZoomLa.Model;
using ZoomLa.BLL;

public class wxapp :IHttpHandler
{
    B_Node nodeBll = new B_Node();
    const string ApiKey = "ZLWXAPP137934j&21";
    public M_APIResult retMod = new M_APIResult();
    public string Action { get { return Req("Action").ToLower(); } }
    public string Req(string name) { return HttpContext.Current.Request[name] ?? ""; }
    public void RepToClient(M_APIResult result)
    {
        result.action = Action;
        HttpResponse rep = HttpContext.Current.Response;
        rep.Clear(); rep.Write(result.ToString()); rep.Flush(); rep.End();
    }
    B_Content conBll = new B_Content();
    public void ProcessRequest(HttpContext context)
    {
        retMod.retcode = M_APIResult.Failed;
        //retMod.callback = CallBack;//暂不开放JsonP
        try
        {
            switch (Action)
            {
                case "nodes"://分类节点信息
                    {
                        DataTable nodeDT = nodeBll.SelByPid(2);
                        nodeDT = nodeDT.DefaultView.ToTable(true, "NodeID", "NodeName");
                        retMod.result = JsonConvert.SerializeObject(nodeDT);
                        retMod.retcode = M_APIResult.Success;
                    }
                    break;
                case "index_tops"://首页推荐滚动图与商品
                    {

                    }
                    break;
                case "pro_list_top"://推荐商品列表
                    {

                    }
                    break;
                case "pro_info"://商品详情信息
                    break;
                case "pro_list"://根据节点等条件获取商品列表
                    break;
                case "user_info":
                    break;
                //case "list":
                //    {
                //        int nid = DataConvert.CLng(Req("nid"));
                //        string where = "ModelID=" + 50;
                //        if (nid > 0) { where += " AND NodeID=" + nid; }
                //        DataTable dt = DBCenter.JoinQuery("A.GeneralID,A.Title,A.Inputer,A.CreateTime,B.summary,B.thumbimg", "ZL_CommonModel", "ZL_C_wxnr", "A.ItemID=B.ID", where, "A.GeneralID DESC");
                //        retMod.retcode = M_APIResult.Success;
                //        retMod.result = JsonConvert.SerializeObject(dt);
                //    }
                //    break;
                //case "content":
                //    {
                //        int id = DataConvert.CLng(Req("id"));
                //        M_CommonData conMod = conBll.SelReturnModel(id);
                //        if (conMod == null || string.IsNullOrEmpty(conMod.TableName) || conMod.ItemID < 1) { retMod.retmsg = "文章[" + id + "]不存在"; }
                //        else
                //        {
                //            DataTable condt = DBCenter.Sel(conMod.TableName, "ID=" + conMod.ItemID);
                //            if (condt.Rows.Count < 1) { retMod.retmsg = "文章内容不存在"; }
                //            else if (!condt.Columns.Contains("content_txt")) { retMod.retmsg = "文章字段不存在"; }
                //            else
                //            {
                //                M_Content model = new M_Content();
                //                model.title = EncryptHelper.Base64Encrypt(conMod.Title);
                //                model.content = EncryptHelper.Base64Encrypt(DataConvert.CStr(condt.Rows[0]["content_txt"]));
                //                model.content_topimg = DataConvert.CStr(condt.Rows[0]["content_topimg"]);
                //                retMod.retcode=M_APIResult.Success;
                //                retMod.result = JsonConvert.SerializeObject(model);
                //            }
                //        }
                //    }
                //    break;
                case "":
                    break;
                default:
                    retMod.retmsg = "[" + Action + "]接口不存在";
                    break;
            }
        }
        catch (Exception ex) {ZLLog.L(ex.Message); retMod.retmsg = ex.Message; }
        RepToClient(retMod);
    }
    public bool IsReusable { get { return false; } }
}
public class M_Content
{
    public string content{get;set;}
    public string content_topimg{get;set;}
    public string title{get;set;}
}
public class M_Photo
{
    public string title { get; set; }
    public string content { get; set; }
    public string photourl { get; set; }
}