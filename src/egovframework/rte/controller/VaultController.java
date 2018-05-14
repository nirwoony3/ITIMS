/*
 * Copyright 2008-2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package egovframework.rte.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springmodules.validation.commons.DefaultBeanValidator;

import egovframework.rte.cmmn.CommonUtil;
import egovframework.rte.cmmn.FileCon;
import egovframework.rte.fdl.property.EgovPropertyService;
import egovframework.rte.service.VaultService;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.VaultVo;

/**
 * @Class Name : EgovSampleController.java
 * @Description : EgovSample Controller Class
 * @Modification Information
 * @
 * @  수정일      수정자              수정내용
 * @ ---------   ---------   -------------------------------
 * @ 2009.03.16           최초생성
 *
 * @author 개발프레임웍크 실행환경 개발팀
 * @since 2009. 03.16
 * @version 1.0
 * @see
 *
 *  Copyright (C) by MOPAS All right reserved.
 */

@Controller
public class VaultController {

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
	
	@Resource(name = "txManager")
	protected DataSourceTransactionManager txManager;
	

	@RequestMapping(value = "/viewVaultNo.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String viewVaultNo(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		HashMap<String, List<VaultVo>> result = new HashMap<String, List<VaultVo>>();
		CommonUtil commonUtil = new CommonUtil();
		List<VaultVo> vaultList = new ArrayList<VaultVo>();

		vaultList = vaultService.viewVaultNo(vaultVo);
		result.put("vault", vaultList);
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
		
		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}



	@RequestMapping(value = "/getDirectory.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getDirectory(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {

		HashMap<String, List<VaultVo>> result = new HashMap<String, List<VaultVo>>();
		CommonUtil commonUtil = new CommonUtil();
		List<VaultVo> vaultList = new ArrayList<VaultVo>();

		vaultList = vaultService.getDirectory(vaultVo);

		result.put("vault", vaultList); 

		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}

	//@RequestMapping(value = "/viewGrid.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	//	@ResponseBody
	//	public String viewGrid(@ModelAttribute("param") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {
	//
	//		HashMap<String, List<DocDB1Vo>> result = new HashMap<String, List<DocDB1Vo>>();
	//		CommonUtil commonUtil = new CommonUtil();
	//		List<DocDB1Vo> docDB1VoList = new ArrayList<DocDB1Vo>();
	//
	//		docDB1VoList = vaultService.viewGrid(vaultVo.getVaultlNo());
	//		result.put("docDB", docDB1VoList); 
	//
	//		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);
	//
	//		System.out.println("callbackMsg::" + callbackMsg);
	//		return callbackMsg;
	//	}
	//	
	@RequestMapping(value = "/columList.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String columList(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req, HttpServletResponse res) throws Exception {

		HashMap<String, List<VaultVo>> result = new HashMap<String, List<VaultVo>>();
		CommonUtil commonUtil = new CommonUtil();
		List<VaultVo> docdbList = new ArrayList<VaultVo>();
		List<VaultVo> subdbList = new ArrayList<VaultVo>();
		List<VaultVo> strNoList = new ArrayList<VaultVo>();
		
		int dataCount = 0;
		
		if(vaultVo.getDocdbName() != null && vaultVo.getDocdbName().equals("DOC")) {
		
			docdbList = vaultService.columList(vaultVo);
			System.out.println("doc 컬럼 사이즈 : "+docdbList.size());
			//System.out.println("doc dataCount : "+docdbList.get(0).getDataCount());
			result.put("docname", docdbList);
			dataCount = docdbList.get(0).getDataCount();
			
			System.out.println("DOC dataCount : "+ docdbList.get(0).getDataCount());
		}  
		
		if (vaultVo.getSubdbName() != null && vaultVo.getSubdbName().equals("SUB")) {
			
			subdbList = vaultService.columList(vaultVo);
			System.out.println("sub 컬럼 사이즈 : "+subdbList.size());
			//System.out.println("sub dataCount : "+subdbList.get(0).getDataCount());
			result.put("subname", subdbList);
			dataCount = subdbList.get(0).getDataCount();
			System.out.println("SUB dataCount : "+ subdbList.get(0).getDataCount());
		}
		
		if (vaultVo.getStorageNo() != null && vaultVo.getStorageNo().equals("STR")) {
			

			strNoList = vaultService.columList(vaultVo);
			System.out.println("str 컬럼 사이즈 : "+strNoList.size());
			//System.out.println("str dataCount : "+strNoList.get(0).getDataCount());
			result.put("storageno", strNoList); 
			dataCount = strNoList.get(0).getDataCount();
			System.out.println("STR dataCount : "+ strNoList.get(0).getDataCount());
		}
		
		System.out.println("모델 dataCount : "+dataCount);
		
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}
	
