package SERVICE;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Util.DateUtil;
import Util.MyUtils;

import DAO.BoardDAO;
import DTO.BoardDTO;
import DTO.pageDTO;

/**
 * Servlet implementation class boardList
 */
@WebServlet("/board/boardList")
public class boardList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public boardList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		
		//목록 초기값
		int category = 0, pageSize=10, pageNum=1;
		String searchKey="";
		String searchType="subject";


		//page & 검색어 데이터 받을시
		if (request.getParameter("searchKey") != null) {
			if(!request.getParameter("searchKey").trim().equals("")){
				searchKey = request.getParameter("searchKey");
			}
		}
		if (request.getParameter("searchType") != null) {
			if(!request.getParameter("searchType").trim().equals("")){
				searchType = request.getParameter("searchType");
			}
		}
		if(request.getParameter("category") != null) {
			if(!request.getParameter("category").trim().equals("")){
				category = Integer.parseInt(request.getParameter("category"));
			}
		}
		if(request.getParameter("pageSize") != null) {
			if(!request.getParameter("pageSize").trim().equals("")){
				pageSize = Integer.parseInt(request.getParameter("pageSize"));
			}
		}
		if(request.getParameter("pageNum") != null) {
			if(!request.getParameter("pageNum").trim().equals("")){
				pageNum = Integer.parseInt(request.getParameter("pageNum"));
			}
		}
		
		request.setAttribute("searchKey", searchKey);
		request.setAttribute("searchType", searchType);
		request.setAttribute("category", category);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("pageNum", pageNum);
		
		BoardDAO dao = BoardDAO.getInstance();
		
	    //전체 게시물 건수 추후  boardlist.totalboardCount() 로 구현
	    int BoardListCount = dao.getBoardListCount(searchKey, searchType, category);
		request.setAttribute("searchCount", BoardListCount);

		
		//페이징 처리
		int visiblePageNum = 10;
		int pagecount = 0;
		int beginPage=0;
		int endPage=0;
	    if(BoardListCount!=0){//게시물이 없는 경우
	    	pagecount = BoardListCount/pageSize;//115건 = 11page
		    if(BoardListCount % pageSize >0){//115건 = 나머지 5 true
		    	pagecount++;//11page++ = 12page
		    }
		    beginPage=(pageNum-1)/visiblePageNum*visiblePageNum+1;//10단위 계산
		    endPage=beginPage+(visiblePageNum-1);
		    if(endPage>pagecount){
		    	endPage=pagecount;
		    }
	    }
	    request.setAttribute("pagecount", pagecount);
	    request.setAttribute("beginpage", beginPage);
	    request.setAttribute("endpage", endPage);
	    
	    //category
	  	request.setAttribute("categorylist", dao.getCategory());
	  		
	    //list
		pageDTO pageDTO = new pageDTO();
		
		pageDTO.setCategory(category);
		pageDTO.setPageNum(pageNum);
		pageDTO.setPageSize(pageSize);
		
		List<BoardDTO> boardList = dao.getBoardlist(searchKey, searchType, pageDTO);
		

		//최신글 
		//7자 초과 글쓴이 
		//15자 이상 제목 처리
		Date now = new Date();//현제 시간
		int n = 24;			//n시간전으로 설정
		now.setTime(now.getTime()-1000*60*60*n);
		for(BoardDTO DTO : boardList){
			String cname = DTO.getCname();
			if(cname != null && cname.length()>2){
				cname = cname.substring(0,2);
			}
			DTO.setCname(cname);
			
			String subject = DTO.getSubject();
			//제목 영문 기준 50자 길이로 처리
			subject = MyUtils.getFixString(subject, 50);

			Timestamp writeDate = DTO.getWriteDate();
			
			if(writeDate.getTime()>now.getTime()){
				subject+="&nbsp;<img alt='new' src='../images/new.gif'>";
				DTO.setWriteDate_String(DateUtil.formatDateTimeToString(DTO.getWriteDate(),"HH:mm:ss"));
			}else{
				DTO.setWriteDate_String(DateUtil.formatDateTimeToString(DTO.getWriteDate(),"yyyy.MM.dd"));
			}
			
			String writer = DTO.getWriter();
			if(writer != null && writer.length()>7){
				writer = writer.substring(0,7) + "..";
			}
			DTO.setSubject(subject);
			DTO.setWriter(writer);
		}
		
		request.setAttribute("boardlist", boardList);
		
		RequestDispatcher rd= request.getRequestDispatcher("boardList.jsp");
		rd.forward(request,response);
	}
}
