package egovframework.rte.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.rte.dao.UpdateDAO;
import egovframework.rte.service.UpdateService;

@Service("updateService")
public class UpdateServiceImpl implements UpdateService {
	@Resource(name="updateDAO")
	UpdateDAO updateDAO;
}
