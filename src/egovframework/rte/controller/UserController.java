package egovframework.rte.controller;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;









import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.hsqldb.lib.StringUtil;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sun.istack.internal.logging.Logger;

import egovframework.rte.dao.UserDAO;
import egovframework.rte.service.UserService;
import egovframework.rte.vo.D_UserVO;


@Controller
public class UserController {
	
	Logger log = Logger.getLogger(UserController.class);
	
	@Resource(name="userService")
	UserService userService;
	
	
	@RequestMapping(value = "/login.do")
	public String loginForm( ModelMap model) throws Exception {
		System.out.println("- login Form -");
		return "F_LOGIN";
	}
	
	/**
	 * 로그인 정보 조회 
	 * @param UserVO - 회원정보가 담긴 VO
	 * @param model
	 * @return "egovSampleList"
	 * @exception Exception
	 */
	@RequestMapping(value="/loginAction.do")
	/*@ResponseBody*/
	public void loginAction(ModelMap model,HttpServletRequest request, HttpServletResponse response,D_UserVO userVO)throws Exception{
		//log.info(">> loginAction Method Working <<");
		
		System.out.println(userVO);
		HashMap<String, Object> result = new HashMap<String, Object>();
		JSONArray arrayObj = new JSONArray();
		StringUtil su = new StringUtil();
		
		// -- LoginDAO 호출
		HashMap<Integer, D_UserVO> resMap = userService.loginCheck(userVO);
		
		// -- HashMap 데이터 꺼내기
		Set<Map.Entry<Integer, D_UserVO>> entries = resMap.entrySet();
		
		Iterator<Entry<Integer, D_UserVO>> it = entries.iterator();
		Integer key = null;
		D_UserVO	resVo = null;
		while (it.hasNext()) {
			Entry<Integer, D_UserVO> entry = it.next();
			key = entry.getKey();
			System.out.println("key : " + key);
			resVo = entry.getValue();
		}
		
		String resMsg = "";
		/*if(resVo != null){
			String pw = resVo.getUserpassword();
			Pattern p = Pattern.compile("([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])");
			Matcher m = p.matcher(pw);
			
			
			   //비밀번호 유효성 검사
				if(pw.length() < 8){
					System.out.println(pw  + " :" + pw.length());
					key = Integer.parseInt("5");
				}else if(key != 2){
					if (m.find()){
					    System.err.println(pw + " 은 패턴에 해당함!!!");
					    key = UserDAO.OK;
					}else{
					  System.err.println(pw + " 은 패턴에 어긋남!!!");
					  key = Integer.parseInt("5");
					}
				}
			}*/
		switch ((int)key) {
		case UserDAO.OK: //1
			resMsg = "" + UserDAO.OK;
			result.put("resVo", resVo);
			HttpSession session = request.getSession();
			session.setAttribute("loginInfo", resVo);
			//세션시간 설정 초단위
			//session.setMaxInactiveInterval(7200); // 3600 * 8 시간 600 10분 1800
			int sessionTime = session.getMaxInactiveInterval(); 
			System.out.println("1. 세션 허용시간 : "+sessionTime);
			
			break;
		case UserDAO.NOT_PW: //2
			resMsg = "" + UserDAO.NOT_PW;
			System.out.println("case : "+ UserDAO.NOT_PW);
			break;
		case UserDAO.NOT_ID: //3
			resMsg = "" + UserDAO.NOT_ID;
			System.out.println("case : "+ UserDAO.NOT_ID);
			break;
		case UserDAO.ERR: //-1
			resMsg = "" + UserDAO.ERR;
			System.out.println("case : "+ UserDAO.ERR);
			break;
		/*case 5:
			resMsg = "" + 5;
			result.put("resVo", resVo);
			System.out.println("case : 5");
			break;		*/
		}
		
		/*D_UserVO loginInfo = new D_UserVO();
		loginInfo.setUserno("777777");
		loginInfo.setUsername("홍길동");
		loginInfo.setUserdeptcode("25114");
		loginInfo.setUserdeptname("개발팀");
		
		HttpSession session = request.getSession();
		session.setAttribute("loginInfo", loginInfo);
		return "views/main";
		
		return "login";*/
		
		result.put("resMsg", resMsg);
        response.setHeader("Content-Type", "text/html; charset=UTF-8");
        response.getWriter().write(JSONObject.fromObject(result).toString());
	}
}
