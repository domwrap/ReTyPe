arrDB := {}
arrDB["dev"]	:= "Provider=SQLOLEDB.1;Password=PASSWORD;Persist Security Info=True;User ID=LOGINID;Initial Catalog=DBNAME;Data Source=DBSERVER;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
arrDB["prod"]	:= "Provider=SQLOLEDB.1;Password=PASSWORD;Persist Security Info=True;User ID=LOGINID;Initial Catalog=DBNAME;Data Source=DBSERVER;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"
