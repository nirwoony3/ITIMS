package egovframework.rte.controller;

import java.awt.Desktop;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.naming.InitialContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import javax.wsdl.Output;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.fileupload.disk.DiskFileItem;
import org.apache.commons.io.FileUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.hsqldb.lib.StringUtil;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.sun.istack.internal.logging.Logger;

import egovframework.rte.cmmn.CommonUtil;
import egovframework.rte.cmmn.DBConnection;
import egovframework.rte.cmmn.ResultSetConverter;
import egovframework.rte.service.LvDetailService;
import egovframework.rte.service.UserService;
import egovframework.rte.service.VaultService;
import egovframework.rte.vo.D_ColItemVO;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_HistoryVO;
import egovframework.rte.vo.D_TableVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.D_WorkFlowVO;
import egovframework.rte.vo.VaultVo;

@Controller
public class LvDetailController {

	Logger log = Logger.getLogger(UserController.class);

	@Resource(name="lvDetailService")
	LvDetailService lvDetailService;

	@Resource(name = "vaultService")
	private VaultService vaultService;

	@Resource(name = "txManager")
	protected DataSourceTransactionManager txManager;


	@RequestMapping(value = "/lvDetail.do")
	public String lvDetail( ModelMap model) throws Exception {
		return "F_LVDETAIL";
	}

	@RequestMapping(value = "/f_find.do")
	public String pmsdoc1Form(ModelMap model) throws Exception {
		//log.info(">> jobregist Method Working <<");
		return "F_FIND";
	}

	@RequestMapping(value = "/f_fileattach.do")
	public String f_fileattach(ModelMap model) throws Exception {
		//log.info(">> jobregist Method Working <<");
		return "F_FILEATTACH";
	}

