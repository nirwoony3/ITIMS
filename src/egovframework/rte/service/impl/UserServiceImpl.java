package egovframework.rte.service.impl;

import java.util.HashMap;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.UserDAO;
import egovframework.rte.service.UserService;
import egovframework.rte.vo.D_UserVO;


@Service("userService")
public class UserServiceImpl implements UserService {
	
	@Resource(name="userDAO")
	UserDAO userDAO;
	
	@Override
	public HashMap<Integer, D_UserVO> loginCheck(D_UserVO userVo)
			throws Exception {
		// TODO Auto-generated method stub
		return userDAO.loginCheck(userVo);
	}

	@Override
	public String updPassword(D_UserVO userVO) throws Exception {
		// TODO Auto-generated method stub
		return userDAO.updPassword(userVO);
	}
}	
