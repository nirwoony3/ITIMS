package egovframework.rte.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.service.UpdateService;
import egovframework.rte.vo.D_ApprprocVO;



@Controller
public class UpdateController {
	@Resource(name="updateService")
	UpdateService updateService;

}
