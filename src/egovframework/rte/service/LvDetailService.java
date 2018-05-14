package egovframework.rte.service;

import java.util.List;

import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_HistoryVO;

public interface LvDetailService {

	/**
	 * 탭 정보 조회.
	 * @param vaultNo 
	 * @return 조회 결과
	 * @exception Exception
	 */
	List<?> getTabsList(String vaultlNo)throws Exception;
	
	/**
	 * D_Table 테이블의 데이터 조회.
	 * @param String - 조회할 정보가 담긴 String(문자열)
	 * @return 조회 결과
	 * @exception Exception
	 */
	List<?> getColum(String wfdesc)throws Exception;
	
	/**
	 * D_ColItem 테이블의 데이터 조회.  
	 * @param D_ColItemVO - 조회할 정보가 담긴 D_ColItemVO
	 * @param json
	 * @exception Exception
	 */
	List<?> getColItem(String tabname)throws Exception;
	List<?> getDocapprstatus()throws Exception;
	public String getDocno(String dbname) throws Exception;
	List<?> getDocdb(D_DocdbVO docdbVO)throws Exception;

	String insertDocdb(D_DocdbVO docdbvo)throws Exception;

	String insertFileAttach(D_FileattachVO fileattachvo)throws Exception;

	

	String deleteFileAttach(D_FileattachVO fileattachvo) throws Exception;

	String updateDocdb(D_DocdbVO docdbvo);

	String insertHistory(D_HistoryVO historyvo);

	String updateHistory(D_HistoryVO historyvo);


}
