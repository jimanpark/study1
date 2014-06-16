-----------------------------------------------
--TABLE 설계(비인증형 답변(계층형) 게시판)
CREATE TABLE myboard(
idx NUMBER PRIMARY KEY, --글번호(DB:오라클-sequence / MS-sql, Mysql(테이블 종속 자동증가 사용))
category NUMBER(2) DEFAULT 0, --카테고리
writer VARCHAR2(30) NOT NULL, --글쓴이(회원전용: 로그인한 ID, 별칭     비회원용:입력값)
pwd VARCHAR2(20) NOT NULL, --회원전용(x), 비회원전용(O: 수정, 삭제)
subject VARCHAR2(50) NOT NULL, --글제목
content VARCHAR2(100) NOT NULL, --글내용
writedate DATE DEFAULT SYSDATE, --작성일
readnum NUMBER DEFAULT 0, --글조회(insert default 0)
recommend NUMBER DEFAULT 0, --추천
filename VARCHAR2(200), --파일명(text.txt)
filesize NUMBER,			--파일크기(byte)
email VARCHAR2(100), --필수입력 사항x (not mull) null값을 허용
--답변형 게시판 구축
refer NUMBER DEFAULT 0, --답변형 게시판 (참조글 or 글의 그룹 번호)
depth NUMBER DEFAULT 0, --답변형 게시판 (depth(깊이), 들여쓰기)
step NUMBER DEFAULT 0, --답변형 게시판 (글의 정렬 순서)
CONSTRAINT category_fk FOREIGN KEY(category) REFERENCES myboard_category(category)
) SEGMENT CREATION IMMEDIATE;

--공지데이터 컬럼 추가
ALTER TABLE myboard ADD notice CHAR(1)

--제목데이터량 증가
ALTER TABLE myboard MODIFY subject VARCHAR2(100)
--본문데이터량 증가
ALTER TABLE myboard MODIFY content VARCHAR2(4000)

--카테고리
CREATE TABLE myboard_category(
category NUMBER(2) PRIMARY key,
cname VARCHAR2(10)
)

--순번 처리(oracle)
CREATE SEQUENCE myboard_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

--덧글(꼬리말)을 위한 테이블 생성
CREATE TABLE myboard_re(
no NUMBER PRIMARY KEY,
writer VARCHAR2(30),
userid VARCHAR2(30),
pwd VARCHAR2(30),
content VARCHAR2(100),
writedate DATE DEFAULT SYSDATE,
idx_fk REFERENCES myboard(idx)
);



--------------------------------------------------------------------------
--11g release2 발생  문제 >  SEQUENCE 실테이블 사용시 초기값이 하나 증가된 값으로
/*
 힙 테이블은 우리가 보통 그냥 만드는 테이블이라고 생각하시면 됩니다 -
 11g R2 버전부터 테이블이 생성될 때 세그먼트가 바로 할당되지 않고 데이터가
 최초로 삽입(INSERT)될 때 세그먼트가 할당됩니다.
 이것을 Deferred Segment Creation 이라고 합니다.
*/

CREATE SEQUENCE newseq;

CREATE TABLE KN_AUTHORITY (
  seq         VARCHAR2(20) NOT NULL,
  autho_name  VARCHAR2(20) NOT NULL
) SEGMENT CREATION IMMEDIATE;

INSERT INTO KN_AUTHORITY(seq, autho_name)
VALUES(NEWSEQ.NEXTVAL , 'aaa');
SELECT *FROM KN_AUTHORITY

--sequence END----------------------------------------------------------

--myboard_category 데이터
INSERT INTO myboard_category VALUES(10,'공지사항');
INSERT INTO myboard_category VALUES(1,'일반게시판');
INSERT INTO myboard_category VALUES(2,'회원게시판');
INSERT INTO myboard_category VALUES(3,'사진게시판');

UPDATE myboard_category SET category=1,cname='일반게시판' WHERE CATEGORY=0

DELETE myboard_category

SELECT * FROM myboard_category;
select category, cname from myboard_category;

DESC MYBOARD

SELECT * FROM MYBOARD;

IDX, CATEGORY, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP

INSERT INTO MYBOARD
(IDX, CATEGORY, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP)
VALUES(MYBOARD_SEQ.NEXTVAL,1,'writer','1234','subject','content.....12121313',SYSDATE,0,0,'filename',1024,'email',0,0,0);

DELETE MYBOARD;

select count(*) as count from myboard
select max(idx) as maxidx from myboard
COMMIT



SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP FROM
(SELECT rn, IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP FROM
(SELECT ROWNUM as rn , IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP FROM myboard B join myboard_category C on B.category=C.category ORDER  BY refer DESC , step ASC) WHERE rn>=1 ) WHERE rn <= 15 AND writer LIKE '%%' AND CATEGORY LIKE '%%'

commit
SELECT count(idx) from myboard where writer like '%wri%'


SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT rn, IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT ROWNUM as rn , IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE C.category=1 ORDER BY refer DESC , step ASC ) where writer LIKE '%%') WHERE rn >= 1)WHERE rn <= 10

SELECT * FROM myboard WHERE writer='운영자'

UPDATE myboard SET notice='Y' WHERE writer='운영자'

COMMIT

SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP ,notice
FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE C.category=10 ORDER BY refer DESC , step ASC) WHERE notice='Y'
UNION ALL
SELECT IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT rn, IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT ROWNUM as rn , IDX, CATEGORY, cname, WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM(SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP
FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE C.category=1 ORDER BY refer DESC , step ASC ) where writer LIKE '%%') WHERE rn >= 1)WHERE rn <= 10



SELECT IDX, B.CATEGORY AS CATEGORY, C.cname AS cname , WRITER, PWD, SUBJECT, CONTENT, WRITEDATE, READNUM, RECOMMEND, FILENAME, FILESIZE, EMAIL, REFER, DEPTH, STEP, notice
FROM myboard B join myboard_category C on B.category=C.CATEGORY WHERE idx=20
