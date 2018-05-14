package egovframework.rte.cmmn;

import java.io.File;

import egovframework.rte.vo.VaultVo;

public class FileCon {

	public boolean createFolder (VaultVo vaultVo){

		boolean flag = false;
		String path = "C:/TimsStr/"+vaultVo.getStorageNo()+"/";

		// 형식 지정
		String folderName = vaultVo.getVaultlNo();
		String[] splitArr = folderName.split("-", 10);

		File dir = new File(path, splitArr[0]);

		System.out.println("path : "+path);
		System.out.println("FolderName : "+splitArr[0]);

		// 폴더가 없으면 생성     
		if(!dir.exists()){
			System.out.println("디렉토리 생성 성공");
			flag = dir.mkdir();
		} else {

			System.out.println("디렉토리 생성 실패");
		}

		return flag;
	}

	public boolean deleteFolder(VaultVo vaultVo) {

		  boolean flag = false;
		  String fullPath = null;
		  String path = "C:/TimsStr/"+vaultVo.getStorageNo()+"/";
		
	      // 형식 지정
	      
		  String[] splitArr = vaultVo.getVaultlNo().split("-", 10);
	      String addPath = splitArr[0];
	      
	      System.out.println("레벨 : "+vaultVo.getVaultlLevel());		      
	      for(int i=1; i<vaultVo.getVaultlLevel(); i++){
	    	  
	    	  addPath += "/"+splitArr[i];
	      }
	      fullPath = path + addPath;
		  File dir = new File(fullPath, splitArr[vaultVo.getVaultlLevel()]);

		  System.out.println("path : "+path);
		  System.out.println("addPath : "+addPath);
		  System.out.println("folderFullName : "+vaultVo.getVaultlNo());
	      
		  // 폴더가 없으면 생성     
	      if(dir.exists()){
	    	 System.out.println("디렉토리 삭제 성공");
	    	 dir.delete();
	      } else {
	    	  
	    	 System.out.println("디렉토리 삭제 실패");
	      }
		
		return flag;
	}

	public String moveFolder() {
		
        String folderName = "";//폴더 생성할 이름
        String fileName = ""; //바뀔 이름
        String beforeFilePath = ""; //옮길 대상 경로
        String afterFilePath = ""; //옮겨질 경로
        
        String path = afterFilePath+"/"+folderName;
        String filePath = path+"/"+fileName;
 
        File dir = new File(path);
 
        if (!dir.exists()) { //폴더 없으면 폴더 생성
            dir.mkdirs();
        }
 
        try{
 
            File file =new File(beforeFilePath);
 
            if(file.renameTo(new File(filePath))){ //파일 이동
                
            	return filePath; //성공시 성공 파일 경로 return
            }else{
                
            	return null;
            }
 
        }catch(Exception e){
            e.printStackTrace();
            return null;
        }
	}

}
