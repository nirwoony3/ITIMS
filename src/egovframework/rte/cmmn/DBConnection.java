package egovframework.rte.cmmn;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBConnection {

	public Connection getConnection() throws Exception {
		System.out.println("DBConnection Working");
//		#.1 Load
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
//		#.2 Connection
		String url = "jdbc:oracle:thin:@121.126.112.37:1521:orcl";
		String user = "pwmadmin";
		String password = "pwmmgr";
		Connection conn = 
			DriverManager.getConnection(url, user, password);
		
		return conn;
	}
	
	public void freeConnection(Connection con, PreparedStatement pstmt, ResultSet rs) {
		try {
			if (rs != null) rs.close();
			if (pstmt != null) pstmt.close();
			freeConnection(con);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	 
	public void freeConnection(Connection con, Statement stmt, ResultSet rs) {
		try {
			if (rs != null) rs.close();
			if (stmt != null) stmt.close();
			freeConnection(con);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void freeConnection(Connection con, PreparedStatement pstmt) {
		try {
			if (pstmt != null) pstmt.close();
			freeConnection(con);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	} 
	
	public void freeConnection(Connection con, Statement stmt) {
		try {
			if (stmt != null) stmt.close();
			freeConnection(con);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void freeConnection(Connection con) {
		try {
			if (con != null) con.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void freeConnection(Statement stmt) {
		try {
			if (stmt != null) stmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	 
	
	public void freeConnection(PreparedStatement pstmt) {
		try {
			if (pstmt != null) pstmt.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	 
	public void freeConnection(ResultSet rs) {
		try {
			if (rs != null) rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	} 
}














