package egovframework.rte.vo;

public class D_WorkFlowVO {
	
	private String wfname;
	private int wflevel;
	private String wfstate;
	private int wfstateseq;
	private String wfdesc;
	private String wfprockind;
	private String created;
	private String creator;
	private String updated;
	private String updator;
	
	public String getWfname() {
		return wfname;
	}
	public void setWfname(String wfname) {
		this.wfname = wfname;
	}
	public int getWflevel() {
		return wflevel;
	}
	public void setWflevel(int wflevel) {
		this.wflevel = wflevel;
	}
	public String getWfstate() {
		return wfstate;
	}
	public void setWfstate(String wfstate) {
		this.wfstate = wfstate;
	}
	public int getWfstateseq() {
		return wfstateseq;
	}
	public void setWfstateseq(int wfstateseq) {
		this.wfstateseq = wfstateseq;
	}
	public String getWfdesc() {
		return wfdesc;
	}
	public void setWfdesc(String wfdesc) {
		this.wfdesc = wfdesc;
	}
	public String getWfprockind() {
		return wfprockind;
	}
	public void setWfprockind(String wfprockind) {
		this.wfprockind = wfprockind;
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
	public String getUpdated() {
		return updated;
	}
	public void setUpdated(String updated) {
		this.updated = updated;
	}
	public String getUpdator() {
		return updator;
	}
	public void setUpdator(String updator) {
		this.updator = updator;
	}
	@Override
	public String toString() {
		return "WorkFlowVO [wfname=" + wfname + ", wflevel=" + wflevel
				+ ", wfstate=" + wfstate + ", wfstateseq=" + wfstateseq
				+ ", wfdesc=" + wfdesc + ", wfprockind=" + wfprockind
				+ ", created=" + created + ", creator=" + creator
				+ ", updated=" + updated + ", updator=" + updator + "]";
	}
}
