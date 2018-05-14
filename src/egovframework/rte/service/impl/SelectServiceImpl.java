package egovframework.rte.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.SelectDAO;
import egovframework.rte.service.SelectService;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.D_WorkFlowVO;
import egovframework.rte.vo.D_WorkflowchghistVO;
import egovframework.rte.vo.D_pgmVO;

@Service("selectService")
public class SelectServiceImpl implements SelectService {
	@Resource(name="selectDAO")
	SelectDAO selectDAO;
	
	@Override
	public List<D_FileattachVO> getFileAttach(D_FileattachVO fileattachvo) {
		// TODO Auto-generated method stub
		return selectDAO.getFileAttach(fileattachvo);
	}

	@Override
	public List<D_UserVO> getUserList(D_UserVO uservo) throws Exception {
		// TODO Auto-generated method stub
		return selectDAO.getUserList(uservo);
	}

	@Override
	public List<D_WorkflowchghistVO> getWorkflowHisList(D_WorkflowchghistVO workflowvo)
			throws Exception {
		// TODO Auto-generated method stub
		return selectDAO.getWorkflowHisList(workflowvo);
	}

	@Override
	public List<D_pgmVO> getPgmList() throws Exception {
		// TODO Auto-generated method stub
		return selectDAO.getPgmList();
	}
}
