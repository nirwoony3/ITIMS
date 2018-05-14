package egovframework.rte.vo;

public class D_FileattachVO {
	private String docno;
	private String filename;
	private String status;
	private String filetype;
	private String userfilename;
	private String rdlfilename;
	private String created;
	private String creator;
	private String creatorname;
	private String creatordept;
	private String filedocno;
	private String filedocmemo;
	
	private long filesize;
	private int attcheckincnt;
	
	private String addedvaultname;
	private String addedvaultlname;
	public String getDocno() {
		return docno;
	}
	public void setDocno(String docno) {
		this.docno = docno;
	}
	public String getFilename() {
		return filename;
	}
	public void setFilename(String filename) {
		this.filename = filename;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getFiletype() {
		return filetype;
	}
	public void setFiletype(String filetype) {
		this.filetype = filetype;
	}
	public String getUserfilename() {
		return userfilename;
	}
	public void setUserfilename(String userfilename) {
		this.userfilename = userfilename;
	}
	public String getRdlfilename() {
		return rdlfilename;
	}
	public void setRdlfilename(String rdlfilename) {
		this.rdlfilename = rdlfilename;
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
	public String getCreatorname() {
		return creatorname;
	}
	public void setCreatorname(String creatorname) {
		this.creatorname = creatorname;
	}
	public String getCreatordept() {
		return creatordept;
	}
	public void setCreatordept(String creatordept) {
		this.creatordept = creatordept;
	}
	public String getFiledocno() {
		return filedocno;
	}
	public void setFiledocno(String filedocno) {
		this.filedocno = filedocno;
	}
	public String getFiledocmemo() {
		return filedocmemo;
	}
	public void setFiledocmemo(String filedocmemo) {
		this.filedocmemo = filedocmemo;
	}
	public long getFilesize() {
		return filesize;
	}
	public void setFilesize(long filesize) {
		this.filesize = filesize;
	}
	public int getAttcheckincnt() {
		return attcheckincnt;
	}
	public void setAttcheckincnt(int attcheckincnt) {
		this.attcheckincnt = attcheckincnt;
	}
	public String getAddedvaultname() {
		return addedvaultname;
	}
	public void setAddedvaultname(String addedvaultname) {
		this.addedvaultname = addedvaultname;
	}
	public String getAddedvaultlname() {
		return addedvaultlname;
	}
	public void setAddedvaultlname(String addedvaultlname) {
		this.addedvaultlname = addedvaultlname;
	}
	@Override
	public String toString() {
		return "D_FileattachVO [docno=" + docno + ", filename=" + filename
				+ ", status=" + status + ", filetype=" + filetype
				+ ", userfilename=" + userfilename + ", rdlfilename="
				+ rdlfilename + ", created=" + created + ", creator=" + creator
				+ ", creatorname=" + creatorname + ", creatordept="
				+ creatordept + ", filedocno=" + filedocno + ", filedocmemo="
				+ filedocmemo + ", filesize=" + filesize + ", attcheckincnt="
				+ attcheckincnt + ", addedvaultname=" + addedvaultname
				+ ", addedvaultlname=" + addedvaultlname + "]";
	}
	
	
	
}
