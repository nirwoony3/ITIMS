package egovframework.rte.controller;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;

import egovframework.rte.service.DeleteService;

@Controller
public class DeleteController {
	@Resource(name="deleteService")
	DeleteService deleteService;
}
