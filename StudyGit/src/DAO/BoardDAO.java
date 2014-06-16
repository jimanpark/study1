package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.InitialContext;
import javax.sql.DataSource;

import Util.DBclose;

import DTO.BoardDTO;
import DTO.CategoryDTO;
import DTO.pageDTO;

public class BoardDAO {
	private static BoardDAO instance = new BoardDAO();
	private BoardDAO(){}//SingleTone
	public static BoardDAO getInstance(){
		return instance;
	}
	
	//DB연결 (CRUD)작업
	//초기화 : {}, static{}
	static DataSource ds;
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	static{//Static 초기화 블럭 - driver로드
		InitialContext ctx;
		try{
			ctx = new InitialContext();
			ds = (DataSource)ctx.lookup("java:comp/env/jdbc/oracle");
			System.out.println("DataSource 생성 성공");
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
	}

	//카테고리 리스트
	public List<CategoryDTO> getCategory(){
		ArrayList<CategoryDTO> clist = new ArrayList<CategoryDTO>();
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("select category, cname from myboard_category");
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				CategoryDTO dto = new CategoryDTO();
				dto.setCategory(rs.getInt("category"));
				dto.setCname(rs.getString("cname"));
				clist.add(dto);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return clist;
	}
	
	//게시물 갯수
	public int getAricleCount(){
		int result = 0;
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("select count(*) as count from myboard");
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				result=rs.getInt("count");
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return result;
	}
	
	//최신 idx값
	public int getMaxIdx(){
		int result = 0;
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("select max(idx) as maxidx from myboard");
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				result=rs.getInt("maxidx");
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return result;
	}
	
	//답글 순서 정렬
	public void updateStep(int refer, int step){
		try {
			conn = ds.getConnection();
			pstmt = conn.prepareStatement("update myboard set "+
			"step=step+1 where refer= ? and step> ?");
			pstmt.setInt(1, refer);
			pstmt.setInt(2, step);
			
			System.out.println("update row: "+pstmt.executeUpdate());
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
	}
	
	//글쓰기
	public void boardWrite(BoardDTO dto){
		try {
			
			int refer=0, maxIdx = 0;
			//게시물 갯수 가져오기
			int checkacti = getAricleCount();
			
			//게시물이 있다면 (2번째 작성글부터)
			//refer = 최대 idx값 +1
			if(checkacti!=0) maxIdx = getMaxIdx();
			if (maxIdx!=0) refer=maxIdx+1;	
			else refer=1;//첫글 refer=1;
				
			//답글인지 새글인지 판별
			if (dto.getRefer()!=0) {//답글 
				updateStep(dto.getRefer(), dto.getStep());
				dto.setStep(dto.getStep()+1);
				dto.setDepth(dto.getDepth()+1);
			}else{ //새글
				dto.setRefer(refer);
				dto.setStep(0);
				dto.setDepth(0);
			}
			
			conn = ds.getConnection();
			String sql = "INSERT INTO MYBOARD"+
					"(IDX, CATEGORY, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, "+
					"FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP)"+
					"VALUES(MYBOARD_SEQ.NEXTVAL,?,?,?,?,?,SYSDATE,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, dto.getCategory());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getPwd());
			pstmt.setString(4, dto.getSubject());
			pstmt.setString(5, dto.getContent());
			pstmt.setString(6, dto.getFileName());
			pstmt.setInt(7, dto.getFileSize());
			pstmt.setString(8, dto.getEmail());
			pstmt.setInt(9, dto.getRefer());
			pstmt.setInt(10, dto.getDepth());
			pstmt.setInt(11, dto.getStep());
			
			System.out.println("insert row : "+pstmt.executeUpdate());
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
	}

	//리스트 게시물 갯수
	public int getBoardListCount(String searchKey, String searchType, int category){
		int result =0;
		try {
			conn = ds.getConnection();
			String sql = "SELECT count(idx) as count from myboard where ";
			if(category!=0) sql+="category = "+category+" AND ";
			sql+=searchType+" like ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+searchKey+"%");
			rs =pstmt.executeQuery();
		    
			if(rs.next()){
				result = rs.getInt("count");
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return result;
	}
	
	//목록
	public List<BoardDTO> getBoardlist(String searchKey, String searchType, pageDTO pageDTO){
		ArrayList<BoardDTO> list = new ArrayList<BoardDTO>();
		try {
			int pageSize = pageDTO.getPageSize();
			int PageNum = pageDTO.getPageNum();
			
			int start = PageNum * pageSize - (pageSize -1); 
			int end = PageNum * pageSize;
			
			conn = ds.getConnection();
			String sql = 
				"SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+
				"FROM(SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+
				"FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE C.category=10 ORDER BY refer DESC , step ASC) WHERE notice='Y' "+
				"UNION ALL "+	
				"SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NVL2(NOTICE,'','') "+ 
				"FROM(SELECT rn, IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+ 
				"FROM(SELECT ROWNUM as rn , IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+ 
				"FROM(SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+ 
				"FROM myboard B join myboard_category C on B.category=C.CATEGORY ";
			if(pageDTO.getCategory()!=0){
				sql+="WHERE C.category="+pageDTO.getCategory();
			}
			sql+=" ORDER BY refer DESC , step ASC ) where ";
			sql+=searchType;
			sql+=" LIKE ?) WHERE rn >= ?)WHERE rn <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, "%"+searchKey+"%");
			pstmt.setInt(2, start);
			pstmt.setInt(3, end);
			
			rs =pstmt.executeQuery();
		    
			while(rs.next()){
				BoardDTO boardDTO = new BoardDTO();
				boardDTO.setIdx(rs.getInt("IDX"));
				boardDTO.setCategory(rs.getInt("CATEGORY"));
				boardDTO.setCname(rs.getString("CNAME"));
				boardDTO.setWriter(rs.getString("WRITER"));
				boardDTO.setPwd(rs.getString("PWD"));
				boardDTO.setSubject(rs.getString("SUBJECT"));
				boardDTO.setContent(rs.getString("CONTENT"));
				boardDTO.setWriteDate(rs.getTimestamp("WRITEDATE"));
				boardDTO.setReadNum(rs.getInt("READNUM"));
				boardDTO.setRecommend(rs.getInt("RECOMMEND"));
				boardDTO.setFileName(rs.getString("FILENAME"));
				boardDTO.setFileSize(rs.getInt("FILESIZE"));
				boardDTO.setEmail(rs.getString("EMAIL"));
				boardDTO.setRefer(rs.getInt("REFER"));
				boardDTO.setStep(rs.getInt("STEP"));
				boardDTO.setDepth(rs.getInt("DEPTH"));
				boardDTO.setNotice(rs.getString("NOTICE"));
				list.add(boardDTO);
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return list;
	}

	//글출력
	public BoardDTO getBoard(int idx){
		BoardDTO boardDTO = new BoardDTO();
		try {
			conn = ds.getConnection();
			String sql = 
					"SELECT IDX, B.CATEGORY AS CATEGORY, C.CNAME AS CNAME , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, NOTICE "+
					"FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE idx=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, idx);
			
			rs =pstmt.executeQuery();
		    
			if(rs.next()){
				boardDTO.setIdx(rs.getInt("IDX"));
				boardDTO.setCategory(rs.getInt("CATEGORY"));
				boardDTO.setCname(rs.getString("CNAME"));
				boardDTO.setWriter(rs.getString("WRITER"));
				boardDTO.setPwd(rs.getString("PWD"));
				boardDTO.setSubject(rs.getString("SUBJECT"));
				boardDTO.setContent(rs.getString("CONTENT"));
				boardDTO.setWriteDate(rs.getTimestamp("WRITEDATE"));
				boardDTO.setReadNum(rs.getInt("READNUM"));
				boardDTO.setRecommend(rs.getInt("RECOMMEND"));
				boardDTO.setFileName(rs.getString("FILENAME"));
				boardDTO.setFileSize(rs.getInt("FILESIZE"));
				boardDTO.setEmail(rs.getString("EMAIL"));
				boardDTO.setRefer(rs.getInt("REFER"));
				boardDTO.setStep(rs.getInt("STEP"));
				boardDTO.setDepth(rs.getInt("DEPTH"));
				boardDTO.setNotice(rs.getString("NOTICE"));
			}
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		}finally{
			DBclose.close(rs);
			DBclose.close(pstmt);
			DBclose.close(conn);
		}
		return boardDTO;
	}
}
