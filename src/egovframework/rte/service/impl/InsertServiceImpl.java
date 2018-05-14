package egovframework.rte.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.InsertDAO;
import egovframework.rte.service.InsertService;
import egovframework.rte.vo.D_ApprprocVO;

@Service("insertService")
public class InsertServiceImpl implements InsertService {
	@Resource(name="insertDAO")
	InsertDAO insertDAO;

	@Override
	public String insertApprproc(D_ApprprocVO approcvo) throws Exception {
		// TODO Auto-generated method stub
		return insertDAO.insertApprproc(approcvo);
	}
}
