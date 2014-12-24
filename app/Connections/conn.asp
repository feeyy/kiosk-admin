<%
'基础数据 作者：陈劲全 QQ：820094076
'2012-08-13

Server.ScriptTimeOut = 90000
'Response.Buffer = False

Dim MM_conn_STRING,mydata
mydata=server.mappath("/app/Database.mdb")
Set MM_conn_STRING = Server.CreateObject("ADODB.Connection")

'sqlite 数据库
'MM_conn_STRING.open "DRIVER={SQLite3 ODBC Driver};Database="&mydata
'access 数据库
MM_conn_STRING.open "driver={microsoft access driver (*.mdb)};dbq="&mydata
'sql 数据库
'MM_conn_STRING.open "DRIVER={SQL Server};SERVER=ServerName;UID=USER;PWD=password;DATABASE=databasename"
'DSN 数据源
'MM_conn_STRING.open "DSN=MyDSN"

%>
<%  
dim sql_injdata 
'以 | 隔开防注册的字符 
SQL_injdata = "and|exec|insert|select|delete|update|count|*|%|chr|master|truncate|char|declare|or"   
SQL_inj = split(SQL_Injdata,"|") 
'防止Get方法注入 
If Request.QueryString<>"" Then 
  For Each SQL_Get In Request.QueryString 
    For SQL_Data=0 To Ubound(SQL_inj) 
      if instr(Request.QueryString(SQL_Get),Sql_Inj(Sql_DATA))>0 Then 
        Response.Write "<script>alert('非法字符尝试注入');history.back(-1)</script>":Response.end 
      end if 
    next 
  Next 
End If 
'防止Post方法注入 
If Request.Form<>"" Then 
  For Each Sql_Post In Request.Form 
    For SQL_Data=0 To Ubound(SQL_inj) 
      if instr(Request.Form(Sql_Post),Sql_Inj(Sql_DATA))>0 Then 
        Response.Write "<script>alert('非法字符尝试注入');history.back(-1)</script>":Response.end 
      end if 
    next 
  next 
end if  
%>

