package egovframework.rte.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.service.SelectService;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.D_WorkFlowVO;
import egovframework.rte.vo.D_WorkflowchghistVO;
import egovframework.rte.vo.D_pgmVO;


@Controller
public class SelectController {
	@Resource(name="selectService")
	SelectService selectService;

	//get D_FILEATTACH List
	@RequestMapping(value = "/getFileAttach.do") 
	@ResponseBody
	public void getAttachFileButton(D_FileattachVO fileattachvo, HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  getFileAttach.do  <<");
		System.out.println(fileattachvo.getDocno());

		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		List<D_FileattachVO> fileAttachVoList = null;
		List<File> fileList = new ArrayList<File>();
		String filePath = "D:/pwmSTR/AttachFile";
		File f = null;
		try {

			fileAttachVoList = selectService.getFileAttach(fileattachvo);
			System.out.println(fileAttachVoList);

			for (int i = 0; i < fileAttachVoList.size(); i++) {
				f = new File(filePath+"//"+fileAttachVoList.get(i).getFilename());
				System.out.println("full path : " + filePath+"//"+fileAttachVoList.get(i).getFilename());
				if(f.exists()){
					System.out.println("파일존재");
					fileList.add(f);
				}else{
					System.out.println("파일 존재x");
				}	
			}

			if(fileAttachVoList.size() == fileList.size()){
				rtncode = true;
			}

		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			jObj.put("fileAttachVoList", fileAttachVoList);
			//jObj.put("fileList", fileList);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("totcount", fileAttachVoList.size());

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/getUserList.do") 
	@ResponseBody
	public void getUserList(D_UserVO uservo, HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  getUserList.do  <<");
		System.out.println(uservo.getUsername());

		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		List<D_UserVO> uservoList = null;

		try {

			uservoList = selectService.getUserList(uservo);
			System.out.println(uservoList);
			rtncode = true;
		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			jObj.put("uservoList", uservoList);
			//jObj.put("fileList", fileList);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("totcount", uservoList.size());

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	@RequestMapping(value = "/getWorkflowHisList.do") 
	@ResponseBody
	public void getWorkflowHisList(D_WorkflowchghistVO workflowvo, HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  getWorkflowHisList.do  <<");
		System.out.println(workflowvo);

		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		List<D_WorkflowchghistVO> list = new ArrayList<D_WorkflowchghistVO>();
		try {
			list = selectService.getWorkflowHisList(workflowvo);
			rtncode = true;
			System.out.println(list);
		} catch (Exception e) {
			// TODO: handle exception
		} finally{

			//jObj.put("fileList", fileList);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("totcount", list.size());

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	@RequestMapping(value = "/getPgmList.do") 
	@ResponseBody
	public void getPgmList(HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  getPgmList.do  <<");
		D_pgmVO pgmvo = new D_pgmVO();
		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		List<D_pgmVO> list = new ArrayList<D_pgmVO>();
		try {
			list = selectService.getPgmList();
			rtncode = true;
			System.out.println(list);
		} catch (Exception e) {
			// TODO: handle exception
		} finally{

			//jObj.put("fileList", fileList);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("pgmList", list);

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	

}
