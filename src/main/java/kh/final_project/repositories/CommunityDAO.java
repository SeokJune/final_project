package kh.final_project.repositories;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kh.final_project.dto.BoardsDTO;
import kh.final_project.dto.BoardsReplyDTO;
import kh.final_project.dto.CategoryType;
import kh.final_project.dto.ComplaintBoardsDTO;

@Repository
public class CommunityDAO {
	@Autowired
	private SqlSessionTemplate sst;

	public List<CategoryType> getSelectTag() {
		return sst.selectList("Community.getBoardType");
	}

	public int insertBoard(BoardsDTO boardsDTO) {
		return sst.insert("Community.insertBoard", boardsDTO);
	}

	public int insertComplaint(ComplaintBoardsDTO complaintBoardsDTO) {
		return sst.insert("Community.insertComplaint", complaintBoardsDTO);
	}

	public List<BoardsDTO> selectBoard(CategoryType categoryType) {
		return sst.selectList("Community.selectBoard", categoryType);
	}

	public BoardsDTO selectBoardView(BoardsDTO boardsDTO) {
		sst.update("Community.viewUp", boardsDTO);
		return sst.selectOne("Community.selectBoardView", boardsDTO);
	}

	public ComplaintBoardsDTO selectComplaintView(ComplaintBoardsDTO complaintBoardsDTO) {
		sst.update("Community.viewUp", complaintBoardsDTO);
		return sst.selectOne("Community.selectComplaintView", complaintBoardsDTO);
	}

	public int updateBoard(BoardsDTO boardsDTO) {
		return sst.update("Community.updateBoard", boardsDTO);
	}

	public int deleteBoard(BoardsDTO boardsDTO) {
		return sst.delete("Community.deleteBoard", boardsDTO);
	}

	public int insertReply(BoardsReplyDTO boardsReplyDTO) {
		return sst.insert("Community.insertReply", boardsReplyDTO);
	}

	public List<BoardsReplyDTO> selectReply(BoardsReplyDTO boardsReplyDTO) {
		return sst.selectList("Community.selectReply", boardsReplyDTO);
	}

	public List<BoardsReplyDTO> selectReReply(BoardsReplyDTO boardsReplyDTO) {
		return sst.selectList("Community.selectReReply", boardsReplyDTO);
	}

	public int deleteReply(BoardsReplyDTO boardsReplyDTO) {
		return sst.delete("Community.deleteReply", boardsReplyDTO);
	}

	public int updateReply(BoardsReplyDTO boardsReplyDTO) {
		return sst.update("Community.updateReply", boardsReplyDTO);
	}

	public int getMax(String board_name) {
		return sst.selectOne("Community.getMax", board_name);
	}

	public List<BoardsDTO> selectBoardByPage(Map<String, Object> pageInfo) {
		return sst.selectList("Community.selectBoardByPage", pageInfo);
	}

	public List<ComplaintBoardsDTO> selectComplaintByPage(Map<String, Object> pageInfo) {
		return sst.selectList("Community.selectComplaintByPage", pageInfo);
	}

	public List<CategoryType> selectBoardType() {
		return sst.selectList("Community.selectBoardType");
	}

	public List<BoardsDTO> selectAllComplaints() {
		return sst.selectList("Community.selectAllComplaints");
	}

	public int insertProcess(ComplaintBoardsDTO complaintBoardsDTO) {
		return sst.update("Community.insertProcess", complaintBoardsDTO);
	}
}
