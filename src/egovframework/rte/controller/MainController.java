package egovframework.rte.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class MainController {
	
	@RequestMapping(value = "/main.do")
	public String mainForm( ModelMap model) throws Exception {
		return "F_MAIN";
	}
}
