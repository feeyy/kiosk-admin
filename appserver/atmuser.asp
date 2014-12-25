<!--会员账户管理-服务端代码 -->
<!--开发者：陈@大少 QQ：820094076  -->
<!--代码地址：https://github.com/feeyy/kiosk-admin -->
<!--首次编写时间：2014-10-25  -->

<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="Connections/conn.asp" -->
<%
'用户service
Dim ID
Dim ac
Dim userID
Dim sfName
Dim sfNumber
Dim sfSex
Dim sfNation
Dim sfBirthday
Dim sfAddress
Dim tel
Dim fpic
Dim fTemplate
Dim times
Dim pwd
Dim tpic
Dim email

Dim totalPage
Dim epage
Dim totalNum

Response.Charset = "utf-8"
'response.ContentType="application/json" 
Dim callback
callback = Request.QueryString("callback")

If Request("ac") = "usersadd" Then
	'用户添加

	userID     = Trim(Request("userID"))
	sfName     = Trim(Request("sfName"))
	sfNumber   = Trim(Request("sfNumber"))
	sfSex      = Trim(Request("sfSex"))
	sfNation   = Trim(Request("sfNation"))
	sfBirthday = Trim(Request("sfBirthday"))
	sfAddress  = Trim(Request("sfAddress"))
	tel        = Trim(Request("tel"))
	fpic       = Trim(Request("fpic"))
	fTemplate  = Trim(Request("fTemplate"))
	pwd        = Trim(Request("pwd"))
	tpic       = Trim(Request("tpic"))
	email       = Trim(Request("email"))

	Set adduser = Server.CreateObject("Adodb.Recordset")
	adduserSQL  = "Select * from userDB"
	adduser.open adduserSQL,MM_conn_STRING,3,2
	adduser.addnew

	adduser("userID") = userID
	adduser("sfName") = sfName
	adduser("sfNumber") = sfNumber
	adduser("sfSex") = sfSex
	adduser("sfNation") = sfNation
	adduser("sfBirthday") = sfBirthday
	adduser("sfAddress") = sfAddress
	adduser("tel") = tel
	adduser("fpic") = fpic
	adduser("fTemplate") = fTemplate
	adduser("pwd") = pwd
	adduser("tpic") = tpic
	adduser("email") = email

	adduser.update
	adduser.Close
	Set adduser = Nothing

	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing
	
	Dim ahtml
	ahtml              = "{""result"":""1""}"    '数据添加成功
	Response.Write(callback & "(" & ahtml & ")")

End If

If Request("ac") = "userslist" Then
	'用户查询所有
	Dim uhtml

	Set listrs = Server.CreateObject("adodb.recordset")
	listrs.open"select * from userDB order by times DESC",MM_conn_STRING,1,1

	

	If listrs.eof And listrs.bof Then

		uhtml = "{""result"":""0""}"   '数据为空
		Response.Write(callback & "(" & uhtml & ")")

	Else
	
	if request("pagesize") <> "" then
	listrs.pagesize = cint(request("pagesize"))
	else
	listrs.pagesize = 8
	end if
	
	if request("page") <> "" then
  	epage = cint(request("page"))
   		if epage<1 then epage=1
   		if epage>listrs.pagecount then epage=listrs.pagecount
		else
		epage=1
	end if
	listrs.absolutepage=epage
	
	totalNum = Chr(34) & listrs.recordcount & Chr(34)
	totalPage = Chr(34) & listrs.pagecount & Chr(34)
		
		uhtml      = "{""totalNum"":" & totalNum & ",""totalPage"":" & totalPage & ",""users"":["
		
		for i=0 to listrs.pagesize-1
		if listrs.bof or listrs.eof then exit for

		ID         = Chr(34) & listrs("ID") & Chr(34)
		userID     = Chr(34) & listrs("userID") & Chr(34)
		sfName     = Chr(34) & listrs("sfName") & Chr(34)
		sfNumber   = Chr(34) & listrs("sfNumber") & Chr(34)
		sfSex      = Chr(34) & listrs("sfSex") & Chr(34)
		sfNation   = Chr(34) & listrs("sfNation") & Chr(34)
		sfBirthday = Chr(34) & listrs("sfBirthday") & Chr(34)
		sfAddress  = Chr(34) & listrs("sfAddress") & Chr(34)
		tel        = Chr(34) & listrs("tel") & Chr(34)
		fpic       = Chr(34) & listrs("fpic") & Chr(34)
		fTemplate  = Chr(34) & listrs("fTemplate") & Chr(34)
		pwd        = Chr(34) & listrs("pwd") & Chr(34)
		tpic       = Chr(34) & listrs("tpic") & Chr(34)
		email       = Chr(34) & listrs("email") & Chr(34)

		uhtml      = uhtml & "{""ID"":" & ID & ",""userID"":" & userID & ",""sfName"":" & sfName & ",""sfNumber"":" & sfNumber & ",""sfSex"":" & sfSex &",""sfNation"":" & sfNation &",""sfBirthday"":" & sfBirthday &",""sfAddress"":" & sfAddress &",""tel"":" & tel &",""fpic"":" & fpic &",""fTemplate"":" & fTemplate &",""pwd"":" & pwd &",""tpic"":" & tpic &",""email"":" & email & "},"
		listrs.movenext()
		next
		uhtml = uhtml & "]}"

		Response.Write(callback & "(" & uhtml & ")")

	End If

	listrs.Close()
	Set listrs = Nothing
	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing

