using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZoomLa.SQLDAL;
using ZoomLa.BLL;
using ZoomLa.Model;
using ZoomLa.Common;
using System.Data.SqlClient;
using ZoomLa.Components;
using Newtonsoft.Json;
using ZoomLa.BLL.Shop;

/*
 * 购物车页面根据所传来的ItemID,SkuID,PCount将指定商品加入购物车,按店铺分栏显示
 * 自营商品的店铺StoreID为0
 */

namespace ZoomLaCMS.Cart
{
    public partial class cart : System.Web.UI.Page
    {
        B_OrderBaseField fieldBll = new B_OrderBaseField();
        B_Product proBll = new B_Product();
        B_Cart cartBll = new B_Cart();
        B_User buser = new B_User();
        B_Shop_RegionPrice regionBll = new B_Shop_RegionPrice();
        OrderCommon orderCom = new OrderCommon();
        //仅用于标识显示积分商品,或普通商品,不参与其他逻辑
        public int ProClass { get { return DataConvert.CLng(Request.QueryString["Proclass"]); } }
        //Cookies中的购物车ID
        public string CartCookID
        {
            get
            {
                return B_Cart.GetCartID(Context);
            }
        }
        //用户注册时的区域
        private string Region { get { return ViewState["Region"] as string; } set { ViewState["Region"] = value; } }
        private DataTable CartDT
        {
            get
            {
                return (DataTable)ViewState["CartDT"];
            }
            set { ViewState["CartDT"] = value; }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            M_UserInfo mu = GetLogin();
            if (!IsPostBack)
            {
                ProModel model = new ProModel() { ProID = DataConvert.CLng(Request["ID"]), Pronum = DataConvert.CLng(Request["Pronum"]) };
                model.Pronum = model.Pronum < 1 ? 1 : model.Pronum;
                if (DataConvert.CStr(Request["action"]).Equals("clear"))
                {
                    List<SqlParameter> sp = new List<SqlParameter>() { new SqlParameter("cartid", CartCookID), new SqlParameter("UserName", mu.UserName) };
                    DBCenter.DelByWhere("ZL_Cart", "CartID=@cartid OR UserName=@UserName OR UserID=" + mu.UserID, sp);
                }
                if (model.ProID > 0)//将商品加入购物车
                {
                    M_Product proMod = proBll.GetproductByid(model.ProID);
                    if (proMod == null || proMod.ID < 1) { function.WriteErrMsg("商品不存在"); }
                    if (proMod.ProClass == (int)M_Product.ClassType.IDC) { Response.Redirect("/Cart/FillIDCInfo.aspx?proid=" + proMod.ID); }
                    OrderCommon.ProductCheck(proMod);
                    //-----------------检测完成加入购物车
                    M_Cart cartMod = new M_Cart();
                    cartMod.Cartid = CartCookID;
                    cartMod.StoreID = proMod.UserShopID;
                    cartMod.ProID = model.ProID;
                    cartMod.Pronum = model.Pronum;
                    cartMod.userid = mu.UserID;
                    cartMod.Username = mu.UserName;
                    cartMod.Getip = EnviorHelper.GetUserIP();
                    cartMod.Addtime = DateTime.Now;
                    cartMod.FarePrice = proMod.LinPrice.ToString();
                    cartMod.Proname = proMod.Proname;
                    int id = cartBll.AddModel(cartMod);
                    //ImportExtField(id, Request.Form["ext_hid"]);//模型字段
					
                    Response.Redirect(Request.Url.AbsolutePath + "?ProClass=" + proMod.ProClass + "&remark=" + Request.QueryString["remark"]);
                }
                if (!function.isAjax())
                {
                    MyBind();
                }
            }
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            CartDT = null;
        }
        private void MyBind()
        {
            M_UserInfo mu = buser.GetLogin();
            CartDT = cartBll.SelByCartID(CartCookID, mu.UserID, ProClass);//从数据库中获取
            //对数据再处理,增加购买数管理
            CartDT.Columns.Add(new DataColumn("Pro_Remind", typeof(string)));
            CartDT.Columns.Add(new DataColumn("Pro_Min", typeof(int)));
            CartDT.Columns.Add(new DataColumn("Pro_Max", typeof(int)));
            CartDT.Columns.Add(new DataColumn("Pro_Multi", typeof(int)));
            CartDT.Columns.Add(new DataColumn("Pro_OldPrice",typeof(double)));
            for (int i = 0; i < CartDT.Rows.Count; i++)
            {
                string remind = "";
                DataRow dr = CartDT.Rows[i];
                dr["Pro_OldPrice"] = dr["LinPrice"];
                dr["Pronum"] = CalcProNum(dr, mu.GroupID, ref remind);
                dr["Pro_Remind"] = remind;
                if (Convert.ToInt32(dr["Pro_Max"]) == 0) { CartDT.Rows.Remove(dr); }
            }
            RPT.DataSource = orderCom.SelStoreDT(CartDT);
            RPT.DataBind();
            totalmoney_old.InnerText=TotalPrice_Old.ToString("f2");
            totalmoney.InnerText = TotalPrice.ToString("f2");
        }
        protected void RPT_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView dr = e.Item.DataItem as DataRowView;
                Repeater rpt = e.Item.FindControl("ProRPT") as Repeater;
                CartDT.DefaultView.RowFilter = "StoreID=" + dr["ID"];
                DataTable dt = CartDT.DefaultView.ToTable();
                if (dt.Rows.Count < 1) { e.Item.Visible = false; }
                rpt.DataSource = dt;
                rpt.DataBind();
            }
        }
        protected void ProRPT_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName.ToString())
            {
                case "del":
                    int id = Convert.ToInt32(e.CommandArgument);
                    cartBll.DelByIDS(CartCookID, buser.GetLogin().UserName, id.ToString());
                    break;
            }
            MyBind();
        }
        //将计算出的单价缓存,用于避免重复计算
        private double TempPrice = 0;
        private double TotalPrice = 0;
        private double TotalPrice_Old = 0;//原价,用于展示优惠了多少
        //单项商品小计
        public string GetPrice()
        {
            int pronum = Convert.ToInt32(Eval("Pronum"));
            double total = TempPrice * pronum;
            TotalPrice += total;
            TotalPrice_Old += (DataConvert.CDouble(Eval("Pro_OldPrice")) * pronum);
            return total.ToString("0.00");
        }
        //单价
        public string GetMyPrice()
        {
            int proID = Convert.ToInt32(Eval("ProID"));
            double linPrice = Convert.ToDouble(Eval("LinPrice"));
            M_UserInfo mu = buser.GetLogin();
            M_Product proMod=proBll.GetproductByid(proID);
            //多区域价格
            if (string.IsNullOrEmpty(Region))
            {
                Region = buser.GetRegion(mu.UserID);
            }
            TempPrice = regionBll.GetRegionPrice(proID, linPrice, Region, mu.GroupID);
            //如果多区域价格未匹配,则匹配会员价
            if (TempPrice == linPrice) { TempPrice = proBll.P_GetByUserType(proMod, mu); }

            string html = "<i class='fa fa-rmb'></i><span id='price_" + Eval("ID") + "' data-old='"+Convert.ToDouble(Eval("Pro_OldPrice")).ToString("f2")+"'>" + TempPrice.ToString("f2") + "</span>";
            //if (orderCom.HasPrice(Eval("LinPrice_Json")))
            //{
            //    string json = DataConvert.CStr(Eval("LinPrice_Json"));
            //    M_LinPrice priceMod = JsonConvert.DeserializeObject<M_LinPrice>(json);
            //    if (priceMod.Purse > 0)
            //    {
            //        html += "余额:<span id='price_purse_" + Eval("ID") + "'>" + priceMod.Purse.ToString("f2") + "</span>";
            //    }
            //    if (priceMod.Sicon > 0)
            //    {
            //        html += "|银币:<span id='price_sicon_" + Eval("ID") + "'>" + priceMod.Sicon.ToString("f0") + "</span>";
            //    }
            //    if (priceMod.Point > 0)
            //    {
            //        html += "|积分:<span id='price_point_" + Eval("ID") + "'>" + priceMod.Point.ToString("f0") + "</span>";
            //    }
            //}
            return html;
        }
        //------------------------------Tools
        // 生成购物车编号("Shopby OrderNo"的value) 
        //返回当前登录用户,如未登录,则返回0
        private M_UserInfo GetLogin()
        {
            M_UserInfo mu = buser.GetLogin(false);
            if (mu == null)
            {
                mu = new M_UserInfo();
                mu.UserID = 0;
                mu.UserName = "未登录";
            }
            return mu;
        }
        //批量删除
        protected void BatDel_Click(object sender, EventArgs e)
        {
            string ids = Request.Form["prochk"];
            if (string.IsNullOrEmpty(ids))
            { function.Script(this, "alert('未选择商品');"); }
            else
            {
                cartBll.U_DelByIDS(ids, buser.GetLogin().UserID);
                MyBind();
            }
        }
        //结算,到订单页再生成AllMoney
        protected void NextStep_Click(object sender, EventArgs e)
        {
            //AJAX就先检测一遍,未登录则弹窗
            B_User.CheckIsLogged(Request.RawUrl);
            string ids = Request.Form["prochk"];
            Response.Redirect("GetOrderInfo.aspx?ids=" + ids + "&ProClass=" + ProClass + "&remark=" + Request.QueryString["remark"]);//"#none"
        }
        //-----后期整合
        public string GetShopUrl()
        {
            return orderCom.GetShopUrl(DataConvert.CLng(Eval("StoreID")), Convert.ToInt32(Eval("ProID")));
        }
        public string GetImgUrl(object o)
        {
            return function.GetImgUrl(o);
        }
        public string GetStockStatus()
        {
            if (Eval("Allowed").ToString().Equals("0"))
            {
                int pronum = Convert.ToInt32(Eval("Pronum"));
                int stock = Convert.ToInt32(Eval("Stock"));
                if (stock < pronum)
                {
                    return "<span class='r_red_x'>缺货</span>";
                }
            }
            return "<span class='r_green_x'>有货</span>";
        }
        //根据用户提交的Json数据,提交用户表单,后台调用
        public void ImportExtField(int id, string json)
        {
            DataTable cartFieldDT = fieldBll.Select_Type(1);
            if (!string.IsNullOrEmpty(json) && cartFieldDT.Rows.Count > 0)
            {
                string sql = "Update ZL_Cart Set ", fieldsql = "";
                SqlParameter[] sp = new SqlParameter[cartFieldDT.Rows.Count];
                for (int i = 0; i < cartFieldDT.Rows.Count; i++)
                {
                    DataRow dr = cartFieldDT.Rows[i];
                    string field = dr["FieldName"].ToString();
                    string vname = "@val" + i;
                    string value = JsonHelper.GetVal(json, field);
                    if (string.IsNullOrEmpty(value)) continue;
                    sp[i] = new SqlParameter(vname, value);
                    fieldsql += field + "=" + vname + ",";
                }
                fieldsql = fieldsql.TrimEnd(',');
                sql = sql + fieldsql + " Where ID=" + id;
                if (!string.IsNullOrEmpty(fieldsql))
                    SqlHelper.ExecuteSql(sql, sp);
            }
        }
        //------------------------计算购买数量规则
        //1,如小于最低购买数量自动补足     <=0则为1
        //2,如大于限购,自动扣减            -1:不限,0:禁止,>1限购数量 
        //3,如非指定数量的倍数,则自动倍增
        //4,如会员信息不存在,则不限制(例如添加了新会员组)
        private int CalcProNum(DataRow dr,int gid, ref string remind)
        {
            //  int pronum, int gid, int proid
            int result = Convert.ToInt32(dr["Pronum"]);
            M_Product proMod = proBll.GetproductByid(Convert.ToInt32(dr["ProID"]));
            dr["Pro_Min"] = 1;
            dr["Pro_Max"] = int.MaxValue;
            dr["Pro_Multi"] = 1;
            if (proMod.DownQuota == 2 && !string.IsNullOrEmpty(proMod.DownQuota_Json))
            {
                DataTable dt = JsonConvert.DeserializeObject<DataTable>(proMod.DownQuota_Json);
                DataRow[] drs = dt.Select("gid='" + gid + "'");
                //会员组信息存在,且购买的数量低于最低数量
                if (drs.Length > 0)
                {
                    int num = DataConvert.CLng(drs[0]["value"]);
                    if (num > result)
                    {
                        remind = "<span>最低购买数为" + num + "</span>";
                        result = num;
                    }
                    dr["Pro_Min"] = num < 1 ? 1 : num;
                }
            }
            if (proMod.Quota == 2)
            {
                DataTable dt = JsonConvert.DeserializeObject<DataTable>(proMod.Quota_Json);
                DataRow[] drs = dt.Select("gid='" + gid + "'");
                //会员组信息存在,且购买的数量低于最低数量
                if (drs.Length > 0)
                {
                    int num = DataConvert.CLng(drs[0]["value"]);
                    if (num < result)//不符合则购买
                    {
                        remind = "<span>限购数为" + num + "</span>";
                        result = num;
                    }
                    dr["Pro_Max"] = num < 0 ? int.MaxValue : num;
                }
            }
            if (proMod.DownCar > 1)
            {
                dr["Pro_Multi"] = proMod.DownCar;
                if (result % proMod.DownCar > 0)
                {
                    remind += "<span>调整为" + proMod.DownCar + "的倍数</span>";
                    result = result - (result % proMod.DownCar);
                }
            }
            return result;
        }
    }
}