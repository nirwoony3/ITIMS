package egovframework.rte.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections.map.HashedMap;
import org.apache.ibatis.annotations.Param;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import egovframework.rte.psl.dataaccess.EgovAbstractDAO;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.VaultVo;

@Repository("vaultDAO")
public class VaultDAO extends EgovAbstractDAO {

	@Resource(name = "txManager")
	protected DataSourceTransactionManager txManager;
	public List<VaultVo> getVaultList(VaultVo vaultVo) throws Exception {
		System.out.println("getValueList DAO");
		return (List<VaultVo>) list("vaultDAO.getVaultList", vaultVo);
	}

	public List<D_DocdbVO> viewGrid(String vaultlKey) throws Exception {

		return (List<D_DocdbVO>) list("vaultDAO.viewGrid", vaultlKey);
	}

	public List<VaultVo> columList(HashMap<String, String> map) throws Exception {

		return (List<VaultVo>) list("vaultDAO.columList", map);
	}

	public VaultVo getVaultlInfo(String vaultlNo) throws Exception {
		System.out.println("getVaultlInfo DAO");
		VaultVo res = null;
		String rtnStr = "";
		try{
			res = new VaultVo();
			res.setVaultlNo(vaultlNo);
			System.out.println("vaultlNo:"+vaultlNo);
			res = (VaultVo) select("vaultDAO.getVaultlInfo", res);
			rtnStr="S";
			System.out.println(rtnStr);
		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
		}
		return res;
	}

	public String rootCreate(VaultVo vaultVo) throws Exception {
		System.out.println("rootCreate DAO");
		System.out.println(vaultVo.toString());


		String rtnStr = "";
		try{
			insert("vaultDAO.rootCreate", vaultVo);
			rtnStr="S";
		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}
		return rtnStr;
	}

	public String vaultUpdate(VaultVo vaultVo) throws Exception {
		System.out.println("vaultUpdate DAO");
		System.out.println(vaultVo.toString());


		String rtnStr = "";
		try{
			update("vaultDAO.vaultUpdate", vaultVo);
			rtnStr="S";
		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}
		return rtnStr;
	}

	public String vaultDelete(VaultVo vaultVo) throws Exception {
		System.out.println("vaultDelete DAO");
		System.out.println(vaultVo.toString());


		String rtnStr = "";
		try{
			delete("vaultDAO.vaultDelete", vaultVo);
			rtnStr="S";
		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}
		return rtnStr;
	}

	public Integer rollBack() throws Exception {

		return (Integer) update("vaultDAO.rollBack");
	}

	public String deleteDocdb(String docdbname,List<String>docnolist) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("deleteDocdb DAO");

		Map<String,List<String>> map = new HashedMap();
		map.put("docno", docnolist);
		String rtnStr = "";
		try{
			if(docdbname.equals("D_DOCDB1")){
				delete("detailDAO.deleteDocdb1",map);
			}else if(docdbname.equals("D_DOCDB2")){
				delete("detailDAO.deleteDocdb2",map);
			}
			rtnStr = "S";

		}catch(Exception e){
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}
		return rtnStr;
	}

	public int getCountDocdb1(VaultVo vaultVo) {
		int cnt = (int) selectByPk("vaultDAO.getCountDocdb1", vaultVo);
		return cnt;
	}

	public int getCountDocdb2(VaultVo vaultVo) {
		int cnt = (int) selectByPk("vaultDAO.getCountDocdb2", vaultVo);
		return cnt;
	}

	public String getStoragePath(String storageno) {
		String rtnStr = "";
		try {
			System.out.println("storageno : " + storageno);
			rtnStr = (String) selectByPk("vaultDAO.getStoragePath", storageno);
		} catch (Exception e) {
			System.out.println("----------------------");
			rtnStr=e.getMessage();
			String rtnsstr[] = rtnStr.split(":");
			rtnStr = "E:"+rtnsstr[3];
			System.out.println(rtnStr);
		}

		return rtnStr;
	}
}
