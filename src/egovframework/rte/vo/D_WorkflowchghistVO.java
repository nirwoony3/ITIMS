package egovframework.rte.vo;

public class D_WorkflowchghistVO {
	private String docno;
	private String created;
	private String wfstate;
	private String wfstateold;
	private String changedesc;
	private String creator;
	private String creatorname;
	private String creatordeptname;
	private String wfscomment;
	public String getDocno() {
		return docno;
	}
	public void setDocno(String docno) {
		this.docno = docno;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getWfstate() {
		return wfstate;
	}
	public void setWfstate(String wfstate) {
		this.wfstate = wfstate;
	}
	public String getWfstateold() {
		return wfstateold;
	}
	public void setWfstateold(String wfstateold) {
		this.wfstateold = wfstateold;
	}
	public String getChangedesc() {
		return changedesc;
	}
	public void setChangedesc(String changedesc) {
		this.changedesc = changedesc;
	}
	public String getCreator() {
		return creator;
	}
	public void setCreator(String creator) {
		this.creator = creator;
	}
	public String getCreatorname() {
		return creatorname;
	}
	public void setCreatorname(String creatorname) {
		this.creatorname = creatorname;
	}
	public String getCreatordeptname() {
		return creatordeptname;
	}
	public void setCreatordeptname(String creatordeptname) {
		this.creatordeptname = creatordeptname;
	}
	public String getWfscomment() {
		return wfscomment;
	}
	public void setWfscomment(String wfscomment) {
		this.wfscomment = wfscomment;
	}
	@Override
	public String toString() {
		return "D_WorkflowchghistVO [docno=" + docno + ", created=" + created
				+ ", wfstate=" + wfstate + ", wfstateold=" + wfstateold
				+ ", changedesc=" + changedesc + ", creator=" + creator
				+ ", creatorname=" + creatorname + ", creatordeptname="
				+ creatordeptname + ", wfscomment=" + wfscomment + "]";
	}
	
	
}
