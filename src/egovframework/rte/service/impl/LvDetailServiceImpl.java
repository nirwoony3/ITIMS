package egovframework.rte.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.sun.istack.internal.logging.Logger;

import egovframework.rte.controller.UserController;
import egovframework.rte.dao.LvDetailDAO;
import egovframework.rte.service.LvDetailService;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_HistoryVO;

@Service("lvDetailService")
public class LvDetailServiceImpl implements LvDetailService {
	
	@Resource(name="lvDetailDAO")
	LvDetailDAO lvDetailDAO;
	
	Logger log = Logger.getLogger(UserController.class);
	
	/**
	 * 탭 정보 조회.
	 * @return 조회 결과
	 * @exception Exception
	 */
	@Override
	public List<?> getTabsList(String vaultlNo) throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.getTabsList(vaultlNo);
	}
	
	/**
	 * D_Table 테이블의 데이터 조회.
	 * @param String - 조회할 정보가 담긴 String(문자열)
	 * @return 조회 결과
	 * @exception Exception
	 */
	@Override
	public List<?> getColum(String wfdesc) throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.getColum(wfdesc);
	}
	
	/**
	 * D_ColItem 테이블의 데이터 조회. 
	 * @param D_ColItemVO - 조회할 정보가 담긴 D_ColItemVO
	 * @param json
	 * @exception Exception
	 */
	@Override
	public List<?> getColItem(String tabname)throws Exception{
		return lvDetailDAO.getColItem(tabname);
	}

	@Override
	public List<?> getDocapprstatus() throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.getDocapprstatus();
	}

	@Override
	public String getDocno(String dbname) throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.getDocno(dbname);
	}

	@Override
	public List<?> getDocdb(D_DocdbVO docdbVO) throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.getDocdb(docdbVO);
	}

	@Override
	public String insertDocdb(D_DocdbVO docdbvo) throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.insertDocdb(docdbvo);
	}

	@Override
	public String insertFileAttach(D_FileattachVO fileattachvo)
			throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.insertFileAttach(fileattachvo);
	}

	@Override
	public String deleteFileAttach(D_FileattachVO fileattachvo)
			throws Exception {
		// TODO Auto-generated method stub
		return lvDetailDAO.deleteFileAttach(fileattachvo);
	}


	@Override
	public String updateDocdb(D_DocdbVO docdbvo) {
		// TODO Auto-generated method stub
		return lvDetailDAO.updateDocdb(docdbvo);
	}

	@Override
	public String insertHistory(D_HistoryVO historyvo) {
		// TODO Auto-generated method stub
		return lvDetailDAO.insertHistory(historyvo);
	}

	@Override
	public String updateHistory(D_HistoryVO historyvo) {
		// TODO Auto-generated method stub
		return lvDetailDAO.updateHistory(historyvo);
	}


}
