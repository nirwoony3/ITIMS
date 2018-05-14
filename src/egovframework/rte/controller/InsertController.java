package egovframework.rte.controller;

import java.io.File;
import java.io.IOException;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;

import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import egovframework.rte.service.InsertService;
import egovframework.rte.vo.D_ApprprocVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.VaultVo;

@Controller
public class InsertController {
	@Resource(name="insertService")
	InsertService insertService;
	
	@Resource(name = "txManager")
	protected DataSourceTransactionManager txManager;
	

	@RequestMapping(value = "/insertApprproc.do") 
	@ResponseBody
	public void insertApprproc(D_ApprprocVO approcvo, HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >> insertApprproc << ");
		System.out.println(approcvo);

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();

		try {
			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");
			
			approcvo.setCreator(uservo.getUserno());
			approcvo.setCreatordept(uservo.getUserdeptname());
			approcvo.setCreatorname(uservo.getUsername());
			
			rtnmsg = insertService.insertApprproc(approcvo);
			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			System.out.println("rtnmsg : " +rtnmsg);
			if(rtncode){txManager.commit(txStauts); System.out.println("커밋");}
			else{txManager.rollback(txStauts); System.out.println("롤백");}

			System.out.println("rtnmsg / rtncode : " +rtnmsg + " / "+ rtncode);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}
}