End If

If Request("ac") = "search" and Request("stxt")<>"" Then
	'用户搜索
	Dim shtml
	Dim stxt 
	stxt = trim(Request("stxt"))
	Set searchrs = Server.CreateObject("adodb.recordset")
	searchrs.open"select * from userDB where sfName like '%"&stxt&"%' order by sfName",MM_conn_STRING,1,1

	If searchrs.eof And searchrs.bof Then

		shtml = "{""result"":""0""}"   '数据为空
		Response.Write(callback & "(" & shtml & ")")

	Else
	
		shtml      = "{""users"":["
		
		While Not searchrs.eof

		ID         = Chr(34) & searchrs("ID") & Chr(34)
		userID     = Chr(34) & searchrs("userID") & Chr(34)
		sfName     = Chr(34) & searchrs("sfName") & Chr(34)
		sfNumber   = Chr(34) & searchrs("sfNumber") & Chr(34)
		sfSex      = Chr(34) & searchrs("sfSex") & Chr(34)
		sfNation   = Chr(34) & searchrs("sfNation") & Chr(34)
		sfBirthday = Chr(34) & searchrs("sfBirthday") & Chr(34)
		sfAddress  = Chr(34) & searchrs("sfAddress") & Chr(34)
		tel        = Chr(34) & searchrs("tel") & Chr(34)
		fpic       = Chr(34) & searchrs("fpic") & Chr(34)
		fTemplate  = Chr(34) & searchrs("fTemplate") & Chr(34)
		pwd        = Chr(34) & searchrs("pwd") & Chr(34)
		tpic       = Chr(34) & searchrs("tpic") & Chr(34)
		email       = Chr(34) & searchrs("email") & Chr(34)

		shtml      = shtml & "{""ID"":" & ID & ",""userID"":" & userID & ",""sfName"":" & sfName & ",""sfNumber"":" & sfNumber & ",""sfSex"":" & sfSex &",""sfNation"":" & sfNation &",""sfBirthday"":" & sfBirthday &",""sfAddress"":" & sfAddress &",""tel"":" & tel &",""fpic"":" & fpic &",""fTemplate"":" & fTemplate &",""pwd"":" & pwd &",""tpic"":" & tpic &",""email"":" & email & "},"
		searchrs.movenext
		Wend
		
		shtml = shtml & "]}"

		Response.Write(callback & "(" & shtml & ")")

	End If

	searchrs.Close()
	Set searchrs = Nothing
	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing

End If

