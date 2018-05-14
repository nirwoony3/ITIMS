package egovframework.rte.service;

import java.util.List;

import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_UserVO;
import egovframework.rte.vo.D_WorkFlowVO;
import egovframework.rte.vo.D_WorkflowchghistVO;
import egovframework.rte.vo.D_pgmVO;

public interface SelectService {
	List<D_FileattachVO> getFileAttach(D_FileattachVO fileattachvo)throws Exception;

	List<D_UserVO> getUserList(D_UserVO uservo) throws Exception;

	List<D_WorkflowchghistVO> getWorkflowHisList(D_WorkflowchghistVO workflowvo)throws Exception;

	List<D_pgmVO> getPgmList() throws Exception;
}
