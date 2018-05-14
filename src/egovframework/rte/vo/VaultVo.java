package egovframework.rte.vo;

public class VaultVo {
	
	private String vaultlNo;
	private String vaultlKind;
	private int vaultlLevel = 0;
	private String vaultlName;
	private String vaultlDesc;
	private String docdbName;
	private String subdbName;
	private String creator;
	private String created;
	private String storageNo;
	private int docCount;
	private int setCount;
	private int childCount;
	private int dataCount;
	
	public VaultVo(){}
	
	public int getDataCount() {
		return dataCount;
	}
	public void setDataCount(int dataCount) {
		this.dataCount = dataCount;
	}
	public String getVaultlNo() {
		return vaultlNo;
	}
	public void setVaultlNo(String vaultlNo) {
		this.vaultlNo = vaultlNo;
	}
	public String getVaultlKind() {
		return vaultlKind;
	}
	public void setVaultlKind(String vaultlKind) {
		this.vaultlKind = vaultlKind;
	}
	public int getVaultlLevel() {
		return vaultlLevel;
	}
	public void setVaultlLevel(int vaultlLevel) {
		this.vaultlLevel = vaultlLevel;
	}
	public String getVaultlName() {
		return vaultlName;
	}
	public void setVaultlName(String vaultlName) {
		this.vaultlName = vaultlName;
	}
	public String getVaultlDesc() {
		return vaultlDesc;
	}
	public void setVaultlDesc(String vaultlDesc) {
		this.vaultlDesc = vaultlDesc;
	}
	public String getDocdbName() {
		return docdbName;
	}
	public void setDocdbName(String docdbName) {
		this.docdbName = docdbName;
	}
	public String getSubdbName() {
		return subdbName;
	}
	public void setSubdbName(String subdbName) {
		this.subdbName = subdbName;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getStorageNo() {
		return storageNo;
	}
	public void setStorageNo(String storageNo) {
		this.storageNo = storageNo;
	}
	public int getDocCount() {
		return docCount;
	}
	public void setDocCount(int docCount) {
		this.docCount = docCount;
	}

	public int getSetCount() {
		return setCount;
	}

	public void setSetCount(int setCount) {
		this.setCount = setCount;
	}

	public int getChildCount() {
		return childCount;
	}

	public void setChildCount(int childCount) {
		this.childCount = childCount;
	}

	@Override
	public String toString() {
		return "VaultVo [vaultlNo=" + vaultlNo + ", vaultlKind=" + vaultlKind
				+ ", vaultlLevel=" + vaultlLevel + ", vaultlName=" + vaultlName
				+ ", vaultlDesc=" + vaultlDesc + ", docdbName=" + docdbName
				+ ", subdbName=" + subdbName + ", creator=" + creator
				+ ", created=" + created + ", storageNo=" + storageNo
				+ ", docCount=" + docCount + ", setCount=" + setCount
				+ ", childCount=" + childCount + "]";
	}
	
	
}
