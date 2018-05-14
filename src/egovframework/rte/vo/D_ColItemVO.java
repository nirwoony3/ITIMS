package egovframework.rte.vo;

public class D_ColItemVO {
	private String tabName;
	private String colName;
	private int seqNo;
	private String colItem;
	private String colStyle;
	private String created;
	private String creator;
	
	public String getTabName() {
		return tabName;
	}
	public void setTabName(String tabName) {
		this.tabName = tabName;
	}
	public String getColName() {
		return colName;
	}
	public void setColName(String colName) {
		this.colName = colName;
	}
	public int getSeqNo() {
		return seqNo;
	}
	public void setSeqNo(int seqNo) {
		this.seqNo = seqNo;
	}
	public String getColItem() {
		return colItem;
	}
	public void setColItem(String colItem) {
		this.colItem = colItem;
	}
	public String getColStyle() {
		return colStyle;
	}
	public void setColStyle(String colStyle) {
		this.colStyle = colStyle;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	
	@Override
	public String toString() {
		return "D_ColItemVO [tabName=" + tabName + ", colName=" + colName
				+ ", seqNo=" + seqNo + ", colItem=" + colItem + ", colStyle="
				+ colStyle + ", created=" + created + ", creator=" + creator
				+ "]";
	}
}
