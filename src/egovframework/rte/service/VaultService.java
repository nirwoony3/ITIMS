package egovframework.rte.service;

import java.util.List;

import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.VaultVo;

public interface VaultService {

	List<VaultVo> viewVaultNo(VaultVo vaultVo) throws Exception;
	List<VaultVo> getDirectory(VaultVo vaultVo) throws Exception;
	List<D_DocdbVO> viewGrid(String vaultlKey) throws Exception;
	List<VaultVo> columList(VaultVo vaultVo) throws Exception;
	VaultVo getVaultlInfo(String vaultlNo) throws Exception;
	String rootCreate(VaultVo vaultVo) throws Exception;
	String vaultCreate(VaultVo vaultVo) throws Exception;
	String vaultUpdate(VaultVo vaultVo) throws Exception;
	String vaultDelete(VaultVo vaultVo) throws Exception;
	Integer rollBack() throws Exception;
	
	String deleteDocdb(String docdbname,List<String>docnolist) throws Exception;
	int getCountDocdb1(VaultVo vaultVo) throws Exception;
	int getCountDocdb2(VaultVo vaultVo) throws Exception;
	String getStoragePath(String storageno)throws Exception;
}
