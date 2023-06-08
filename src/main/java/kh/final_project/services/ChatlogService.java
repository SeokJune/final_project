package kh.final_project.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kh.final_project.dto.ChatlogDTO;
import kh.final_project.repositories.ChatlogDAO;

@Service
public class ChatlogService {
	
	@Autowired
	private ChatlogDAO dao;
	
	public ChatlogDTO selectLog(Long seq) {
		return dao.selectLog(seq);
	}
	
	public int insertLog(ChatlogDTO dto,Integer loginID) {
		if(dto.getWriter() != loginID) {
			return -1;
		}
		return dao.insertLog(dto);
	}
	
}
