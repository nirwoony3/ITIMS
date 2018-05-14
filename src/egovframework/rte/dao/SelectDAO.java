package egovframework.rte.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.D_WorkFlowVO;
import egovframework.rte.vo.D_WorkflowchghistVO;
import egovframework.rte.vo.D_pgmVO;

@Repository("selectDAO")
public class SelectDAO extends EgovAbstractDAO {

	public List<D_FileattachVO> getFileAttach(D_FileattachVO fileattachvo) {
		// TODO Auto-generated method stub
		return (List<D_FileattachVO>) list("selectDAO.getFileAttach", fileattachvo);
	}

	public List<D_UserVO> getUserList(D_UserVO uservo) {
		// TODO Auto-generated method stub
		return (List<D_UserVO>) list("selectDAO.getUserList", uservo);
	}

	public List<D_WorkflowchghistVO> getWorkflowHisList(D_WorkflowchghistVO workflowvo) {
		// TODO Auto-generated method stub
		return (List<D_WorkflowchghistVO>) list("selectDAO.getWorkflowHisList", workflowvo);
	}

	public List<D_pgmVO> getPgmList() {
		// TODO Auto-generated method stub
		return (List<D_pgmVO>) list("selectDAO.getPgmList");
	}

}