	//insert D_DOCDB, FileAttach, D_SUBDB  and delete FileAttach
	//MultipartHttpServletRequest를 이용한 업로드 파일 접근	
	@RequestMapping(value = "/insertDetail.do") 
	@ResponseBody
	public void insertDetail(D_DocdbVO docdbvo, MultipartHttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  insertDetail.do  <<");
		System.out.println(docdbvo);


		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		String rtnmsg = "";
		boolean rtncode = false;

		List<MultipartFile> mfList = request.getFiles("file");		

		//MultipartFile file = mfList.get(0);    

		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jArr = new JSONArray();
		JSONObject jObj = new JSONObject();

		DBConnection dbcp = new DBConnection(); //#1
		Connection conn=null;
		PreparedStatement pstmt=null;  
		ResultSet rst=null;

		System.out.println(">>. UPLOAD FILE COUNT => "+ mfList.size()); 
		//docdb1 변수
		String docno = "", doctype = "", docname = "", docfilename = "", docfiletype = "", docdesc = "", docstatus = "",
				docappstatus = "", docsetno = "", doczipfilename = "", docgrade = "", doccreated = "", doccreator = "", 
				doccreatorname = "", doccreatordept = "", docanalyzekind = "", vaultlno = "", vldocno = "", storageno="",
				storagepath = "";
		int docversion = 0, pos = 0, count = 0;
		long docfilesize = 0;

		//파일어태치 변수
		boolean  findrtncode = false, localrtncode = false;

		String filename = "", status = "", filetype = "", userfilename="",
				creator= "", creatorname= "", creatordept= "", 
				filedocno= "", filedocmemo= "", targfilepath = "D:/pwmSTR/AttachFile", filepath="";

		FileInputStream input = null;
		FileOutputStream output = null;

		List<MultipartFile> attach_localFileList = request.getFiles("attach_localFile");		
		System.out.println("attach_localFileList.length : "+attach_localFileList.size());
		String attach_findList[] = request.getParameterValues("attach_findfile");

		try {

			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");


			MultipartFile file = null;
			if(mfList.size()!=0){
				file = mfList.get(0);
			}else{  // 임시 파
				File sampleFile = new File("D:/pwmSTR/AttachFile/test.txt");
				sampleFile.createNewFile();

				DiskFileItem fileItem = new DiskFileItem("file", "text/plain", false, sampleFile.getName(), (int) sampleFile.length() , sampleFile.getParentFile());
				fileItem.getOutputStream();
				file = new CommonsMultipartFile(fileItem);
			}

			// #1 insert docdb

			docno = docdbvo.getDocno(); 
			if(docno == null){ docno = lvDetailService.getDocno("D_DOCDB1");}

			doctype = "doc"; docversion = 0; docname = "*";
			docfilename = file.getOriginalFilename().toLowerCase(); 

			System.out.println("docfilename:"+docfilename);
			pos = docfilename.lastIndexOf(".");
			docfiletype = docfilename.substring( pos + 1 ); //확장자

			docdesc = docdbvo.getDocdesc(); if(docdesc == null){ docdesc = "*";}
			docappstatus = docdbvo.getDocappstatus(); if(docappstatus == null){ docappstatus = "*";}
			docgrade = docdbvo.getDocgrade(); if(docgrade == null){ docgrade = "*";}
			docstatus = "checkin";   docsetno = "*";
			doczipfilename = docfilename;

			doccreator = uservo.getUserno();
			doccreatorname = uservo.getUsername();
			doccreatordept = uservo.getUserdeptname();

			docanalyzekind = "";
			if(docfiletype.equals("dwg")){ docanalyzekind = "YES";}

			vaultlno = docdbvo.getVaultlno();
			vldocno = vaultlno+docno;			
			docfilesize = file.getSize();

			docdbvo.setDocno(docno);			      	docdbvo.setDoctype(doctype);
			docdbvo.setDocversion(docversion);	       	docdbvo.setDocname(docname);
			docdbvo.setDocfilename(docfilename);      	docdbvo.setDocfiletype(docfiletype); 	docdbvo.setDocfilesize(docfilesize);
			docdbvo.setDocdesc(docdesc);			   	docdbvo.setDocstatus(docstatus);
			docdbvo.setDocappstatus(docappstatus);	   	docdbvo.setDocsetno(docsetno);
			docdbvo.setDoczipfilename(doczipfilename);	docdbvo.setDocgrade(docgrade);
			docdbvo.setDoccreator(doccreator);			docdbvo.setDoccreatorname(doccreatorname);
			docdbvo.setDoccreatordept(doccreatordept); docdbvo.setDocanalyzekind(docanalyzekind);
			docdbvo.setVaultlno(vaultlno);				docdbvo.setVldocno(vldocno);

			System.out.println(docdbvo);


			rtnmsg = lvDetailService.insertDocdb(docdbvo);

			if(rtnmsg.equals("S")){
				VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
				storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
				System.out.println("storageno : " + storageno);
				storagepath = vaultService.getStoragePath(storageno);
				System.out.println("storagepath : " + storagepath);

				File targetDir = new File(storagepath + "/" + vaultlno); 
				if(!targetDir.exists()) {    //디렉토리 없으면 생성.
					targetDir.mkdirs();				       
				}

				File savefile = new File(storagepath + "/" + vaultlno +"/"+docfilename);

				if (savefile.exists() && savefile.length() > 0) {     
					count++;
				}							

				file.transferTo(savefile); // 파일 이동
				System.out.println(savefile.getName() + " 저장 완료!");


				count++;
				docdbvo.setDocno(null);
				System.out.println("insert docdb1   end!!");
			}else{
				return;
			}
			//#1 insert docdb1   end!!

			// #2 insert subdb
			System.out.println("insert subdb   start!!");
			conn = dbcp.getConnection(); //#2
			String sql = URLDecoder.decode(request.getParameter("sql"), "UTF-8");
			System.out.println(sql);
			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();
			System.out.println("insert subdb   end!!");
			//#2 insert subdb   end!!


			status = "요청"; // 우선 요청으로 넣음
			creator = uservo.getUserno();
			creatorname = uservo.getUsername();
			creatordept = uservo.getUserdeptname();

			//#3 insert attach file
			//   1) insert attachFindFile 
			if(attach_localFileList.size()==0 ){localrtncode=true;}
			if(attach_findList==null || attach_findList.length==0 ){findrtncode=true;}    
			else{
				System.out.println("findList.length : " + attach_findList.length);
				for (int i = 0; i < attach_findList.length; i++) {     
					D_FileattachVO fileattachvo = new D_FileattachVO();
					String findListSplit[] = attach_findList[i].split("\\|");
					filename = findListSplit[0];
					filepath = findListSplit[1];

					pos = filename.lastIndexOf(".");
					filetype = filename.substring( pos + 1 ); //확장자
					userfilename = filename;
					filedocno= ""; filedocmemo= "";

					fileattachvo.setDocno(docno);
					fileattachvo.setFilename(filename);
					fileattachvo.setStatus(status);
					fileattachvo.setFiletype(filetype);
					fileattachvo.setUserfilename(userfilename);
					fileattachvo.setCreator(creator);
					fileattachvo.setCreatorname(creatorname);
					fileattachvo.setCreatordept(creatordept);
					fileattachvo.setFiledocno(filedocno);
					fileattachvo.setFiledocmemo(filedocmemo);

					rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
					if(rtnmsg.equals("S")){
						System.out.println(" . saveFolder / filename : "+filepath + " / " + filename);
						File findfile = new File(filepath+"/"+filename);

						File targetDir = new File(targfilepath); 
						if(!targetDir.exists()) {    //디렉토리 없으면 생성.
							targetDir.mkdirs();				       
						}

						input = new FileInputStream(findfile);
						// 복사된 파일의 위치를 지정해준다.
						output = new FileOutputStream(new File(targetDir+"/"+filename));

						int readBuffer = 0;
						byte [] buffer = new byte[512];
						while((readBuffer = input.read(buffer)) != -1) {
							output.write(buffer, 0, readBuffer);
						}
						System.out.println("파일이 복사되었습니다." + filename);

						System.out.println("rtnmsg : " +rtnmsg);
						findrtncode = true;
					}else{        //insert 실패시  롤백 리턴
						return;
					}

				}
			} //1) insert attachFindFile  end

			// 2) insert attachlocalFile
			for(MultipartFile localfile:attach_localFileList){   /// local file insert
				filename = localfile.getOriginalFilename();
				pos = filename.lastIndexOf(".");
				filetype = filename.substring( pos + 1 ); //확장자
				userfilename = filename;
				filedocno= ""; filedocmemo= "";

				D_FileattachVO fileattachvo = new D_FileattachVO();

				fileattachvo.setDocno(docno);
				fileattachvo.setFilename(filename);
				fileattachvo.setStatus(status);
				fileattachvo.setFiletype(filetype);
				fileattachvo.setUserfilename(userfilename);
				fileattachvo.setCreator(creator);
				fileattachvo.setCreatorname(creatorname);
				fileattachvo.setCreatordept(creatordept);
				fileattachvo.setFiledocno(filedocno);
				fileattachvo.setFiledocmemo(filedocmemo);

				rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
				if(rtnmsg.equals("S")){

					System.out.println(" . saveFolder="+targfilepath);
					File targetDir = new File(targfilepath); 
					if(!targetDir.exists()) {    //디렉토리 없으면 생성.
						targetDir.mkdirs();				       
					}

					File savefile = new File(targfilepath+"/"+userfilename);
					System.out.println("파일경로 : "+targfilepath+"/"+userfilename);

					if(!savefile.exists()){
						file.transferTo(savefile); //파일저장 실제로는 service에서 처리
					}
					System.out.println(savefile.getName() + " 저장 완료 !!");
					System.out.println("rtnmsg : " +rtnmsg);
					localrtncode = true;
				}else{
					return;
				}
			}
			//   2) insert attachlocalFile end
			System.out.println("insert attachlocalFile end!!");

			if(findrtncode && localrtncode){rtncode = true;}
			System.out.println("insert all attachFile  end!!");
			//#3 insert all attachFile  end



			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			System.out.println("rtnmsg / rtncode : " +rtnmsg + " / "+ rtncode);
			if(rtncode){ txManager.commit(txStauts); System.out.println("커밋완료!");}
			else{	txManager.rollback(txStauts); System.out.println("롤백!");}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("count", count);

			dbcp.freeConnection(conn, pstmt, rst); //#3
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}


	//update D_DOCDB, FileAttach, D_SUBDB  and delete FileAttach
	//MultipartHttpServletRequest를 이용한 업로드 파일 접근	
	@RequestMapping(value = "/updateDetail.do") 
	@ResponseBody
	public void updateDetail(D_DocdbVO docdb1vo, MultipartHttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  updateDetail.do  <<");
		System.out.println(docdb1vo);


		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		String rtnmsg = "";
		boolean rtncode = false;

		List<MultipartFile> mfList = request.getFiles("file");		

		//MultipartFile file = mfList.get(0);    
		System.out.println(docdb1vo);

		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jArr = new JSONArray();
		JSONObject jObj = new JSONObject();

		DBConnection dbcp = new DBConnection(); //#1
		Connection conn=null;
		PreparedStatement pstmt=null;  
		ResultSet rst=null;

		System.out.println(">>. UPLOAD FILE COUNT => "+ mfList.size()); 
		//docdb1 변수
		String docno = "", doctype = "", docname = "", docfilename = "", docfiletype = "", docdesc = "", docstatus = "",
				docappstatus = "", docsetno = "", doczipfilename = "", docgrade = "", doccreated = "", docupdator = "", 
				doccreatorname = "", doccreatordept = "", docanalyzekind = "", vaultlno = "", vldocno = "", storageno="",
				storagepath = "";
		int docversion = 0, pos = 0, count = 0;
		long docfilesize = 0;

		//파일어태치 변수
		boolean  findrtncode = false, localrtncode = false;

		String filename = "", status = "", filetype = "", userfilename="",
				creator= "", creatorname= "", creatordept= "", 
				filedocno= "", filedocmemo= "", targfilepath = "D:/pwmSTR/AttachFile", filepath="";

		FileInputStream input = null;
		FileOutputStream output = null;

		List<MultipartFile> attach_localFileList = request.getFiles("attach_localFile");		
		System.out.println("attach_localFileList.length : "+attach_localFileList.size());
		String attach_findList[] = request.getParameterValues("attach_findfile");

		try {

			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");

			MultipartFile file = null;
			if(mfList.size()!=0){
				file = mfList.get(0);

				docfilename = file.getOriginalFilename().toLowerCase(); 
				docfiletype = docfilename.substring( pos + 1 ); //확장자
				docfilesize = file.getSize();

				docdb1vo.setDocfilename(docfilename);      	docdb1vo.setDocfiletype(docfiletype); 	docdb1vo.setDocfilesize(docfilesize);
			}
			// #1 update docdb
			docno = docdb1vo.getDocno(); 
			doctype = "doc";
			docversion = 0; docname = "*";


			System.out.println("docfilename:"+docfilename);
			pos = docfilename.lastIndexOf(".");


			docdesc = docdb1vo.getDocdesc(); if(docdesc == null){ docdesc = "*";}
			docappstatus = docdb1vo.getDocappstatus(); if(docappstatus == null){ docappstatus = "*";}
			docgrade = docdb1vo.getDocgrade(); if(docgrade == null){ docgrade = "*";}
			docstatus = "checkin";   docsetno = "*";
			doczipfilename = docfilename;

			docupdator = uservo.getUserno();
			doccreatorname = uservo.getUsername();
			doccreatordept = uservo.getUserdeptname();

			docanalyzekind = "";
			if(docfiletype.equals("dwg")){ docanalyzekind = "YES";}

			vaultlno = docdb1vo.getVaultlno();
			vldocno = vaultlno+docno;			

			docdb1vo.setDocno(docno);			      	docdb1vo.setDoctype(doctype);
			docdb1vo.setDocversion(docversion);	       	docdb1vo.setDocname(docname);

			docdb1vo.setDocdesc(docdesc);			   	docdb1vo.setDocstatus(docstatus);
			docdb1vo.setDocappstatus(docappstatus);	   	docdb1vo.setDocsetno(docsetno);
			docdb1vo.setDoczipfilename(doczipfilename);	docdb1vo.setDocgrade(docgrade);
			docdb1vo.setDocupdator(docupdator);			docdb1vo.setDoccreatorname(doccreatorname);
			docdb1vo.setDoccreatordept(doccreatordept); docdb1vo.setDocanalyzekind(docanalyzekind);
			docdb1vo.setVaultlno(vaultlno);				docdb1vo.setVldocno(vldocno);

			System.out.println(docdb1vo);

			rtnmsg = lvDetailService.updateDocdb(docdb1vo);

			if(rtnmsg.equals("S")){
				if(mfList.size()!=0){
					VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
					storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
					System.out.println("storageno : " + storageno);
					storagepath = vaultService.getStoragePath(storageno);
					System.out.println("storagepath : " + storagepath);

					File targetDir = new File(storagepath+ "/" + vaultlno); 
					if(!targetDir.exists()) {    //디렉토리 없으면 생성.
						targetDir.mkdirs();				       
					}
					File savefile = new File(storagepath+"/" +  vaultlno + "/" +docfilename);

					if (savefile.exists() && savefile.length() > 0) {     
						count++;
					}							

					file.transferTo(savefile); // 파일 이동
					System.out.println(savefile.getName() + " 저장 완료!");
				}
				count++;
				docdb1vo.setDocno(null);
				System.out.println("update docdb1   end!!");
			}else{
				return;
			}
			//#1 update docdb1   end!!

			// #2 update subdb
			System.out.println("insert subdb   end!!");
			conn = dbcp.getConnection(); //#2

			String sql[] = request.getParameterValues("sql");

			for (int i = 0; i < sql.length; i++) {
				sql[i] = URLDecoder.decode(sql[i], "UTF-8");
				System.out.println("sql "+ i + " : " + sql[i]);
				pstmt = conn.prepareStatement(sql[i]);
				rst = pstmt.executeQuery();
			}
			//pstmt = conn.prepareStatement(sql);

			System.out.println("update subdb   end!!");
			//#2 update subdb   end!!



			status = "요청";
			creator = uservo.getUserno();
			creatorname = uservo.getUsername();
			creatordept = uservo.getUserdeptname();

			//#3 update attach file
			//   1) update attachFindFile 
			if(attach_localFileList.size()==0 ){localrtncode=true;}
			if(attach_findList==null || attach_findList.length==0 ){findrtncode=true;}    
			else{
				System.out.println("findList.length : " + attach_findList.length);
				for (int i = 0; i < attach_findList.length; i++) {     
					D_FileattachVO fileattachvo = new D_FileattachVO();
					String findListSplit[] = attach_findList[i].split("\\|");
					filename = findListSplit[0];
					filepath = findListSplit[1];

					pos = filename.lastIndexOf(".");
					filetype = filename.substring( pos + 1 ); //확장자
					userfilename = filename;
					filedocno= ""; filedocmemo= "";

					fileattachvo.setDocno(docno);
					fileattachvo.setFilename(filename);
					fileattachvo.setStatus(status);
					fileattachvo.setFiletype(filetype);
					fileattachvo.setUserfilename(userfilename);
					fileattachvo.setCreator(creator);
					fileattachvo.setCreatorname(creatorname);
					fileattachvo.setCreatordept(creatordept);
					fileattachvo.setFiledocno(filedocno);
					fileattachvo.setFiledocmemo(filedocmemo);

					rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
					if(rtnmsg.equals("S")){
						System.out.println(" . saveFolder / filename : "+filepath + " / " + filename);
						File findfile = new File(filepath+"/"+filename);
						targfilepath = "D:/pwmSTR/AttachFile";
						File targetDir = new File(targfilepath); 
						if(!targetDir.exists()) {    //디렉토리 없으면 생성.
							targetDir.mkdirs();				       
						}

						input = new FileInputStream(findfile);
						// 복사된 파일의 위치를 지정해준다.
						output = new FileOutputStream(new File(targetDir+"/"+filename));

						int readBuffer = 0;
						byte [] buffer = new byte[512];
						while((readBuffer = input.read(buffer)) != -1) {
							output.write(buffer, 0, readBuffer);
						}
						System.out.println("파일이 복사되었습니다." + filename);

						System.out.println("rtnmsg : " +rtnmsg);
						findrtncode = true;
					}else{        //update 실패시  롤백 리턴
						return;
					}

				}
			} //1) update attachFindFile  end

			// 2) update attachlocalFile
			for(MultipartFile localfile:attach_localFileList){   /// local file update
				filename = localfile.getOriginalFilename();
				pos = filename.lastIndexOf(".");
				filetype = filename.substring( pos + 1 ); //확장자
				userfilename = filename;
				filedocno= ""; filedocmemo= "";

				D_FileattachVO fileattachvo = new D_FileattachVO();

				fileattachvo.setDocno(docno);
				fileattachvo.setFilename(filename);
				fileattachvo.setStatus(status);
				fileattachvo.setFiletype(filetype);
				fileattachvo.setUserfilename(userfilename);
				fileattachvo.setCreator(creator);
				fileattachvo.setCreatorname(creatorname);
				fileattachvo.setCreatordept(creatordept);
				fileattachvo.setFiledocno(filedocno);
				fileattachvo.setFiledocmemo(filedocmemo);

				rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
				if(rtnmsg.equals("S")){

					System.out.println(" . saveFolder="+targfilepath);
					File targetDir = new File(targfilepath); 
					if(!targetDir.exists()) {    //디렉토리 없으면 생성.
						targetDir.mkdirs();				       
					}

					File savefile = new File(targfilepath+"/"+userfilename);
					System.out.println("파일경로 : "+targfilepath+"/"+userfilename);

					if (savefile.exists() && savefile.length() > 0) {     
						count++;
					}							

					localfile.transferTo(savefile); //파일저장 실제로는 service에서 처리
					System.out.println(savefile.getName() + " 저장 완료 !!");
					System.out.println("rtnmsg : " +rtnmsg);
					localrtncode = true;
				}else{
					return;
				}
			}
			//   2) update attachlocalFile end
			System.out.println("update attachlocalFile end!!");

			System.out.println("delete attachFile start!");
			String deleteFiles[] = request.getParameterValues("delete_serverfile");
			D_FileattachVO fileattachvo = new D_FileattachVO();

			if(deleteFiles != null){
				for (int i = 0; i < deleteFiles.length; i++) {
					fileattachvo.setDocno(docno);
					fileattachvo.setFilename(deleteFiles[i]);
					rtnmsg = lvDetailService.deleteFileAttach(fileattachvo);
					if(!rtnmsg.equals("S")){return;}
				}
			}

			System.out.println("delete attachFile end!");
			if(findrtncode && localrtncode){rtncode = true;}
			System.out.println("update all attachFile  end!!");
			//#3 update all attachFile  end

			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			System.out.println("rtnmsg / rtncode : " +rtnmsg + " / "+ rtncode);
			if(rtncode){ txManager.commit(txStauts); System.out.println("커밋완료!");}
			else{	txManager.rollback(txStauts); System.out.println("롤백!");}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("count", count);

			dbcp.freeConnection(conn, pstmt, rst); //#3
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}



	@RequestMapping(value = "/deleteDetail.do")
	public void deleteDetail(HttpServletResponse response,HttpServletRequest request){
		System.out.println("deleteDetail Controller");

		HashMap<String, Object> result = new HashMap<String, Object>();;

		List<D_WorkFlowVO> tabList = null;
		String sql = "";
		String rtnmsg = "";
		boolean rtncode = false;
		int count = 0;

		DBConnection dbcp = new DBConnection(); //#1
		Connection conn=null;
		PreparedStatement pstmt=null;  
		ResultSet rst=null;

		try {

			conn = dbcp.getConnection(); //#2

			String docnoList[] = request.getParameterValues("docno");
			String vaultlno = request.getParameter("vaultlno");
			String docdbname = request.getParameter("docdbname");
			String subdbname = request.getParameter("subdbname");

			tabList = (List<D_WorkFlowVO>)lvDetailService.getTabsList(vaultlno);
			if(tabList.size() == 0){
				D_WorkFlowVO workflowVo = new D_WorkFlowVO();
				workflowVo.setWfdesc(subdbname);
				workflowVo.setWflevel(1);
				workflowVo.setWfstate("상세정보");
				workflowVo.setWfstateseq(1);

				tabList.add(workflowVo);
			}

			System.out.println("doc / vaultlno length / docdbname : "
					+ docnoList.length+ "/" + vaultlno + "/" + docdbname);
			System.out.println(tabList);

			for (int i = 0; i < docnoList.length; i++) {
				count++;
				System.out.println(docnoList[i]);
				System.out.println(tabList);

				sql = "DELETE FROM "+
						docdbname+" WHERE DOCNO = '" + 
						docnoList[i] +"' AND VAULTLNO = '" + vaultlno + "'" ;
				System.out.println("docdb sql : "+sql);

				pstmt = conn.prepareStatement(sql);
				rst = pstmt.executeQuery();

				for (int j = 0; j < tabList.size(); j++) {  //subdb 삭제
					sql = "DELETE FROM "+
							tabList.get(j).getWfdesc() +" WHERE DOCNO = '" + 
							docnoList[i] +"' AND VAULTLNO = '" + vaultlno + "'" ;
					System.out.println("subdb sql : "+sql);

					pstmt = conn.prepareStatement(sql);
					rst = pstmt.executeQuery();
				}
			}

			rtncode = true;

		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			result.put("count", count);
			result.put("rtncode", rtncode);
			result.put("rtnmsg", rtnmsg);

			try {
				if(rtncode){conn.commit();}else{conn.rollback();}
				dbcp.freeConnection(conn, pstmt, rst); //#3
				response.getWriter().write(JSONObject.fromObject(result).toString());
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}



		//System.out.println(paramsplit.length - 1);
		//String rtnStr = vaultService.deleteDocdb(docdbname,docnolist);
		//		System.out.println("rtnStr : " + rtnStr);
		//		if(rtnStr.equals("S")){
		//			//result.put("rtnStr", paramsplit.length - 1 + "개 삭제되었습니다.");
		//			txManager.commit(txStauts);
		//			System.out.println("커밋!!");
		//		}else{
		//			result.put("rtnStr", rtnStr);
		//			txManager.rollback(txStauts);
		//			System.out.println("롤백!!");
		//		}


	}

	@RequestMapping(value = "/getCountSubdb.do") 
	@ResponseBody
	public void getCountSubdb(HttpServletRequest request, HttpServletResponse response) 
	{

		System.out.println(" >> getCountSubdb.do  <<");

		String rtnmsg = "";
		boolean rtncode = false;


		/** TOTAL ORACLE CONNECT START **/

		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jArr = new JSONArray();
		JSONObject jObj = new JSONObject();

		DBConnection dbcp = new DBConnection(); //#1
		Connection conn=null;
		PreparedStatement pstmt=null;  
		ResultSet rst=null;

		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Type", "text/html; charset=UTF-8");

		String docno = "", vaultlno= "", tablename="", sql="";
		try {			

			conn = dbcp.getConnection(); //#2

			docno = request.getParameter("docno");
			vaultlno = request.getParameter("vaultlno");
			tablename = request.getParameter("tablename");

			sql = " SELECT COUNT(*) COUNT FROM " + tablename + " WHERE DOCNO = '" + docno + "' AND VAULTLNO = '"+
					vaultlno + "' ";

			System.out.println("sql : "+sql);

			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();

			jArr = resConv.convert(rst);
			System.out.println(jArr);


			//	subdb100vo = lvDetailService.getD_SUBDB100(subdb100vo);

			rtncode=true;



		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			jObj.put("count", jArr);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
				dbcp.freeConnection(conn, pstmt, rst); //#3
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}


	@RequestMapping(value = "/getD_SUBDB.do") 
	@ResponseBody
	public void getD_SUBDB100(HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >> getD_SUBDB.do  <<");


		String rtnmsg = "";
		boolean rtncode = false;


		/** TOTAL ORACLE CONNECT START **/

		ResultSetConverter resConv = new ResultSetConverter();
		JSONArray jArr = new JSONArray();
		JSONObject jObj = new JSONObject();

		DBConnection dbcp = new DBConnection(); //#1
		Connection conn=null;
		PreparedStatement pstmt=null;  
		ResultSet rst=null;

		response.setCharacterEncoding("UTF-8");
		response.setHeader("Content-Type", "text/html; charset=UTF-8");

		String docno = "", vaultlno= "", tablename="", sql="";
		try {			

			conn = dbcp.getConnection(); //#2

			docno = request.getParameter("docno");
			vaultlno = request.getParameter("vaultlno");
			tablename = request.getParameter("tablename");

			sql = " SELECT * FROM " + tablename + " WHERE DOCNO = '" + docno + "' AND VAULTLNO = '"+
					vaultlno + "' ";

			System.out.println("sql : "+sql);

			pstmt = conn.prepareStatement(sql);
			rst = pstmt.executeQuery();

			jArr = resConv.convert(rst);
			System.out.println(jArr);


			//	subdb100vo = lvDetailService.getD_SUBDB100(subdb100vo);

			rtncode=true;



		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			jObj.put("D_SUBDB", jArr);
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
				dbcp.freeConnection(conn, pstmt, rst); //#3
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}


	

	//insert D_FILEATTACH
	//MultipartHttpServletRequest를 이용한 업로드 파일 접근	
	@RequestMapping(value = "/insertFileAttach.do") 
	@ResponseBody
	public void insertFileAttach(D_FileattachVO fileattachvo, MultipartHttpServletRequest request, HttpServletResponse response) 
	{

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		System.out.println(" >>  insertFileAttach.do  <<");
		System.out.println(fileattachvo);

		String rtnmsg = "";
		boolean rtncode = false, findrtncode = false, localrtncode = false;
		JSONObject jObj = new JSONObject();

		String filename = "", status = "", filetype = "", userfilename="",
				creator= "", creatorname= "", creatordept= "", 
				filedocno= "", filedocmemo= "", targfilepath = "D:/pwmSTR/AttachFile", filepath="";

		long filesize = 0;
		int attcheckincnt = 0, pos = 0, count = 0;

		FileInputStream input = null;
		FileOutputStream output = null;


		try {
			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");

			status = "요청";
			creator = uservo.getUserno();
			creatorname = uservo.getUsername();
			creatordept = uservo.getUserdeptname();

			List<MultipartFile> mfList = request.getFiles("localfile");		
			System.out.println("mfList.size : "+mfList.size());

			String findList[] = request.getParameterValues("findfile");


			if(mfList.size()==0 ){localrtncode=true;}
			if(findList==null || findList.length==0 ){findrtncode=true;}          // find file insert
			else{
				System.out.println("findList.length : " + findList.length);
				for (int i = 0; i < findList.length; i++) {     
					String findListSplit[] = findList[i].split("\\|");
					filename = findListSplit[0];
					filepath = findListSplit[1];

					pos = filename.lastIndexOf(".");
					filetype = filename.substring( pos + 1 ); //확장자
					userfilename = filename;
					filedocno= ""; filedocmemo= "";

					File findfile = new File(filepath+"/"+filename);
					filesize = findfile.length();

					fileattachvo.setFilename(filename);
					fileattachvo.setStatus(status);
					fileattachvo.setFiletype(filetype);
					fileattachvo.setUserfilename(userfilename);
					fileattachvo.setCreator(creator);
					fileattachvo.setCreatorname(creatorname);
					fileattachvo.setCreatordept(creatordept);
					fileattachvo.setFiledocno(filedocno);
					fileattachvo.setFiledocmemo(filedocmemo);
					fileattachvo.setFilesize(filesize);

					rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
					if(rtnmsg.equals("S")){
						count++;
						System.out.println(" . saveFolder / filename : "+filepath + " / " + filename);

						File targetDir = new File(targfilepath); 
						if(!targetDir.exists()) {    //디렉토리 없으면 생성.
							targetDir.mkdirs();				       
						}

						input = new FileInputStream(findfile);
						// 복사된 파일의 위치를 지정해준다.
						output = new FileOutputStream(new File(targetDir+"/"+filename));

						int readBuffer = 0;
						byte [] buffer = new byte[512];
						while((readBuffer = input.read(buffer)) != -1) {
							output.write(buffer, 0, readBuffer);
						}
						System.out.println("파일이 복사되었습니다." + filename);

						System.out.println("rtnmsg : " +rtnmsg);
						findrtncode = true;
					}else{
						return;
					}

				}
			}


			for(MultipartFile file:mfList){   /// local file insert
				filename = file.getOriginalFilename();
				pos = filename.lastIndexOf(".");
				filetype = filename.substring( pos + 1 ); //확장자
				userfilename = filename;
				filedocno= ""; filedocmemo= "";
				filesize=file.getSize();

				fileattachvo.setFilename(filename);
				fileattachvo.setStatus(status);
				fileattachvo.setFiletype(filetype);
				fileattachvo.setUserfilename(userfilename);
				fileattachvo.setCreator(creator);
				fileattachvo.setCreatorname(creatorname);
				fileattachvo.setCreatordept(creatordept);
				fileattachvo.setFiledocno(filedocno);
				fileattachvo.setFiledocmemo(filedocmemo);
				fileattachvo.setFilesize(filesize);

				rtnmsg = lvDetailService.insertFileAttach(fileattachvo);
				if(rtnmsg.equals("S")){
					count++;
					System.out.println(" . saveFolder="+targfilepath);
					File targetDir = new File(targfilepath); 
					if(!targetDir.exists()) {    //디렉토리 없으면 생성.
						targetDir.mkdirs();				       
					}

					File savefile = new File(targfilepath+"/"+userfilename);

					if(!savefile.exists()){
						file.transferTo(savefile); //파일저장 실제로는 service에서 처리
					}

					System.out.println(savefile.getName() + " 저장 완료 !!");
					System.out.println("rtnmsg : " +rtnmsg);
					localrtncode = true;
				}else{
					return;
				}
			}

			if(findrtncode && localrtncode){rtncode = true;}
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			System.out.println("rtnmsg / rtncode : " +rtnmsg + " / "+ rtncode);
			if(rtncode){
				txManager.commit(txStauts);
				System.out.println("커밋완료!");
			}else{
				txManager.rollback(txStauts);
				System.out.println("롤백완료!");
			}
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("rtncode", rtncode);
			jObj.put("count", count);

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


	//delete D_FILEATTACH List
	@RequestMapping(value = "/deleteFileAttach.do") 
	@ResponseBody
	public void deleteFileAttach(String[] filenameList, HttpServletRequest request, HttpServletResponse response) 
	{

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		System.out.println(" >>  deleteFileAttach.do  <<");

		String rtnmsg = "", docno = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		int count = 0;

		try {
			docno = request.getParameter("docno");
			System.out.println("docno:"+docno);
			System.out.println("filenameList.length:"+filenameList.length);
			D_FileattachVO fileattachvo = new D_FileattachVO();
			fileattachvo.setDocno(docno);


			for (int i = 0; i < filenameList.length; i++) {
				fileattachvo.setFilename(filenameList[i]);
				System.out.println(fileattachvo);
				rtnmsg = lvDetailService.deleteFileAttach(fileattachvo);

				if(!rtnmsg.equals("S")){
					return;
				}else{
					count++;
				}
			}
			rtncode = true;


		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			if(rtncode){txManager.commit(txStauts); System.out.println("삭제완료 커밋");}
			else{txManager.rollback(txStauts);}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("count", count);
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	//insert D_DOCDB
	//MultipartHttpServletRequest를 이용한 업로드 파일 접근	
	@RequestMapping(value = "/insertDocdb.do") 
	@ResponseBody
	public void insertDocdb1(D_DocdbVO docdbvo, MultipartHttpServletRequest request, HttpServletResponse response) 
	{

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		System.out.println(" >>  insertDocdb.do  <<");
		System.out.println(docdbvo);

		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();

		List<MultipartFile> mfList = request.getFiles("file");		
		//MultipartFile file = mfList.get(0);    

		System.out.println(">>. UPLOAD FILE COUNT => "+ mfList.size()); 
		String docno = "", doctype = "", docname = "", docfilename = "", docfiletype = "", docdesc = "", docstatus = "",
				docappstatus = "", docsetno = "", doczipfilename = "", docgrade = "", doccreated = "", doccreator = "", 
				doccreatorname = "", doccreatordept = "", docanalyzekind = "", vaultlno = "", vldocno = "", storageno="",
				storagepath = "";
		int docversion = 0, pos = 0, count = 0;
		long docfilesize = 0;

		try {

			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");

			for(MultipartFile file:mfList){
				docno = docdbvo.getDocno(); 
				if(docno == null){ docno = lvDetailService.getDocno("D_DOCDB1");}

				doctype = "doc"; docversion = 0; docname = "*";
				docfilename = file.getOriginalFilename().toLowerCase(); 

				System.out.println("docfilename:"+docfilename);
				pos = docfilename.lastIndexOf(".");
				docfiletype = docfilename.substring( pos + 1 ); //확장자

				docdesc = docdbvo.getDocdesc(); if(docdesc == null){ docdesc = "*";}
				docappstatus = docdbvo.getDocappstatus(); if(docappstatus == null){ docappstatus = "*";}
				docgrade = docdbvo.getDocgrade(); if(docgrade == null){ docgrade = "*";}
				docstatus = "checkin";   docsetno = "*";
				doczipfilename = docfilename;

				doccreator = uservo.getUserno();
				doccreatorname = uservo.getUsername();
				doccreatordept = uservo.getUserdeptname();

				docanalyzekind = "";
				if(docfiletype.equals("dwg")){ docanalyzekind = "YES";}

				vaultlno = docdbvo.getVaultlno();
				vldocno = vaultlno+docno;			
				docfilesize = file.getSize();

				docdbvo.setDocno(docno);			      	docdbvo.setDoctype(doctype);
				docdbvo.setDocversion(docversion);	       	docdbvo.setDocname(docname);
				docdbvo.setDocfilename(docfilename);      	docdbvo.setDocfiletype(docfiletype); 	docdbvo.setDocfilesize(docfilesize);
				docdbvo.setDocdesc(docdesc);			   	docdbvo.setDocstatus(docstatus);
				docdbvo.setDocappstatus(docappstatus);	   	docdbvo.setDocsetno(docsetno);
				docdbvo.setDoczipfilename(doczipfilename);	docdbvo.setDocgrade(docgrade);
				docdbvo.setDoccreator(doccreator);			docdbvo.setDoccreatorname(doccreatorname);
				docdbvo.setDoccreatordept(doccreatordept); docdbvo.setDocanalyzekind(docanalyzekind);
				docdbvo.setVaultlno(vaultlno);				docdbvo.setVldocno(vldocno);

				System.out.println(docdbvo);


				rtnmsg = lvDetailService.insertDocdb(docdbvo);

				if(rtnmsg.equals("S")){
					VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
					storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
					System.out.println("storageno : " + storageno);
					storagepath = vaultService.getStoragePath(storageno);
					System.out.println("storagepath : " + storagepath);

					File targetDir = new File(storagepath + "/" + vaultlno); 
					if(!targetDir.exists()) {    //디렉토리 없으면 생성.
						targetDir.mkdirs();				       
					}

					File savefile = new File(storagepath+"/"+vaultlno+"/"+docfilename);

					count++;						

					file.transferTo(savefile); // 파일 이동
					System.out.println(savefile.getPath()+"/"+savefile.getName() + " 저장 완료!");

					docdbvo.setDocno(null);
				}else{return;}
			}

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
			jObj.put("count", count);

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

		}
	}

	@RequestMapping(value = "/detailsave.do")
	public void detailsave(@RequestParam Map<String, Object> data,Locale locale, ModelMap model,HttpServletResponse response,MultipartHttpServletRequest request, D_DocdbVO docdbvo) throws Exception {
		//log.info(">> addjob Method Working <<");
		System.out.println("detailsave Controller");

		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		Map<String,Object> params = (Map<String, Object>) data.get("params");
		List<MultipartFile> mfList = (List<MultipartFile>) data.get("formData");
		System.out.println(data);
		System.out.println(mfList);

		Iterator<String> keys = params.keySet().iterator();
		while( keys.hasNext() ){
			String key = keys.next();
			System.out.println( String.format("키 : %s, 값 : %s", key, params.get(key)) );
		}


		/*List<MultipartFile> mfList = request.getFiles("filename");	//파일 받아옴		
		MultipartFile file = mfList.get(0); 
		String exelfilename = file.getOriginalFilename();  
		System.out.println("파일네임:"+exelfilename);
		String attsfileloc = "";
		String attsfile = "";*/



		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}

	@RequestMapping(value = "/detailupdate.do")
	public void detailupdate(Locale locale, ModelMap model,HttpServletResponse response,HttpServletRequest request) throws Exception {
		//log.info(">> addjob Method Working <<");
		System.out.println("detailupdate Controller");

		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}

	@RequestMapping(value = "/getdocno.do")
	public void getdocno(Locale locale, ModelMap model,HttpServletResponse response,HttpServletRequest request) throws Exception {
		//log.info(">> addjob Method Working <<");
		System.out.println(" >> getdocno Controller <<");

		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		String dbname = request.getParameter("dbname");
		System.out.println("dbname : " + dbname);
		String docnoStr = lvDetailService.getDocno(dbname);
		System.out.println("docnoStr : "+ docnoStr);

		result.put("docno", docnoStr);
		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}
	@RequestMapping(value = "/getDocapprstatus.do")
	public void getDocapprstatus( Locale locale, ModelMap model,HttpServletResponse response,HttpServletRequest request ) throws Exception {

		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		List<D_WorkFlowVO> docapprstatus = (List<D_WorkFlowVO>)lvDetailService.getDocapprstatus();

		result.put("success", true);
		result.put("docapprstatus", docapprstatus);
		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}

	@RequestMapping(value = "/getDocdb.do")
	public void getDocdb( Locale locale, ModelMap model,HttpServletResponse response,HttpServletRequest request,D_DocdbVO docdbvo ) throws Exception {
		System.out.println("getDocdb Controller");
		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		System.out.println(docdbvo);
		List<D_DocdbVO> docdb = (List<D_DocdbVO>)lvDetailService.getDocdb(docdbvo);

		System.out.println("---- res ----");
		System.out.println(docdb);
		result.put("success", true);
		result.put("docdb", docdb);
		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}
	/**
	 * 텝의 목록을 조회한다. 
	 * @param D_WorkFlowVO - 조회할 정보가 담긴 WorkFlowVO
	 * @param json
	 * @exception Exception
	 */
	@RequestMapping(value = "/detailAction.do" ,method = RequestMethod.POST)
	@ResponseBody
	public void detailAction(ModelMap model, HttpServletResponse response,HttpServletRequest request) throws Exception {
		System.out.println(">> detailAction Method Working <<");

		/*
		 * get tabs Data from DB
		 */
		String vaultlNo = request.getParameter("vaultlNo");
		String subdbname = request.getParameter("subdbname");
		System.out.println("vaultlNo / subdbname:"+vaultlNo + " / " +subdbname );

		List<D_WorkFlowVO> tabList = (List<D_WorkFlowVO>)lvDetailService.getTabsList(vaultlNo);

		System.out.println("tabListsize : "+tabList.size());
		ArrayList<String> desc = new ArrayList<String>();


		if(tabList.size() == 0){
			D_WorkFlowVO workflowVo = new D_WorkFlowVO();
			workflowVo.setWfdesc(subdbname);
			workflowVo.setWflevel(1);
			workflowVo.setWfstate("상세정보");
			workflowVo.setWfstateseq(1);

			tabList.add(workflowVo);
		}

		System.out.println(tabList);

		//중복 검사
		for (int i = 0; i < tabList.size(); i++) {
			if(i == 0){ //0번째는 중복이 될수 없으므로 desc에 추가
				desc.add(tabList.get(i).getWfdesc());
			}else{ //1번째부터는 중복이 발생 할수있으므로 체크 들어감
				if(desc.contains(tabList.get(i).getWfdesc())){ //현재꺼에서 지금까지 추가한 desc와 중복이 있는지 확인
					System.out.println("중복!!");
					System.out.println(desc.indexOf(tabList.get(i).getWfdesc()));
					if(desc.contains("-")){ 
						System.out.println("- 중복");
						String[] split = tabList.get(i).getWfdesc().split("-");
						String str = "";
						for (int j = 0; j < split.length - 1; j++) {
							str += split[j] +"-";
						} //ㅁㄴㅇㅁㄴㅇㅁㄴㅇ
						str += Integer.parseInt(split[split.length - 1])+1;
						System.out.println("str>>>" + str );
						tabList.get(i).setWfdesc(str);
					}else{
						System.out.println("else working");
						tabList.get(i).setWfdesc(tabList.get(i).getWfdesc() + "-0");
						desc.add(tabList.get(i).getWfdesc());
					}
				}else//중복이 없으면 desc에 추가
					desc.add(tabList.get(i).getWfdesc());
			}
		}

		System.out.println("desc >>" + desc);

		model.addAttribute("WorkFlowVo", tabList);
		System.out.println("TabList 갯수 : " + tabList.size() + "\n" + tabList);

		String wfdesc = tabList.get(0).getWfdesc();
		System.out.println("wfdesc:"+wfdesc);
		List<D_TableVO> colList = (List<D_TableVO>)lvDetailService.getColum(wfdesc);

		System.out.println("ColList 갯수 : " + colList.size() + "\n" + colList);

		/*
		 * D_ColItemVO 데이터 검색 로직
		 */


		List<D_ColItemVO> colItemList =  (List<D_ColItemVO>)lvDetailService.getColItem(desc.get(0));
		System.out.println("ColItemList 갯수 : " + colItemList.size() + "\n" + colItemList);

		//JSON 형태로 변환
		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		result.put("success", true);
		result.put("WorkFlowVo", tabList);
		result.put("D_TableVo", colList);
		result.put("D_ColItemVo",colItemList);
		System.out.println("tabList : " + JSONObject.fromObject(result).toString());
		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());
	}


	/**
	 * 해당 텝의 목록을 조회한다. 
	 * @param D_TableVO - 조회할 정보가 담긴 D_TableVO
	 * @param D_ColItemVO - 조회할 정보가 담긴 D_ColItemVO
	 * @param json
	 * @exception Exception
	 */
	@RequestMapping(value = "tabAction.do", method = RequestMethod.POST)
	@ResponseBody
	public void getTabAction(Locale locale,ModelMap model,HttpServletRequest request, HttpServletResponse response)throws Exception{
		log.info(">> getTabAction Method Working <<");

		String param = request.getParameter("param");
		System.out.println("param : " +param);

		/*
		 * D_TableVO 데이터 검색 로직
		 */
		List<D_TableVO> colList = null;
		if(param.contains("-")){
			String[] strArr = param.split("-");
			colList = getColData(strArr[0]);
			String str = "";
			for (int j = 0; j < strArr.length - 1; j++) {
				str += strArr[j] +"-";
			}
			str += strArr[strArr.length-1];
			System.out.println("str >>>>" + str);
		}
		else{
			colList = getColData(param);
		}

		System.out.println("ColList 갯수 : " + colList.size() + "\n" + colList);

		/*
		 * D_ColItemVO 데이터 검색 로직
		 */
		List<D_ColItemVO> colItemList =  getColItemData(param);
		System.out.println("ColItemList 갯수 : " + colItemList.size() + "\n" + colItemList);
		/*
		 * JSON 형태로 변환
		 * */
		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();

		if(colList.size() != 0)
			result.put("success", true);
		else
			result.put("error", false);

		result.put("D_TableVo", colList);
		result.put("D_ColItemVo",colItemList);
		System.out.println("D_TableVO : " + JSONObject.fromObject(result).toString());
		response.setHeader("Content-Type", "text/html; charset=UTF-8");
		response.getWriter().write(JSONObject.fromObject(result).toString());

	}

	/**
	 * 텝 목록을 조회한다. 
	 * @param D_TableVO - 조회할 정보가 담긴 D_TableVO
	 * @param json
	 * @exception Exception
	 */
	public List<D_TableVO> getColData(String wfdesc)throws Exception{
		log.info(">> getColData Method Working <<");
		return (List<D_TableVO>)lvDetailService.getColum(wfdesc);

	}

	/**
	 * 텝 목록을 조회한다. 
	 * @param D_ColItemVO - 조회할 정보가 담긴 D_ColItemVO
	 * @param json
	 * @exception Exception
	 */

	public List<D_ColItemVO> getColItemData(String tabname)throws Exception{
		System.out.println(">> getColItemData Method Working <<");
		return (List<D_ColItemVO>)lvDetailService.getColItem(tabname);

	}


	// 파일 존재여부
	@RequestMapping("/getExistFile.do")
	@ResponseBody
	public void getExistFile(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println(">> getExistFile Method Working <<");
		String vaultlno = request.getParameter("vaultlno"); //저장된 파일이름
		String docfilename = request.getParameter("docfilename"); //원래 파일이름

		System.out.println("vaultlno / docfilename : " + vaultlno + " / " + docfilename);
		String storageno = "", storagepath = "";
		boolean checkExistFile = false;
		JSONObject jObj = new JSONObject();
		File f = null;

		try {
			VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
			storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
			storagepath = vaultService.getStoragePath(storageno);

			System.out.println("storageno / storagepath : "+ storageno + " / " + storagepath);

			f = new File(storagepath+"/"+vaultlno+"/"+docfilename);

			if(f.exists()){ 
				System.out.println(storagepath+"/"+vaultlno+"/"+docfilename + " 파일존재!");
				checkExistFile = true;
			}

		} catch (Exception e) {
			// TODO: handle exception
		}finally{

			jObj.put("checkExistFile", checkExistFile);
			jObj.put("storagepath", storagepath+"/"+vaultlno);

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



	// 파일 오픈  -> 파일명, 파일패스 받아서 오픈
	@RequestMapping("/fileOpen.do")
	@ResponseBody
	public void fileOpen(HttpServletRequest request, HttpServletResponse response){
		System.out.println("파일오픈입니다");
		boolean rtncode = false;
		String rtnmsg = "";

		JSONObject jObj = new JSONObject();
		String path = "", fullPath = "";

		try {

			String f = request.getParameter("f"); //저장된 파일이름
			String of = request.getParameter("of"); //원래 파일이름
			//f = new String(f.getBytes("ISO8859_1"),"UTF-8"); 
			//of = new String(of.getBytes("ISO8859_1"),"UTF-8"); 
			//서버설정(server.xml)에 따로 인코딩을 지정하지 않았기 때문에 get방식으로 받은 값에 대해 인코딩 변환

			System.out.println("저장된 파일이름 : "+f);
			System.out.println("원래 파일이름 : "+of);

			//웹사이트 루트디렉토리의 실제 디스크상의 경로 알아내기.
			path = request.getParameter("filePath");   
			fullPath = path+"//"+f;

			System.out.println("path :"+path);        
			System.out.println("fullPath:" + fullPath);
			File downloadFile = new File(fullPath);

			Desktop.getDesktop().open(downloadFile);
			//	Desktop.getDesktop().edit(downloadFile);

			rtncode = true;
		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			if(!rtncode){
				rtnmsg = "The file: "+ fullPath + " doesn't exist. ";
			}

			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);

			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			try {
				response.getWriter().write(jObj.toString());
				System.out.println("겟라이트 완료");
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

		//Desktop.getDesktop().edit(downloadFile);
		//Desktop.getDesktop().edit(new File("D:\\temp\\aa.pdf"));
	}


	// 파일 오픈2   -> 파일 오브젝트 직접 넘겨서 오픈
	@RequestMapping("/fileOpen2.do")
	@ResponseBody
	public void fileOpen2(MultipartHttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  fileOpen2.do  <<");

		MultipartFile file = request.getFile("file");	
		System.out.println(file.getOriginalFilename());
		try {
			File f = multipartToFile(file);

			Desktop.getDesktop().open(f);

		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// 파일 오픈2   -> 파일경로 storagePath 가져온이후 오픈
	@RequestMapping("/docOpen.do")
	@ResponseBody
	public void docOpen(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  docOpen.do  <<");

		System.out.println(docdbvo);
		String storageno ="", storagepath="", vaultlno="";
		String rtnmsg = "";
		boolean rtncode = false;
		JSONObject jObj = new JSONObject();
		try {
			vaultlno = docdbvo.getVaultlno();
			VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
			storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
			System.out.println("storageno : " + storageno);
			storagepath = vaultService.getStoragePath(storageno);
			System.out.println("storagepath : " + storagepath + "/" + vaultlno);

			File f = new File(storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename());
			if(f.exists()){
				Desktop.getDesktop().open(f);
			}else{
				rtnmsg = "The file: "+storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename() + " doesn't exist. ";
				return;
			}
			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			e.getMessage();
		} finally{
			if(!rtncode){
				rtnmsg = "The file: "+storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename() + " doesn't exist. ";
			}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);

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


	// 파일 삭제
	@RequestMapping("/fileDelete.do")
	@ResponseBody
	public void fileDelete(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("파일삭제입니다");
		String fileName = request.getParameter("fileName"); //저장된 파일이름

		System.out.println("저장된 파일이름 : "+fileName);


		//웹사이트 루트디렉토리의 실제 디스크상의 경로 알아내기.
		String filePath = request.getParameter("filePath");   
		String fullPath = filePath+"//"+fileName;

		System.out.println("path :"+filePath);        
		System.out.println("fullPath:" + fullPath);
		File f = new File(fullPath);

		if (f.delete()) {
			System.out.println("파일 또는 디렉토리를 성공적으로 지웠습니다: " + fullPath);
		} else {
			System.err.println("파일 또는 디렉토리 지우기 실패: " + fullPath);
		}
	}

	// 파일  다운로드
	@RequestMapping("/fileDownload.do")
	@ResponseBody
	public void fileDownload(HttpServletRequest request, HttpServletResponse response) throws Exception{
		System.out.println("파일오픈입니다");
		String f = request.getParameter("f"); //저장된 파일이름
		String of = request.getParameter("of"); //원래 파일이름
		//f = new String(f.getBytes("ISO8859_1"),"UTF-8"); 
		//of = new String(of.getBytes("ISO8859_1"),"UTF-8"); 
		//서버설정(server.xml)에 따로 인코딩을 지정하지 않았기 때문에 get방식으로 받은 값에 대해 인코딩 변환

		System.out.println("저장된 파일이름 : "+f);
		System.out.println("원래 파일이름 : "+of);

		//웹사이트 루트디렉토리의 실제 디스크상의 경로 알아내기.
		String path = request.getParameter("filePath");   
		String fullPath = path+"//"+f;

		System.out.println("path :"+path);        
		System.out.println("fullPath:" + fullPath);
		File downloadFile = new File(fullPath);


		response.setContentLength((int)downloadFile.length());//파일 사이즈 지정
		response.setContentType("application/octet-stream; charset=utf-8");//다운로드 창을 띄우기 위한 헤더


		String userAgent = request.getHeader("User-Agent");

		if (userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
			response.setHeader("Content-Disposition", "filename="
					+ URLEncoder.encode(of, "UTF-8").replaceAll("\\+",
							"\\ ") + ";");
		} else if (userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
			response.setHeader("Content-Disposition", "attachment; filename="
					+ java.net.URLEncoder.encode(of, "UTF-8").replaceAll(
							"\\+", "\\ ") + ";");
		} else if (userAgent.indexOf("Trident") > -1) { //MS IE 11
			response.setHeader("Content-Disposition", "attachment; filename="
					+ java.net.URLEncoder.encode(of, "UTF-8").replaceAll(
							"\\+", "\\ ") + ";");
		} else{
			response.setHeader("Content-Disposition", "attachment;filename="
					+ new String(of.getBytes(), "ISO8859_1"));

			response.setHeader("Content-Transfer-Encoding","binary");
		}
		if (downloadFile.length() > 0) {
			response.setHeader("Content-Length", "" + downloadFile.length());
		}


		/*
		 * Content-disposition 속성
		 * 1) "Content-disposition: attachment" 브라우저 인식 파일확장자를 포함하여 모든 확장자의 파일들에 대해
		 *                          , 다운로드시 무조건 "파일 다운로드" 대화상자가 뜨도록 하는 헤더속성이다
		 * 2) "Content-disposition: inline" 브라우저 인식 파일확장자를 가진 파일들에 대해서는 
		 *                                  웹브라우저 상에서 바로 파일을 열고, 그외의 파일들에 대해서는 
		 *                                  "파일 다운로드" 대화상자가 뜨도록 하는 헤더속성이다.
		 */

		FileInputStream fin = new FileInputStream(downloadFile);
		ServletOutputStream sout = response.getOutputStream();

		byte[] buf = new byte[1024];
		int size = -1;

		while ((size = fin.read(buf, 0, buf.length)) != -1) {
			sout.write(buf, 0, size);
		}
		fin.close();
		sout.close();

		System.out.println("파일실행!");
	}

	// 파일 오픈2   -> 파일경로 storagePath 가져온이후 오픈
	@RequestMapping("/docDowload.do")
	@ResponseBody
	public void docDowload(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  docDowload.do  <<");

		System.out.println(docdbvo);
		String storageno ="", storagepath="", vaultlno="", filename = "";
		try {
			vaultlno = docdbvo.getVaultlno();
			VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
			storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
			System.out.println("storageno : " + storageno);
			storagepath = vaultService.getStoragePath(storageno);

			//filename = docdbvo.getDocfilename();
			filename = URLDecoder.decode(request.getParameter("filename"), "UTF-8");
			System.out.println("storagepath : " + storagepath + "/" + vaultlno+ "/" + filename);

			File downloadFile = new File(storagepath + "/"+ vaultlno + "/" + filename);


			//File downloadFile = new File(fullPath);


			response.setContentLength((int)downloadFile.length());//파일 사이즈 지정
			response.setContentType("application/octet-stream; charset=utf-8");//다운로드 창을 띄우기 위한 헤더


			String userAgent = request.getHeader("User-Agent");

			if (userAgent.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
				response.setHeader("Content-Disposition", "filename="
						+ URLEncoder.encode(filename, "UTF-8").replaceAll("\\+",
								"\\ ") + ";");
			} else if (userAgent.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
				response.setHeader("Content-Disposition", "attachment; filename="
						+ java.net.URLEncoder.encode(filename, "UTF-8").replaceAll(
								"\\+", "\\ ") + ";");
			} else if (userAgent.indexOf("Trident") > -1) { //MS IE 11
				response.setHeader("Content-Disposition", "attachment; filename="
						+ java.net.URLEncoder.encode(filename, "UTF-8").replaceAll(
								"\\+", "\\ ") + ";");
			} else{
				response.setHeader("Content-Disposition", "attachment;filename="
						+ new String(filename.getBytes(), "ISO8859_1"));

				response.setHeader("Content-Transfer-Encoding","binary");
			}
			if (downloadFile.length() > 0) {
				response.setHeader("Content-Length", "" + downloadFile.length());
			}


			FileInputStream fin = new FileInputStream(downloadFile);
			ServletOutputStream sout = response.getOutputStream();

			byte[] buf = new byte[1024];
			int size = -1;

			while ((size = fin.read(buf, 0, buf.length)) != -1) {
				sout.write(buf, 0, size);
			}
			fin.close();
			sout.close();

			System.out.println("파일실행!");

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{

		}
	}


	// edit 
	@RequestMapping("/docOpenEditVersion.do")
	@ResponseBody
	public void docOpenEditVersion(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  docOpenEditVersion.do  <<");

		System.out.println(docdbvo);
		String storageno ="", storagepath="", vaultlno="", fullpath = "", temppath="D:/temp";
		String rtnmsg = "", dbname = "";
		boolean rtncode = false, checkEditFile = false;;
		long beforeModifyDate = 0, afterModifyDate = 0;
		int docversion = 0;
		JSONObject jObj = new JSONObject();

		try {
			vaultlno = docdbvo.getVaultlno();
			VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
			dbname = vaultvo.getDocdbName();
			docdbvo.setDbname(dbname);

			List<D_DocdbVO> docdb = (List<D_DocdbVO>)lvDetailService.getDocdb(docdbvo);
			docdbvo = docdb.get(0);
			docversion = docdbvo.getDocversion();
			System.out.println("docversion : "+docversion);
			docversion++;

			storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기
			System.out.println("storageno : " + storageno);
			storagepath = vaultService.getStoragePath(storageno);
			System.out.println("storagepath : " + storagepath + "/" + vaultlno);

			File f = new File(storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename());
			beforeModifyDate = f.lastModified();

			if(f.exists()){
				copyFile(f, temppath); // D://temp에 파일 임시저장
			}else{
				return;
			}
			fullpath = storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename();
			String[] cmd = { "cmd.exe", "/c", "start /wait " + fullpath };
			Process p = Runtime.getRuntime().exec(cmd);
			//Process p = new ProcessBuilder("explorer.exe", "/select," + fullpath).start(); //탐색기
			p.waitFor();
			System.out.println("done.");

			f = new File(storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename());
			afterModifyDate = f.lastModified();

			System.out.println("수정전:"+beforeModifyDate + ", 수정후:"+afterModifyDate);
			if(beforeModifyDate != afterModifyDate) { 
				checkEditFile = true;

				//docver = lvDetailService.getDocverDocdb(docdbvo.getDocno());
			}

			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			if(!rtncode){
				rtnmsg = "The file: "+storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename() + " doesn't exist. ";
			}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("checkEditFile", checkEditFile);
			jObj.put("docversion", docversion);
			jObj.put("filepath", storagepath + "/" + vaultlno);
			jObj.put("dbname", dbname);

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

	// Edit Only
	@RequestMapping("/docOpenEditOnly.do")
	@ResponseBody
	public void docOpenEditOnly(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  docOpenEditOnly.do  <<");

		System.out.println(docdbvo);
		String storageno ="", storagepath="", vaultlno="", fullpath = "", temppath="D:/temp";
		String rtnmsg = "", dbname="";
		boolean rtncode = false, checkEditFile = false;;
		long beforeModifyDate = 0, afterModifyDate = 0;
		int docversion = 0;
		JSONObject jObj = new JSONObject();

		try {
			vaultlno = docdbvo.getVaultlno();
			VaultVo vaultvo = vaultService.getVaultlInfo(vaultlno);
			storageno = vaultvo.getStorageNo();   // 파일 저장 경로 가져오기

			System.out.println("dbname:"+vaultvo.getDocdbName());
			System.out.println("storageno : " + storageno);
			storagepath = vaultService.getStoragePath(storageno);
			System.out.println("storagepath : " + storagepath + "/" + vaultlno);

			dbname = vaultvo.getDocdbName();
			docdbvo.setDbname(dbname);
			List<D_DocdbVO> docdb = (List<D_DocdbVO>)lvDetailService.getDocdb(docdbvo);
			docdbvo = docdb.get(0);
			docversion = docdbvo.getDocversion();
			System.out.println("docversion : "+docversion);


			File f = new File(storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename());
			beforeModifyDate = f.lastModified();

			if(f.exists()){
				copyFile(f, temppath); // D://temp에 파일 임시저장
			}else{
				return;
			}
			fullpath = storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename();
			String[] cmd = { "cmd.exe", "/c", "start /wait " + fullpath };
			Process p = Runtime.getRuntime().exec(cmd);  // 파일 오픈 파일명에 띄어쓰기 있으면 안열림
			//Process p = new ProcessBuilder("explorer.exe", "/select," + fullpath).start(); //탐색기
			p.waitFor();
			System.out.println("done.");

			f = new File(storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename());
			afterModifyDate = f.lastModified();

			System.out.println("수정전:"+beforeModifyDate + ", 수정후:"+afterModifyDate);
			if(beforeModifyDate != afterModifyDate) { checkEditFile = true;}

			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally{
			if(!rtncode){
				rtnmsg = "The file: "+storagepath + "/" + vaultlno + "/" + docdbvo.getDocfilename() + " doesn't exist. ";
			}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);
			jObj.put("checkEditFile", checkEditFile);
			jObj.put("docversion", docversion);
			jObj.put("dbname", dbname);
			jObj.put("filepath", storagepath + "/" + vaultlno);

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

	// insert History Only
	@RequestMapping("/insertHistoryOnly.do")
	@ResponseBody
	public void insertHistoryOnly(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  insertHistoryOnly.do  <<");

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		System.out.println(docdbvo);
		JSONObject jObj = new JSONObject();
		String rtnmsg = "", projectname="",histcontent="", filepath = "", 
				newfilepath="", filename ="";
		int docversion = 0;
		boolean rtncode = false;

		try {
			projectname = request.getParameter("projectname");
			histcontent = request.getParameter("histcontent");
			filepath = request.getParameter("filepath");

			System.out.println("projectname / histcontent / filepath : " + 
					projectname + " / " + histcontent + " / "+ filepath); 
			filename = docdbvo.getDocfilename();
			docversion = docdbvo.getDocversion();

			System.out.println("filename / docversion : " + filename + " / " + docversion);

			D_HistoryVO historyvo = new D_HistoryVO();
			historyvo.setProjectname(projectname);
			historyvo.setHistcontent(histcontent);

			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");
			historyvo.setCreator(uservo.getUserno());
			historyvo.setDocversion(docversion);
			historyvo.setHistkind("*");
			historyvo.setProjecttype("*");
			historyvo.setDocno(docdbvo.getDocno());

			rtnmsg = lvDetailService.updateHistory(historyvo);

			docdbvo.setDocupdator(uservo.getUserno());
			docdbvo.setDoccreatordept(uservo.getUserdeptname());


			if(rtnmsg.equals("S")){

				rtnmsg = lvDetailService.updateDocdb(docdbvo);
				System.out.println(rtnmsg + " : updatedocdb 완료");

				rtncode = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally{

			if(rtncode){txManager.commit(txStauts); System.out.println("커밋");}
			else{txManager.rollback(txStauts); System.out.println("롤백");}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);


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

	// insert History Version
	@RequestMapping("/insertHistoryVersion.do")
	@ResponseBody
	public void insertHistory(D_DocdbVO docdbvo,HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >>  insertHistoryVersion.do  <<");

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus txStauts = txManager.getTransaction(def);

		System.out.println(docdbvo);
		JSONObject jObj = new JSONObject();
		String rtnmsg = "", projectname="",histcontent="", filepath = "", 
				newfilepath="", filename ="";
		int docversion = 0;
		boolean rtncode = false;

		try {
			projectname = request.getParameter("projectname");
			histcontent = request.getParameter("histcontent");
			filepath = request.getParameter("filepath");

			System.out.println("projectname / histcontent / filepath : " + 
					projectname + " / " + histcontent + " / "+ filepath); 
			filename = docdbvo.getDocfilename();
			docversion = docdbvo.getDocversion();

			System.out.println("filename / docversion : " + filename + " / " + docversion);

			D_HistoryVO historyvo = new D_HistoryVO();
			historyvo.setProjectname(projectname);
			historyvo.setHistcontent(histcontent);

			HttpSession session = request.getSession();
			D_UserVO uservo = (D_UserVO) session.getAttribute("loginInfo");
			historyvo.setCreator(uservo.getUserno());
			historyvo.setDocversion(docversion);
			historyvo.setHistkind("*");
			historyvo.setProjecttype("*");
			historyvo.setDocno(docdbvo.getDocno());

			rtnmsg = lvDetailService.insertHistory(historyvo);

			docdbvo.setDocupdator(uservo.getUserno());
			docdbvo.setDoccreatordept(uservo.getUserdeptname());


			if(rtnmsg.equals("S")){

				rtnmsg = lvDetailService.updateDocdb(docdbvo);
				System.out.println(rtnmsg + " : updatedocdb 완료");
				if( rtnmsg.equals("S") && (docversion > 0) ){ //edit version  -> move file
					System.out.println("temp 파일 version 폴더로 이동 시작");

					newfilepath = filepath+"//"+ "version"+String.format("%03d", docversion);
					String tempPath = "D://temp";

					File tempFile = new File(tempPath+"//"+filename);

					if(tempFile.exists()){
						copyFile(tempFile, newfilepath);  // renameTo 안되서 copyFile 씀
						boolean delete = tempFile.delete();
						System.out.println("삭제완료:"+delete);
						//	tempFile.renameTo(new File(newfilepathDir + "\\" + tempFile.getName()));
						System.out.println("파일이동완료 : " + newfilepath + "/" + tempFile.getName());
					}else{
						rtnmsg="temp에 파일 미존재 : "+"D://temp//"+filename;
						return;
					}
				}
				rtncode = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally{

			if(rtncode){txManager.commit(txStauts); System.out.println("커밋");}
			else{txManager.rollback(txStauts); System.out.println("롤백");}
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);


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

	// Edit Cancel -> C://temp File back up
	@RequestMapping("/cancelHistory.do")
	@ResponseBody
	public void cancelHistory(HttpServletRequest request, HttpServletResponse response) 
	{
		System.out.println(" >> cancelHistory.do   <<");
		JSONObject jObj = new JSONObject();
		String rtnmsg = "", filename="", filepath="", temppath="D://temp";
		boolean rtncode = false;

		try {
			filename = request.getParameter("filename");
			filepath = request.getParameter("filepath");

			System.out.println("filepath / filename : " + filepath + " / " + filename);
			File tempf = new File(temppath+ "//"+filename);
			File f = new File(filepath + "//" + filename);

			f.delete();                        // renameTo 안되서 copyFile 씀
			copyFile(tempf, filepath);
			tempf.delete();
			System.out.println("템프파일 이동");
			rtncode = true;
		} catch (Exception e) {
			// TODO: handle exception
		} finally{
			jObj.put("rtncode", rtncode);
			jObj.put("rtnmsg", rtnmsg);

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

	// 그리드꺼만 다운
	@RequestMapping(value = "/exeldown.do", method = RequestMethod.POST)
	@ResponseBody
	public void exeldown(HttpServletRequest request, HttpServletResponse response, 
			String[] gridArray)
					throws Exception {

		System.out.println(" >> exeldown Controller  <<");

		JSONArray jsonArr = new JSONArray();
		JSONObject jsonObj = new JSONObject();
		String rtnmsg = "";
		boolean rtncode = false;
		String xlsFileName = "";
		String xlsFilePath ="";

		try {
			if(gridArray.length == 0){
				rtnmsg = "데이터가 없습니다.";
				return;
			}


			Workbook xlsxWb = new SXSSFWorkbook(1000); // keep 100 rows in memory, exceeding rows will be flushed to disk
			Sheet sheet = xlsxWb.createSheet();
			Row row = null;    //새로운 엑셀의 로우 생성
			Cell cell = null; //새로운 엑셀의 셀 생성


			for (int i = 0; i < gridArray.length; i++) {
				System.out.println(gridArray[i]);
				row = sheet.createRow(i);
				String[] gridArraySplit = gridArray[i].split("\\^");
				for (int j = 0; j < gridArraySplit.length; j++) {	
					cell = row.createCell(j);
					cell.setCellValue(gridArraySplit[j]);
					if(gridArraySplit[j].equals("undefined")){
						cell.setCellValue("");
					}
				}
			}

			long time = System.currentTimeMillis(); 
			SimpleDateFormat dayTime = new SimpleDateFormat("yyyyMMdd-kkmmss");
			String curtime = dayTime.format(new Date(time));
			System.out.println("현재시간:" + curtime);

			xlsFileName = curtime+"-"+"exelFile.xlsx";
			xlsFilePath = "D:\\temp";

			File targetDir = new File(xlsFilePath); //엑셀 파일저장
			if(!targetDir.exists()) {    //디렉토리 없으면 생성.
				targetDir.mkdirs();				       
			}

			String xlsFullPath = xlsFilePath+"\\"+xlsFileName;
			System.out.println("xlsFullPath : " + xlsFullPath);
			File xlsFile = new File(xlsFullPath);
			FileOutputStream fileOut = new FileOutputStream(xlsFile);
			xlsxWb.write(fileOut);

			System.out.println("엑셀파일 생성 완료");

			rtnmsg = "엑셀파일 생성을 완료하였습니다. ";
			rtncode = true;

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {

			jsonObj.put("fileName", xlsFileName);
			jsonObj.put("filePath", xlsFilePath);
			jsonObj.put("rtncode", rtncode);
			jsonObj.put("rtnmsg", rtnmsg);
			response.setHeader("Content-Type", "text/html; charset=UTF-8");
			System.out.println("겟라이트하는중~");
			response.getWriter().write(jsonObj.toString());


			System.out.println("완료");
		}
	}

	// multipartfile -> file convert
	public File multipartToFile(MultipartFile multipart) throws IllegalStateException, IOException 
	{
		File convFile = new File( multipart.getOriginalFilename());
		multipart.transferTo(convFile);
		return convFile;
	}

	// copyFile 복사할파일, 복사할 위치
	public boolean copyFile(File f, String filepath)
	{
		boolean checkCopyFile = false;
		FileInputStream input = null;
		FileOutputStream output = null;

		try {
			File targetDir = new File(filepath); 
			if(!targetDir.exists()) {    //디렉토리 없으면 생성.
				targetDir.mkdirs();				       
			}

			input = new FileInputStream(f);
			// 복사된 파일의 위치를 지정해준다.
			output = new FileOutputStream(new File(filepath +"/"+f.getName()));

			int readBuffer = 0;
			byte [] buffer = new byte[512];
			while((readBuffer = input.read(buffer)) != -1) {
				output.write(buffer, 0, readBuffer);
			}
			System.out.println("파일이 복사되었습니다." + filepath +"/"+f.getName());
			checkCopyFile = true;
		} catch (Exception e) {
			// TODO: handle exception
		}finally{
			try {
				output.close();
				input.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			return checkCopyFile;
		}
	}

}
