package SERVICE;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.BoardDAO;
import DTO.BoardDTO;

/**
 * Servlet implementation class boardContent
 */
@WebServlet("/board/boardContent")
public class boardContent extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public boardContent() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		int idx = 0;
		//idx이 없을 경우 list로 이동
		if(request.getParameter("idx")==null || request.getParameter("idx").trim().equals("")){
			response.sendRedirect("boardList");
			return;
		}
		else idx = Integer.parseInt(request.getParameter("idx"));
		
		int category = 0, pageSize=10, pageNum=1;
		String searchKey="";
		String searchType="subject";
		
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
		
		BoardDAO dao = BoardDAO.getInstance();
		
		BoardDTO dto = dao.getBoard(idx);

		
		//뷰에서 사용하는 속성
		request.setAttribute("searchKey", searchKey);
		request.setAttribute("searchType", searchType);
		request.setAttribute("category", category);
		request.setAttribute("pageSize", pageSize);
		request.setAttribute("pageNum", pageNum);

		request.setAttribute("dto", dto);
		
		RequestDispatcher rd = request.getRequestDispatcher("boardContent.jsp");
		rd.forward(request,response);
	}
}
