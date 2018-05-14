package egovframework.rte.dao;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.D_FileattachVO;
import egovframework.rte.vo.D_HistoryVO;

@Repository("lvDetailDAO")
public class LvDetailDAO extends EgovAbstractDAO {

	@Resource(name = "txManager")
	protected DataSourceTransactionManager txManager;

	/**
	 * 탭 정보 조회.
	 * @param vaultNo 
	 * @return 조회 결과
	 * @exception Exception
	 */
	public List<?> getTabsList(String vaultlNo) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("vaultlNo DAO : " + vaultlNo);
		return list("detailDAO.getTabsList", vaultlNo);
	}

	/**
	 * D_Table 테이블의 데이터 조회.
	 * @param String - 조회할 정보가 담긴 String(문자열)
	 * @return 조회 결과
	 * @exception Exception
	 */
	public List<?> getColum(String wfdesc) throws Exception {
		// TODO Auto-generated method stub
		return list("detailDAO.getColum", wfdesc);
	}

	/**
	 * D_ColItem 테이블의 데이터 조회. 
	 * @param D_ColItemVO - 조회할 정보가 담긴 D_ColItemVO
	 * @param json
	 * @exception Exception
	 */
	public List<?> getColItem(String tabname)throws Exception{
		return list("detailDAO.getColItem",tabname);
	};

	public List<?> getDocapprstatus() throws Exception {
		// TODO Auto-generated method stub
		return list("detailDAO.getDocapprstatus");
	};

	public String getDocno(String dbname) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("getDocno DAO");
		String rtnStr="";
		try{
			if(dbname.equals("D_DOCDB1"))
				rtnStr = (String)select("detailDAO.getDocno1");
			else if(dbname.equals("D_DOCDB2"))
				rtnStr = (String)select("detailDAO.getDocno2");

		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	};

	public List<?> getDocdb(D_DocdbVO docdbVO) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("getDocdb DAO : " + docdbVO);
		List<?> res = null;
		String rtnStr="";
		try{
			if(docdbVO.getDbname().equals("D_DOCDB1")){
				res = list("detailDAO.getDocdb1",docdbVO);
			}else if(docdbVO.getDbname().equals("D_DOCDB2")){
				res = list("detailDAO.getDocdb2",docdbVO);
			}

		}catch(Exception e){
			System.out.println("----------------------");
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}
		return res;
	}

	public String insertDocdb(D_DocdbVO docdbvo) {
		String rtnStr = "";
		System.out.println("insertDocdb:"+docdbvo);
		try {
			if(docdbvo.getDbname().equals("D_DOCDB1")){
				insert("detailDAO.insertDocdb1", docdbvo);
			}else if(docdbvo.getDbname().equals("D_DOCDB2")){
				insert("detailDAO.insertDocdb2", docdbvo);
			}
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}

	public String insertFileAttach(D_FileattachVO fileattachvo) {
		String rtnStr = "";
		System.out.println("insertFileAttach:"+fileattachvo);
		try {
			insert("detailDAO.insertFileAttach", fileattachvo);
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}


	public String deleteFileAttach(D_FileattachVO fileattachvo) {
		String rtnStr = "";
		System.out.println("deleteFileAttach:"+fileattachvo);
		try {
			insert("detailDAO.deleteFileAttach", fileattachvo);
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}

	
	public String updateDocdb(D_DocdbVO docdbvo) {
		String rtnStr = "";
		System.out.println("updateDocdb:"+docdbvo);
		try {
			if(docdbvo.getDbname().equals("D_DOCDB1")){
				insert("detailDAO.updateDocdb", docdbvo);
			}else if(docdbvo.getDbname().equals("D_DOCDB2")){
				insert("detailDAO.updateDocdb2", docdbvo);
			}
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}

	public String insertHistory(D_HistoryVO historyvo) {
		String rtnStr = "";
		System.out.println("insertHistory:"+historyvo);
		try {
			insert("detailDAO.insertHistory", historyvo);
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}

	public String updateHistory(D_HistoryVO historyvo) {
		String rtnStr = "";
		System.out.println("updateHistory:"+historyvo);
		try {
			update("detailDAO.updateHistory", historyvo);
			rtnStr = "S";
		} catch (Exception e) {
			// TODO: handle exceptiona
			e.printStackTrace();
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return rtnStr;
	}
}
