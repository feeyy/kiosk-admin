<%
'�������� ���ߣ��¾�ȫ QQ��820094076
'2012-08-13

Server.ScriptTimeOut = 90000
'Response.Buffer = False

Dim MM_conn_STRING,mydata
mydata=server.mappath("/app/Database.mdb")
Set MM_conn_STRING = Server.CreateObject("ADODB.Connection")

'sqlite ���ݿ�
'MM_conn_STRING.open "DRIVER={SQLite3 ODBC Driver};Database="&mydata
'access ���ݿ�
MM_conn_STRING.open "driver={microsoft access driver (*.mdb)};dbq="&mydata
'sql ���ݿ�
'MM_conn_STRING.open "DRIVER={SQL Server};SERVER=ServerName;UID=USER;PWD=password;DATABASE=databasename"
'DSN ����Դ
'MM_conn_STRING.open "DSN=MyDSN"

%>
<%  
dim sql_injdata 
'�� | ������ע����ַ� 
SQL_injdata = "and|exec|insert|select|delete|update|count|*|%|chr|master|truncate|char|declare|or"   
SQL_inj = split(SQL_Injdata,"|") 
'��ֹGet����ע�� 
If Request.QueryString<>"" Then 
  For Each SQL_Get In Request.QueryString 
    For SQL_Data=0 To Ubound(SQL_inj) 
      if instr(Request.QueryString(SQL_Get),Sql_Inj(Sql_DATA))>0 Then 
        Response.Write "<script>alert('�Ƿ��ַ�����ע��');history.back(-1)</script>":Response.end 
      end if 
    next 
  Next 
End If 
'��ֹPost����ע�� 
If Request.Form<>"" Then 
  For Each Sql_Post In Request.Form 
    For SQL_Data=0 To Ubound(SQL_inj) 
      if instr(Request.Form(Sql_Post),Sql_Inj(Sql_DATA))>0 Then 
        Response.Write "<script>alert('�Ƿ��ַ�����ע��');history.back(-1)</script>":Response.end 
      end if 
    next 
  next 
end if  
%>

