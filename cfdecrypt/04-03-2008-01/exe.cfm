<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfexecute name="c:\winnt\system32\netstat.exe"
					arguments="-e"
					outputfile="c:\temp\output.txt"
					timeout="1"></cfexecute>

</body>
</html>
