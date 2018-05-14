package egovframework.rte.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.DeleteDAO;
import egovframework.rte.service.DeleteService;

@Service("deleteService")
public class DeleteServiceImpl implements DeleteService {
	@Resource(name="deleteDAO")
	DeleteDAO deleteDAO;
}
