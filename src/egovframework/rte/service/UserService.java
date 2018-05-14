package egovframework.rte.service;

import java.util.HashMap;

import egovframework.rte.vo.D_UserVO;

public interface UserService {

	//로그인
	HashMap<Integer, D_UserVO> loginCheck(D_UserVO userVo)throws Exception;
	public String updPassword(D_UserVO userVO) throws Exception;
}
