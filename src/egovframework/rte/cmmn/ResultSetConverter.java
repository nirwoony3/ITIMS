package egovframework.rte.cmmn;

//org these json locates in webapplication jar lib
//import org.json.JSONArray;
//import org.json.JSONObject;
//import org.json.JSONException;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import egovframework.rte.vo.D_DocdbVO;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

public class ResultSetConverter {
  public static JSONArray convert(ResultSet rs) throws SQLException, JSONException {
    JSONArray json = new JSONArray();
    List<D_DocdbVO> gridList = new ArrayList<D_DocdbVO>();
    ResultSetMetaData rsmd = rs.getMetaData();
    int numColumns = rsmd.getColumnCount();
    
    //System.out.println("ResultSetConverter numColumns => " + numColumns);

	while(rs.next()) {
	  JSONObject obj = new JSONObject();

	  for(int i=1; i<numColumns+1; i++) {
		String column_name = rsmd.getColumnName(i);
		
		//System.out.println("ResultSetConverter column_name => " + column_name);

		switch( rsmd.getColumnType( i ) ) {
		  case java.sql.Types.ARRAY:
			obj.put(column_name, rs.getArray(column_name));     break; 
		  case java.sql.Types.BIGINT:
			obj.put(column_name, rs.getInt(column_name));       break;
		  case java.sql.Types.BOOLEAN:
			obj.put(column_name, rs.getBoolean(column_name));   break;
		  case java.sql.Types.BLOB:
			obj.put(column_name, rs.getBlob(column_name));      break;
		  case java.sql.Types.DOUBLE:
			obj.put(column_name, rs.getDouble(column_name));    break;
		  case java.sql.Types.FLOAT:
			obj.put(column_name, rs.getFloat(column_name));     break;
		  case java.sql.Types.INTEGER:
			obj.put(column_name, rs.getInt(column_name));       break;
		  case java.sql.Types.NVARCHAR:
			obj.put(column_name, rs.getNString(column_name));   break;
		  case java.sql.Types.VARCHAR:
			obj.put(column_name, rs.getString(column_name));    break;
		  case java.sql.Types.TINYINT:
			obj.put(column_name, rs.getInt(column_name));       break;
		  case java.sql.Types.SMALLINT:
			obj.put(column_name, rs.getInt(column_name));       break;
		  case java.sql.Types.DATE:
			obj.put(column_name, rs.getDate(column_name));      break;
		  case java.sql.Types.TIMESTAMP:
			obj.put(column_name, rs.getTimestamp(column_name)); break;
		  default:
			obj.put(column_name, rs.getObject(column_name));    break;
		} //case end		
	  } //for end
	  
	  json.add(obj);

	  //json.add(obj); //json.put(obj);
	} //while end
    
	return json;
  }
}