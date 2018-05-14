package egovframework.rte.controller;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.rte.cmmn.ResultSetConverter;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.service.VaultService;
import egovframework.rte.vo.VaultVo;

@Controller
public class VaultMVC1Controller {

	/** EgovSampleService */
	/*@Resource(name = "sampleService")
	private EgovSampleService sampleService;*/

	@Resource(name = "vaultService")
	private VaultService vaultService;

	/** EgovPropertyService */
	@Resource(name = "propertiesService")
	protected EgovPropertyService propertiesService;

	/** Validator */
	@Resource(name = "beanValidator")
	protected DefaultBeanValidator beanValidator;

	DataSource pool = null;

	public VaultMVC1Controller() {
		// TODO Auto-generated constructor stub

		try {
			//pool
			// Create a JNDI Initial context to be able to lookup the DataSource
			InitialContext ctx = new InitialContext();
			// Lookup the DataSource, which will be backed by a pool
			// that the application server provides.
			pool = (DataSource) ctx.lookup("java:comp/env/jdbc/D_VAULTLIST");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@RequestMapping(value = "/getDocdb1List.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public void viewGrid(@ModelAttribute("param") HashMap<String, String> map, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		//System.out.println("파라미터 사이즈 : " + map.size());
		System.out.println(">>  getDocdb1List.do  <<");
		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jsonArr = new JSONArray();

		Connection conn = null;
		ResultSet rst = null;
		PreparedStatement pstmt = null;

		res.setCharacterEncoding("UTF-8"); 
		res.setHeader("Content-Type", "text/html; charset=UTF-8");
		String vaultlNo ="", tempNo="", docdbname="", sql ="", docdesc ="", docname="", docfilename="",
				propdate1="", propdate2="", creator="";
		int pageNum = 1;

		try {
			System.out.println("Conn 준비");
			conn = pool.getConnection();
			System.out.println("Conn 완료");
			//String vaultlNo = vaultVo.getVaultlNo();
			//String vaultlNo = map.get("vaultlNo");
			vaultlNo = req.getParameter("vaultlNo");
			tempNo = req.getParameter("pageNum");
			docdbname = req.getParameter("docdbname");

			docdesc = req.getParameter("docdesc");
			docname = req.getParameter("docname");
			docfilename = req.getParameter("docfilename");
			propdate1 = req.getParameter("propdate1");
			propdate2 = req.getParameter("propdate2");
			creator = req.getParameter("creator");


			//if(map.get("pageNo") != null) {
			if(tempNo != null) {
				//String tempNo = map.get("pageNo");
				pageNum = Integer.parseInt(tempNo);

			}

			System.out.println("vaultlNo / pageNum / docdbname : " + vaultlNo + " / " + pageNum + " / " + docdbname);
			System.out.println("docdesc / docname / docfilename : " + docdesc + " / " + docname + " / " + docfilename);
			System.out.println("propdate1 / propdate2 / creator : " + propdate1 + " / " + propdate2 + " / " + creator);

			//String sql = "SELECT * FROM D_DOCDB1 WHERE VAULTLNO = '" + vaultlNo + "' ORDER BY DOCNO";
			sql = "SELECT * FROM (SELECT A.*, ROWNUM AS RNUM, COUNT(*) OVER() AS TOTCNT, (COUNT(*) OVER())/10 AS PAGENUM FROM "
					+ "(SELECT X.* FROM "+docdbname+" X WHERE DOCNO IS NOT NULL ";
			if(docdesc != null && !docdesc.equals("")){
				sql += "AND X.DOCDESC LIKE '%" + docdesc + "%'";
			}
			if(docname != null && !docname.equals("")){
				sql += "AND X.DOCNAME LIKE '%" + docname + "%'";
			}
			if(docfilename != null && !docfilename.equals("")){
				sql += "AND X.DOCFILENAME LIKE '%" + docfilename + "%'";
			}
			if(propdate1 != null && !propdate1.equals("") && propdate2 != null && !propdate2.equals("")){
				sql += "AND X.DOCCREATED BETWEEN '" + propdate1 + "' AND '" + propdate2 + "'";
			}
			if(creator != null && !creator.equals("")){
				sql += "AND X.DOCCREATOR LIKE '%" + creator + "%'";
			}
			if(vaultlNo != null && !vaultlNo.equals("")){
				sql += "AND X.VAULTLNO LIKE '%" + vaultlNo + "%'";
			}

			sql += ") A) WHERE RNUM BETWEEN ("+ pageNum +"-1)*200 + 1 AND " + pageNum +"*200";
			System.out.println("쿼리 : >>" + sql);
			// -------------------------------------------------------------------------- // 

			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();

			jsonArr = resConv.convert(rst);
			System.out.println("사이즈 : "+jsonArr.size());

			JSONArray jsonArrayList = new JSONArray();  //JSONArray 생성

			for (int i = 0; i < jsonArr.size(); i++) {
				//System.out.println("jsonArr.get(" + i +") => " + jsonArr.get(i));	
				JSONObject indicatorJObj = JSONObject.fromObject(jsonArr.get(i));
				jsonArrayList.add(indicatorJObj);
			}

			res.getWriter().write(jsonArr.toString()); 
			// System.out.println(jsonArr.toString());

			//res.getWriter().write(jsonArrayList.toString()); 
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			conn.close();
			pstmt.close();
			rst.close();
		}
	}

	//@RequestMapping(value = "/columList.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public void columList(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		System.out.println("MVC1 Controller");
		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jsonArr = new JSONArray();

		Connection conn = null;
		ResultSet rst = null;
		PreparedStatement pstmt = null;

		res.setCharacterEncoding("UTF-8"); 
		res.setHeader("Content-Type", "text/html; charset=UTF-8");

		try {
			conn = pool.getConnection();

			String vaultlNo = req.getParameter("vaultlNo");
			String keyWord = req.getParameter("keyWord");

			switch(keyWord) {

			case "DOC" : keyWord = "DOCDBNAME";
			break;
			case "SUB" : keyWord = "SUBDBNAME";
			break;
			case "STR" : keyWord = "STORAGENO";
			break;
			}

			String sql = "SELECT DISTINCT "+ keyWord;

			if(vaultlNo != null) {
				System.out.println("columList.do // vaultlNo = "+vaultlNo);
				sql += " (SELECT COUNT(*) FROM D_DOCDB1 WHERE VAULTLNO = '" + vaultlNo + "') DATACOUNT"; 
			}

			sql += " FROM D_VAULTLIST WHERE NOT '"+ keyWord + "' = '*'";
			System.out.println("쿼리 : >>" + sql);

			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();

			jsonArr = resConv.convert(rst);

			res.getWriter().write(jsonArr.toString()); 
			System.out.println(jsonArr.toString());			

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			conn.close();
			pstmt.close();
			rst.close();
		}
	}
}
