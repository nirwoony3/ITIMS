package egovframework.rte.vo;

public class D_UserVO {
	
	private String userno;
	private String username;
	private String userposition;
	private String userdeptname;
	private String userjuminno;
	private String userpassword;
	private String email;
	private String usetype;
	private String ip;
	private String phone;
	private String projectname;
	private String created;
	private String updated;
	public String getUserno() {
		return userno;
	}
	public void setUserno(String userno) {
		this.userno = userno;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getUserposition() {
		return userposition;
	}
	public void setUserposition(String userposition) {
		this.userposition = userposition;
	}
	public String getUserdeptname() {
		return userdeptname;
	}
	public void setUserdeptname(String userdeptname) {
		this.userdeptname = userdeptname;
	}
	public String getUserjuminno() {
		return userjuminno;
	}
	public void setUserjuminno(String userjuminno) {
		this.userjuminno = userjuminno;
	}
	public String getUserpassword() {
		return userpassword;
	}
	public void setUserpassword(String userpassword) {
		this.userpassword = userpassword;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUsetype() {
		return usetype;
	}
	public void setUsetype(String usetype) {
		this.usetype = usetype;
	}
	public String getIp() {
		return ip;
	}
	public void setIp(String ip) {
		this.ip = ip;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getProjectname() {
		return projectname;
	}
	public void setProjectname(String projectname) {
		this.projectname = projectname;
	}
	public String getCreated() {
		return created;
	}
	public void setCreated(String created) {
		this.created = created;
	}
	public String getUpdated() {
		return updated;
	}
	public void setUpdated(String updated) {
		this.updated = updated;
	}
	
	@Override
	public String toString() {
		return "D_UserVO [userno=" + userno + ", username=" + username
				+ ", userposition=" + userposition + ", userdeptname="
				+ userdeptname + ", userjuminno=" + userjuminno
				+ ", userpassword=" + userpassword + ", email=" + email
				+ ", usetype=" + usetype + ", ip=" + ip + ", phone=" + phone
				+ ", projectname=" + projectname + ", created=" + created
				+ ", updated=" + updated + "]";
	}
}
