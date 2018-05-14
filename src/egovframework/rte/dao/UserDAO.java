package egovframework.rte.dao;

import java.util.HashMap;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.vo.D_UserVO;

@Repository("userDAO")
public class UserDAO extends EgovAbstractDAO{
	
	public static final int OK = 1;
	public static final int NOT_PW = 2;
	public static final int NOT_ID = 3;
	public static final int ERR = -1;
	
	Object nullvalue = "";
	public HashMap<Integer, D_UserVO> loginCheck(D_UserVO userVO) throws Exception {
		System.out.println("loginCheck () DAO");
		
		System.out.println("userVo : " + userVO);
		String rtnStr = "";
		HashMap<Integer, D_UserVO> resMap = new HashMap<Integer, D_UserVO>();
		D_UserVO resDto = null;
		try {
		resDto = (D_UserVO)selectByPk("userDAO.loginCheck", userVO);
		System.out.println("resDTO : " + resDto);
			if (resDto != null) {
				if (userVO.getUserpassword().equals(resDto.getUserpassword())) {
					System.out.println("1");
					resMap.put(OK, resDto);
					return resMap;
				} else { //비밀번호 다름
					resMap.put(NOT_PW, null);
					System.out.println("2");
					return resMap;
				}
			} else { //아이디 없음
				resMap.put(NOT_ID, null);
				System.out.println("3");
				return resMap;
			}
		} catch (Exception e) { //DB 문제
			resMap.put(ERR, resDto);
			rtnStr=e.getMessage();
	         String rtnsstr[] = rtnStr.split(":");
	         rtnStr = "E:"+rtnsstr[3];
	         System.out.println(rtnStr);
			System.out.println("4");
			return resMap;
		}
		
	}
	
	public String updPassword(D_UserVO userVO) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("updPassword() DAO 진입");
		String rtnStr="";
	       try{
	    	  update("userDAO.updPassword",userVO);
	         rtnStr="S";
	      }catch(Exception e){
	         System.out.println("----------------------");
	         rtnStr=e.getMessage();
	         String rtnsstr[] = rtnStr.split(":");
	         rtnStr = "E:"+rtnsstr[3];
	      }
	       System.out.println(">>" + rtnStr);
	       return rtnStr;
	}
}
