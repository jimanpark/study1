package Util;

public class MyUtils {
	 /**
	  * 한글 및 영문 글자 길이를 잘라서 리턴 
	  * @param String 원본문자열
	  * @param int  리턴할 문자열갯수
	  * @return String
	  */
	 public static String getFixString(String message, double len) {
		 double sublen = 0;
		 StringBuffer sbuf = new StringBuffer();
		 if(message == null)
		 	return "";
		 
		 int j=0;
		 for(j=0;( j<message.length()&&sublen< len );j++){
			 //폰트마다 크기가 달라져서 조절 필요...
			   //Character.getType() 함수는 인자로 받는 character의 속성을 리턴합니다.
			   //영어대문자일 경우 = 1
			   //영어소문자일 경우 = 2
			   //한글일 경우 = 5
			   //숫자일 경우 = 9
			   //기호는 받는 기호에 따라 리턴값이 달라집니다.
			  if(Character.getType(message.charAt(j)) == 5) //한글
				  sublen = sublen+1.70;
			  else if(Character.getType(message.charAt(j)) == 1) //영어대문자
				  sublen = sublen+1.0;
			  else if(Character.getType(message.charAt(j)) == 2) //영어소문자
				  sublen = sublen+1;
			  else if(Character.getType(message.charAt(j)) == 9) //숫자
				  sublen = sublen+0.8;
			  else  sublen = sublen+0.6;     //기타 특수문자,공백
			  
			  sbuf.append(message.charAt(j));
		 }

		 if(message.length()>j) sbuf.append("..");
//		 if(message.length() > len) sbuf.append("..");
		  
		 return sbuf.toString();
	 }

	 public static void main(String [] agrs){
	  //한글 체크방법
	  String str = "dasjfl1ie ^&*으샤으샤 ㅁㄴ";
	  for(int i=0;i<str.length();i++){
	   if(Character.getType(str.charAt(i)) == 5) System.out.print("이건한글이넹 :: ");
	   System.out.println(str.charAt(i));
	  }
	  //문자 길이 자르기
	  String title = "가나다라마바사아자가나다라마바사아자가나다라마바사아자가나다라마1바사아자";
	  String title1 = "The Last of Us Remastered E3 2014 Trailer (PS4) 한글이다";
	  String title2 = "ABCDEFGHIKJHKJHKJHKJHKJHKJHKJHKJHABCDEFGHIKJHKJHKJHKJHKJHKJHKJHKJH";
	  String title3 = "ABCDEFGHIKJHKJHadfakjhadsrmnaerasdasdasdasdasdJHKJHKJHKJHKJHKJHKJH";
	  String title4 = "aheroweiruqnpoveirquewnpoviuqwriqvwehrnqpivweybrqwvurnqweobyvqwervqe";
	  int titleLength = 50;
	  System.out.println("==============================================");
	  System.out.println(MyUtils.getFixString(title, titleLength));
	  System.out.println(MyUtils.getFixString(title1, titleLength));
	  System.out.println(MyUtils.getFixString(title2, titleLength));
	  System.out.println(MyUtils.getFixString(title3, titleLength));
	  System.out.println(MyUtils.getFixString(title4, titleLength));
	 }
}