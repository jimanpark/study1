-----------------------------------------------
--TABLE ����(�������� �亯(������) �Խ���)
CREATE TABLE myboard(
idx NUMBER PRIMARY KEY, --�۹�ȣ(DB:����Ŭ-sequence / MS-sql, Mysql(���̺� ���� �ڵ����� ���))
category NUMBER(2) DEFAULT 0, --ī�װ�
writer VARCHAR2(30) NOT NULL, --�۾���(ȸ������: �α����� ID, ��Ī     ��ȸ����:�Է°�)
pwd VARCHAR2(20) NOT NULL, --ȸ������(x), ��ȸ������(O: ����, ����)
subject VARCHAR2(50) NOT NULL, --������
content VARCHAR2(100) NOT NULL, --�۳���
writedate DATE DEFAULT SYSDATE, --�ۼ���
readnum NUMBER DEFAULT 0, --����ȸ(insert default 0)
recommend NUMBER DEFAULT 0, --��õ
filename VARCHAR2(200), --���ϸ�(text.txt)
filesize NUMBER,			--����ũ��(byte)
email VARCHAR2(100), --�ʼ��Է� ����x (not mull) null���� ���
--�亯�� �Խ��� ����
refer NUMBER DEFAULT 0, --�亯�� �Խ��� (������ or ���� �׷� ��ȣ)
depth NUMBER DEFAULT 0, --�亯�� �Խ��� (depth(����), �鿩����)
step NUMBER DEFAULT 0, --�亯�� �Խ��� (���� ���� ����)
CONSTRAINT category_fk FOREIGN KEY(category) REFERENCES myboard_category(category)
) SEGMENT CREATION IMMEDIATE;

--���������� �÷� �߰�
ALTER TABLE myboard ADD notice CHAR(1)

--�������ͷ� ����
ALTER TABLE myboard MODIFY subject VARCHAR2(100)
--���������ͷ� ����
ALTER TABLE myboard MODIFY content VARCHAR2(4000)

--ī�װ�
CREATE TABLE myboard_category(
category NUMBER(2) PRIMARY key,
cname VARCHAR2(10)
)

--���� ó��(oracle)
CREATE SEQUENCE myboard_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

--����(������)�� ���� ���̺� ����
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
--11g release2 �߻�  ���� >  SEQUENCE �����̺� ���� �ʱⰪ�� �ϳ� ������ ������
/*
 �� ���̺��� �츮�� ���� �׳� ����� ���̺��̶�� �����Ͻø� �˴ϴ� -
 11g R2 �������� ���̺��� ������ �� ���׸�Ʈ�� �ٷ� �Ҵ���� �ʰ� �����Ͱ�
 ���ʷ� ����(INSERT)�� �� ���׸�Ʈ�� �Ҵ�˴ϴ�.
 �̰��� Deferred Segment Creation �̶�� �մϴ�.
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

--myboard_category ������
INSERT INTO myboard_category VALUES(10,'��������');
INSERT INTO myboard_category VALUES(1,'�ϹݰԽ���');
INSERT INTO myboard_category VALUES(2,'ȸ���Խ���');
INSERT INTO myboard_category VALUES(3,'�����Խ���');

UPDATE myboard_category SET category=1,cname='�ϹݰԽ���' WHERE CATEGORY=0

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

SELECT * FROM myboard WHERE writer='���'

UPDATE myboard SET notice='Y' WHERE writer='���'

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