	@RequestMapping(value = "/getVaultlInfo.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String getVaultlInfo(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {

		HashMap<String, VaultVo> result = new HashMap<String, VaultVo>();
		CommonUtil commonUtil = new CommonUtil();

		String vaultlNo = vaultVo.getVaultlNo();
		VaultVo vault = vaultService.getVaultlInfo(vaultlNo);
		result.put("vault", vault);

		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}
	
	@RequestMapping(value = "/vaultCreate.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String vaultCreate(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		CommonUtil commonUtil = new CommonUtil();
		System.out.println("var level : "+vaultVo.getVaultlLevel());
		String rtnStr = vaultService.vaultCreate(vaultVo);
		
		boolean rtncode = false;
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);
		
		if(rtnStr.equals("S")) {
			
			VaultVo addVaultvo = new VaultVo();
			addVaultvo = vaultService.getVaultlInfo(vaultVo.getVaultlNo());
			result.put("addVault", addVaultvo);
			result.put("rtnStr", rtnStr);
			  System.out.println("addVault : "+addVaultvo.toString());
			 
			  String fullPath = null;
			  String path = "C:/TimsStr/"+addVaultvo.getStorageNo()+"/";
			
		      // 형식 지정
		      String folderFullName = addVaultvo.getVaultlNo();
		      String[] splitArr = folderFullName.split("-", 10);
		      int level = addVaultvo.getVaultlLevel();
		      String addPath = splitArr[0];
		      
		      System.out.println("레벨 : "+level);		      
		      for(int i=1; i<level; i++){
		    	  
		    	  addPath += "/"+splitArr[i];
		      }
		      fullPath = path + addPath;
			  File dir = new File(fullPath, splitArr[level]);

			  System.out.println("path : "+path);
			  System.out.println("addPath"+addPath);
			  System.out.println("folderFullName : "+folderFullName);
		      
			  // 폴더가 없으면 생성     
		      if(!dir.exists()){
		    	 System.out.println("디렉토리 생성 성공");
		         dir.mkdir();
		      } else {
		    	  
		    	 System.out.println("디렉토리 생성 실패");
		      }
		}else{
			result.put("rtnStr", rtnStr);
		}

		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		
		if(rtnStr.equals("S")){rtncode = true;}
		if(rtncode){txManager.commit(txStauts);
		System.out.println("커밋!!");}
		else{txManager.rollback(txStauts);
		System.out.println("롤백!!");}
		
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/rootCreate.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String rootCreate(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		CommonUtil commonUtil = new CommonUtil();
		FileCon file = new FileCon();
		boolean rtncode = false;
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);
		
		
		String rtnStr = vaultService.rootCreate(vaultVo);
		System.out.println("rtnStr " + rtnStr);
		if(rtnStr.equals("S")) {
			VaultVo addVault = new VaultVo();
			addVault = vaultService.getVaultlInfo(vaultVo.getVaultlNo());
			System.out.println(addVault);
			result.put("addVault", addVault);
			result.put("rtnStr", rtnStr);
			
			file.createFolder(addVault);
		}else{
			result.put("rtnStr", rtnStr);
		}

		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		
		if(rtnStr.equals("S")){rtncode = true;}
		if(rtncode){txManager.commit(txStauts);
		System.out.println("커밋!!");}
		else{txManager.rollback(txStauts);
		System.out.println("롤백!!");}
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/vaultUpdate.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String vaultUpdate(@ModelAttribute("VaultVo") VaultVo vaultVo, Model model, HttpServletRequest req) throws Exception {
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		CommonUtil commonUtil = new CommonUtil();
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);
		boolean rtncode = false;
		String rtnStr = vaultService.vaultUpdate(vaultVo);
		result.put("rtnStr", rtnStr);
		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		
		if(rtnStr.equals("S")){rtncode = true;}
		if(rtncode){txManager.commit(txStauts);
		System.out.println("커밋!!");}
		else{txManager.rollback(txStauts);
		System.out.println("롤백!!");}
		
