package SERVICE;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import DAO.BoardDAO;
import DTO.BoardDTO;

/**
 * Servlet implementation class aricleWriteOK
 */
@WebServlet("/board/boardWriteOK")
public class boardWriteOK extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public boardWriteOK() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#service(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		int refer = 0, step = 0, depth = 0;
		//원본글의 정보가 넘어올경우
		if (request.getParameter("refer") != "") {
			refer = Integer.parseInt(request.getParameter("refer"));
			step = Integer.parseInt(request.getParameter("step"));
			depth = Integer.parseInt(request.getParameter("depth"));
		}

		BoardDTO dto = new BoardDTO();
		dto.setCategory(Integer.parseInt(request.getParameter("category")));
		dto.setWriter(request.getParameter("writer"));
		dto.setPwd(request.getParameter("pwd"));
		dto.setSubject(request.getParameter("subject"));
		dto.setContent(request.getParameter("content"));
		//dto.setFileName(request.getParameter("filename"));
		//dto.setFileSize(request.getParameter("filesize"));
		dto.setEmail(request.getParameter("email"));
		dto.setRefer(refer);
		dto.setStep(step);
		dto.setDepth(depth);
		
		BoardDAO dao = BoardDAO.getInstance();
		
		dao.boardWrite(dto);
		
		/*Enumeration e = request.getParameterNames();
		while(e.hasMoreElements()){
			String name = (String)e.nextElement();
			System.out.print(name+" : ");
			System.out.println(request.getParameter(name));			
		}
		System.out.println();
		System.out.println("refer : "+refer);
		System.out.println("step : "+step);
		System.out.println("depth : "+depth);
		System.out.println();*/
		response.sendRedirect("boardList");
	}
}