If Request("ac") = "useredt" And Request("ID") <> "" Then
	Dim ehtml
	'编辑单个用户
	ID      	= Trim(Request("ID"))
	userID      = Trim(Request("userID"))
	sfName      = Trim(Request("sfName"))
	sfNumber    = Trim(Request("sfNumber"))
	sfSex       = Trim(Request("sfSex"))
	sfNation    = Trim(Request("sfNation"))
	sfBirthday  = Trim(Request("sfBirthday"))
	sfAddress   = Trim(Request("sfAddress"))
	tel         = Trim(Request("tel"))
	fpic        = Trim(Request("fpic"))
	fTemplate   = Trim(Request("fTemplate"))
	pwd         = Trim(Request("pwd"))
	tpic        = Trim(Request("tpic"))
	email        = Trim(Request("email"))

	Set edtuser = Server.CreateObject("Adodb.Recordset")
	edtuserSQL  = "select * from userDB where ID=" & ID
	edtuser.open edtuserSQL,MM_conn_STRING,3,2
	
	If edtuser.eof And edtuser.bof Then
		ehtml = "{""result"":""0""}"   '数据为空
		Response.Write(callback & "(" & ehtml & ")")

	Else

	If sfName <> "" Then
		edtuser("sfName") = sfName
	End If

	If sfNumber <> "" Then
		edtuser("sfNumber") = sfNumber
	End If

	If sfSex <> "" Then
		edtuser("sfSex") = sfSex
	End If

	If sfNation <> "" Then
		edtuser("sfNation") = sfNation
	End If

	If sfBirthday <> "" Then
		edtuser("sfBirthday") = sfBirthday
	End If

	If sfAddress <> "" Then
		edtuser("sfAddress") = sfAddress
	End If

	If tel <> "" Then
		edtuser("tel") = tel
	End If

	If fpic <> "" Then
		edtuser("fpic") = fpic
	End If

	If fTemplate <> "" Then
		edtuser("fTemplate") = fTemplate
	End If

	If pwd <> "" Then
		edtuser("pwd") = pwd
	End If

	If tpic <> "" Then
		edtuser("tpic") = tpic
	End If
	
	If email <> "" Then
		edtuser("email") = email
	End If

	edtuser.update
	
	ehtml = "{""result"":""1""}"    '数据修改成功
	Response.Write(callback & "(" & ehtml & ")")
	end if
	
	edtuser.Close
	Set edtuser = Nothing
	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing

End If

If Request("ac") = "finduser" and Request("ID") <> "" Then
	'查询单个用户
	Dim fhtml
	ID      	 = Trim(Request("ID"))
	Set finduser = Server.CreateObject("adodb.recordset")
	finduser.open"select * from userDB where ID=" & ID,MM_conn_STRING,1,1

	If finduser.eof And finduser.bof Then
		fhtml = "{""result"":""0""}"   '数据为空
		Response.Write(callback & "(" & fhtml & ")")

	Else
		ID         = Chr(34) & finduser("ID") & Chr(34)
		userID     = Chr(34) & finduser("userID") & Chr(34)
		sfName     = Chr(34) & finduser("sfName") & Chr(34)
		sfNumber   = Chr(34) & finduser("sfNumber") & Chr(34)
		sfSex      = Chr(34) & finduser("sfSex") & Chr(34)
		sfNation   = Chr(34) & finduser("sfNation") & Chr(34)
		sfBirthday = Chr(34) & finduser("sfBirthday") & Chr(34)
		sfAddress  = Chr(34) & finduser("sfAddress") & Chr(34)
		tel        = Chr(34) & finduser("tel") & Chr(34)
		fpic       = Chr(34) & finduser("fpic") & Chr(34)
		fTemplate  = Chr(34) & finduser("fTemplate") & Chr(34)
		pwd        = Chr(34) & finduser("pwd") & Chr(34)
		tpic       = Chr(34) & finduser("tpic") & Chr(34)
		email       = Chr(34) & finduser("email") & Chr(34)

		fhtml      = "{""users"":["
		fhtml      = fhtml & "{""ID"":" & ID & ",""userID"":" & userID & ",""sfName"":" & sfName & ",""sfNumber"":" & sfNumber & ",""sfSex"":" & sfSex &",""sfNation"":" & sfNation &",""sfBirthday"":" & sfBirthday &",""sfAddress"":" & sfAddress &",""tel"":" & tel &",""fpic"":" & fpic &",""fTemplate"":" & fTemplate &",""pwd"":" & pwd &",""tpic"":" & tpic &",""email"":" & email & "},"
		fhtml      = fhtml & "]}"

		Response.Write(callback & "(" & fhtml & ")")

	End If

	finduser.Close()
	Set finduser = Nothing
	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing

End If

If Request("ac") = "deluser" and Request("ID") <> "" Then
	'删除单个用户
	Dim dhtml
	ID      	= Trim(Request("ID"))
	Set userdel = Server.CreateObject("Adodb.Recordset")
	userdelSQL  = "select * from userDB where ID=" & ID
	userdel.open userdelSQL,MM_conn_STRING,3,2

	If userdel.eof And userdel.bof Then

		dhtml = "{""result"":""0""}"   '删除失败
		Response.Write(callback & "(" & dhtml & ")")

	Else

		userdel.delete
		userdel.update
		
		dhtml = "{""result"":""1""}"   '删除成功
		Response.Write(callback & "(" & dhtml & ")")

	End If

	userdel.Close
	Set userdel = Nothing
	MM_conn_STRING.Close
	Set MM_conn_STRING = Nothing

	
End If 
%>