		return callbackMsg;
	}
	
	@RequestMapping(value = "/vaultDelete.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody	
	public void vaultDelete(@ModelAttribute("VaultVo") VaultVo vaultVo, HttpServletResponse response,HttpServletRequest request){
		
		System.out.println("   >> vaultDelete   <<");
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);
		
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		CommonUtil commonUtil = new CommonUtil();
		FileCon file = new FileCon();
		
		String vaultlno = "", changeVaultlno = "", rtnStr = "", rtnerrno = "";
		boolean rtncode= false;
		int doccnt = 0;

		try {
			System.out.println("before Valutlno : " +vaultVo.getVaultlNo());
			vaultlno = vaultVo.getVaultlNo();
			String vaultnoSplit[] = vaultlno.split("-");

			int vaultlevel = vaultVo.getVaultlLevel()+1;
			for (int i = 0; i < vaultlevel; i++) {
				changeVaultlno += vaultnoSplit[i];
				if(i != vaultlevel-1){ changeVaultlno+="-";	}
			}
			System.out.println("change Valutlno : " +changeVaultlno);
			vaultVo.setVaultlNo(changeVaultlno);
			
			
			if(vaultVo.getDocdbName().equals("D_DOCDB1")){
				doccnt = vaultService.getCountDocdb1(vaultVo);
			}else if(vaultVo.getDocdbName().equals("D_DOCDB1")){
				doccnt = vaultService.getCountDocdb2(vaultVo);
			}
			
			//VaultVo addVault = vaultService.getVaultlInfo(vaultVo.getVaultlNo());
			
			if(doccnt > 0 ){
				System.out.println("데이터 있으므로 삭제 불가!!" + doccnt);
				rtnerrno = "0";
				return;
			}
			rtnStr = vaultService.vaultDelete(vaultVo);
			System.out.println("rtnStr : "+rtnStr);
			if(rtnStr.equals("S")){
				rtncode = true;
			}
			
		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			if(rtncode){txManager.commit(txStauts);
			System.out.println("커밋!!");}
			else{txManager.rollback(txStauts);
			System.out.println("롤백!!");}
			result.put("rtnStr", rtnStr);
			result.put("rtncode", rtncode);
			result.put("rtnerrno", rtnerrno);
			
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(JSONObject.fromObject(result).toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	@RequestMapping(value = "/rollBack.do", method = RequestMethod.POST, produces="application/json;charset=UTF-8")
	@ResponseBody
	public String rollBack(Model model, HttpServletRequest req) throws Exception {
		
		HashMap<String, Integer> result = new HashMap<String, Integer>();
		CommonUtil commonUtil = new CommonUtil();

		int resultNum = vaultService.rollBack();
		result.put("resultNum", resultNum);

		String callbackMsg = commonUtil.getJsonCallBackString(" ", result);

		System.out.println("callbackMsg::" + callbackMsg);
		return callbackMsg;
	}
	
	@RequestMapping(value = "/deleteDocdb.do")
	public void deleteDocdb(Locale locale, ModelMap model2,HttpServletResponse response,HttpServletRequest request,D_DocdbVO docdbvo) throws Exception {
		System.out.println("deleteDocdb Controller");
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);
		
		System.out.println(docdbvo.getDocno());
		
		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		CommonUtil commonUtil = new CommonUtil();
		List<String> docnolist = new ArrayList<String>();
		
		String[] paramsplit = docdbvo.getDocno().split("\\^");
		
		String docdbname = paramsplit[0];
		for (int i = 1; i < paramsplit.length; i++) {
			docnolist.add(paramsplit[i]);
			System.out.println(paramsplit[i]);
		}
		
		System.out.println(paramsplit.length - 1);
		String rtnStr = vaultService.deleteDocdb(docdbname,docnolist);
		System.out.println("rtnStr : " + rtnStr);
		if(rtnStr.equals("S")){
			result.put("rtnStr", paramsplit.length - 1 + "개 삭제되었습니다.");
			txManager.commit(txStauts);
			System.out.println("커밋!!");
		}else{
			result.put("rtnStr", rtnStr);
			txManager.rollback(txStauts);
			System.out.println("롤백!!");
		}
		
		 response.setHeader("Content-Type", "text/html; charset=UTF-8");
	     response.getWriter().write(JSONObject.fromObject(result).toString());
	}
}