package egovframework.rte.dao;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.vo.D_ApprprocVO;

@Repository("insertDAO")
public class InsertDAO extends EgovAbstractDAO {

	public String insertApprproc(D_ApprprocVO approcvo) {
		String rtnStr = "";
		System.out.println("insertApprproc:"+approcvo);
		try {
			insert("insertDAO.insertApprproc", approcvo);
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
