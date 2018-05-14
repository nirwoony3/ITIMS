package egovframework.rte.service.impl;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.VaultDAO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.service.VaultService;
import egovframework.rte.vo.D_DocdbVO;
import egovframework.rte.vo.VaultVo;

@Service("vaultService")
public class VaultServiceImpl extends EgovAbstractServiceImpl implements VaultService {

	@Resource(name = "vaultDAO")
	private VaultDAO vaultDAO;

	@Override
	public List<VaultVo> viewVaultNo(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub

		switch(Integer.parseInt(vaultVo.getVaultlNo())){
		case 0 : vaultVo.setVaultlNo("A"); break;
		case 1 : vaultVo.setVaultlNo("S"); break;
		case 2 : vaultVo.setVaultlNo("V"); break;
		case 3 : vaultVo.setVaultlNo("Q"); break;
		}

		return (List<VaultVo>) vaultDAO.getVaultList(vaultVo);
	}

	@Override
	public List<VaultVo> getDirectory(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub

		//vaultlNo 첫 A000* 만 가져오기
		String[] splitArr = vaultVo.getVaultlNo().split("-", 10);
		vaultVo.setVaultlNo(splitArr[0]);
		System.out.println("스플릿 넘버 : "+vaultVo.getVaultlNo());

		return vaultDAO.getVaultList(vaultVo);
	}

	@Override
	public List<D_DocdbVO> viewGrid(String vaultlKey) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.viewGrid(vaultlKey);
	}

	@Override
	public List<VaultVo> columList(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub
		HashMap<String, String> map = new HashMap<String, String>();
		String keyWord = null;

		if(vaultVo.getDocdbName() != null && vaultVo.getDocdbName().equals("DOC")){

			keyWord = "DOCDBNAME";
			//vaultVo.setDocdbName("DOCDBNAME");
		} else if(vaultVo.getSubdbName() != null && vaultVo.getSubdbName().equals("SUB")){

			keyWord = "SUBDBNAME";
			//vaultVo.setSubdbName("SUBDBNAME");
		} else if(vaultVo.getStorageNo() != null && vaultVo.getStorageNo().equals("STR")){

			keyWord = "STORAGENO";
			//vaultVo.setStorageNo("STORAGENO");
		}

		map.put("keyWord", keyWord);
		map.put("vaultlNo", vaultVo.getVaultlNo());
		
		return vaultDAO.columList(map);
	}

	@Override
	public VaultVo getVaultlInfo(String vaultlNo) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.getVaultlInfo(vaultlNo);
	}

	@Override
	public String rootCreate(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub
		String createNo = null;
		String lowNo = "-0000-0000-0000-0000-0000-0000-0000-0000-0000";
		String tempString = null;

		System.out.println("createNo : "+createNo);
		switch(Integer.parseInt(vaultVo.getVaultlNo())){
		case 0 : vaultVo.setVaultlNo("A"); vaultVo.setVaultlKind("ANNOUNCE"); break;
		case 1 : vaultVo.setVaultlNo("S"); vaultVo.setVaultlKind("SUMMURY"); break;
		case 2 : vaultVo.setVaultlNo("V"); vaultVo.setVaultlKind("VAULT"); break;
		case 3 : vaultVo.setVaultlNo("Q"); vaultVo.setVaultlKind("QUERY"); break;
		default :  vaultVo.setVaultlNo("A000*-0000-0000-0000-0000-0000-0000-0000-0000-0000"); break;

		}

		createNo = vaultVo.getVaultlNo();
		System.out.println("createNo : "+createNo);
		int nextFolder = vaultDAO.getVaultList(vaultVo).size() + 1;
		System.out.println("nextFolder : "+nextFolder);

		if(nextFolder < 10) {

			tempString = "000" + nextFolder + lowNo;
		} else if (nextFolder >= 10) {

			tempString = "00" +nextFolder + lowNo;
		} else if (nextFolder >= 100) {

			tempString = "0" + nextFolder + lowNo;
		} else if (nextFolder >= 1000) {

			tempString = nextFolder + lowNo;
		} else {

			tempString = "";
		}

		vaultVo.setVaultlNo(createNo + tempString);
		System.out.println("VaultlNo :" +vaultVo.getVaultlNo());
		return vaultDAO.rootCreate(vaultVo);
	}

	@Override
	public String vaultCreate(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub

		switch(Integer.parseInt(vaultVo.getVaultlKind())){
		case 0 : vaultVo.setVaultlKind("ANNOUNCE"); break;
		case 1 : vaultVo.setVaultlKind("SUMMURY"); break;
		case 2 : vaultVo.setVaultlKind("VAULT"); break;
		case 3 : vaultVo.setVaultlKind("QUERY"); break;
		}

		String[] splitArr = vaultVo.getVaultlNo().split("-", 10);
		int nextLevel = vaultVo.getVaultlLevel()+1; // 선택한 폴더에 다음레벨에 생성하기 때문에 +1을 해준다.
		vaultVo.setVaultlLevel(nextLevel);
		vaultVo.setVaultlNo(splitArr[0]);
		System.out.println("레벨 임플 : "+vaultVo.getVaultlLevel());
		System.out.println("넘버 임플 : "+vaultVo.getVaultlNo());

		int nextFolder = vaultDAO.getVaultList(vaultVo).size()+1;
		System.out.println("nextFolder : "+nextFolder);

		splitArr[nextLevel] = "000"+nextFolder;

		String no = splitArr[0];

		for (int i=1; i<splitArr.length; i++) {

			no += "-" + splitArr[i];
		}

		vaultVo.setVaultlNo(no);
		return vaultDAO.rootCreate(vaultVo);
	}

	@Override
	public String vaultUpdate(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.vaultUpdate(vaultVo);
	}

	@Override
	public String vaultDelete(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub

		//vaultlNo 첫 A000* 만 가져오기
		int level = vaultVo.getVaultlLevel();
		System.out.println("스플릿 레벨 : "+vaultVo.getVaultlLevel());
		String[] splitArr = vaultVo.getVaultlNo().split("-", 10);

		String vaultlNo = splitArr[0];

		for(int i=1; i<=level; i++) {

			vaultlNo += "-" + splitArr[i];
		}

		vaultVo.setVaultlNo(vaultlNo);
		System.out.println("스플릿 넘버 : "+vaultVo.getVaultlNo());

		return vaultDAO.vaultDelete(vaultVo);
	}

	@Override
	public Integer rollBack() throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.rollBack();
	}

	public String[] vaultlNoSplitter(VaultVo vaultVo) throws Exception {

		String[] splitArr = vaultVo.getVaultlNo().split("-", 10);

		return splitArr;
	}

	@Override
	public String deleteDocdb(String docdbname,List<String>docnolist) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.deleteDocdb(docdbname,docnolist);
	}

	@Override
	public int getCountDocdb1(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.getCountDocdb1(vaultVo);
	}
	
	@Override
	public int getCountDocdb2(VaultVo vaultVo) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.getCountDocdb2(vaultVo);
	}

	@Override
	public String getStoragePath(String storageno) throws Exception {
		// TODO Auto-generated method stub
		return vaultDAO.getStoragePath(storageno);
	}
}
