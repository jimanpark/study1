package SERVICE;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.BoardDAO;

/**
 * Servlet implementation class aricleWrite
 */
@WebServlet("/board/boardWrite")
public class boardWrite extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public boardWrite() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		
		int category = 0, refer = 0, step = 0, depth = 0, pageNum = 1;

		if (request.getParameter("refer") != null) {
			category = Integer.parseInt(request.getParameter("category"));
			pageNum = Integer.parseInt(request.getParameter("pageNum"));
			refer = Integer.parseInt(request.getParameter("refer"));
			step = Integer.parseInt(request.getParameter("step"));
			depth = Integer.parseInt(request.getParameter("depth"));
		}
		
		request.setAttribute("category", category);
		request.setAttribute("refer", refer);
		request.setAttribute("step", step);
		request.setAttribute("depth", depth);
		request.setAttribute("pageNum", pageNum);
		
		BoardDAO dao = BoardDAO.getInstance();
		
		RequestDispatcher rd= request.getRequestDispatcher("boardWrite.jsp");
		request.setAttribute("categorylist", dao.getCategory());
		rd.forward(request,response);
	}
}
