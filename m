Return-Path: <btv1==6305b2bb996==klocke@stec-inc.com>
From: Keith Locke <klocke@stec-inc.com>
Subject: Mixed IO & Data Patterns with fio
Date: Wed, 10 Oct 2012 17:34:14 +0000
Message-ID: <AC83A371D8ED1741AC9D5BEAF6551948B0DED3@sambx4.stec-inc.ad>
Content-Language: en-US
Content-Type: multipart/related;
	boundary="_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_";
	type="multipart/alternative"
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>


--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: multipart/alternative;
	boundary="_000_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_"


--_000_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,
                First, I want to says that the fio utility is a fantastic t=
ools. Second, I hope this is an appropriate method of contacting you, if no=
t please advise.

I have a couple of test requirements that I would appreciate guidance on ho=
w to perform with fio.

1. 80/20 mix of random/sequential IO
2. 80% Random, 10% '00', & 10% 'FF' mixture of data patterns

Thank you in advance for your assistance / guidance.

Keith A. Locke
Test Systems Engineer, Engineering
Office 949.476.1180 x5574 * Fax 949.910.5447

STEC, Inc. | The SSD Company
NASDAQ STEC * Web www.stec-inc.com<http://www.stec-inc.com/>

[Description: facebook-32x32.png]<http://www.facebook.com/userstecinc>[Desc=
ription: twitter-32x32.png]<http://twitter.com/#!/stec_inc>[Description: yo=
utube-32x32.png]<http://www.youtube.com/user/stecincssd>[Description: linke=
din-32x32.png]<http://www.linkedin.com/in/stecinc>[Description: wordpress-3=
2x32.png]<http://www.stecblog.com/>[Description: rss-32x32.png]<http://www.=
stec-inc.com/rss/>


PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED=0D
=0D
This electronic transmission, and any documents attached hereto, may contai=
n confidential, proprietary and/or legally privileged information. The info=
rmation is intended only for use by the recipient named above. If you recei=
ved this electronic message in error, please notify the sender and delete t=
he electronic message. Any disclosure, copying, distribution, or use of the=
 contents of information received in error is strictly prohibited, and viol=
ators will be pursued legally.

--_000_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii">
<meta name=3D"Generator" content=3D"Microsoft Word 14 (filtered medium)">
<!--[if !mso]><style>v\:* {behavior:url(#default#VML);}
o\:* {behavior:url(#default#VML);}
w\:* {behavior:url(#default#VML);}
.shape {behavior:url(#default#VML);}
</style><![endif]--><style><!--
/* Font Definitions */
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:Tahoma;
	panose-1:2 11 6 4 3 5 4 4 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
p.MsoAcetate, li.MsoAcetate, div.MsoAcetate
	{mso-style-priority:99;
	mso-style-link:"Balloon Text Char";
	margin:0in;
	margin-bottom:.0001pt;
	font-size:8.0pt;
	font-family:"Tahoma","sans-serif";}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
span.BalloonTextChar
	{mso-style-name:"Balloon Text Char";
	mso-style-priority:99;
	mso-style-link:"Balloon Text";
	font-family:"Tahoma","sans-serif";}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:"Calibri","sans-serif";}
@page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"EN-US" link=3D"blue" vlink=3D"purple">
<div class=3D"WordSection1">
<p class=3D"MsoNormal">Hi,<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; First, I want to says that the fio u=
tility is a fantastic tools. Second, I hope this is an appropriate method o=
f contacting you, if not please advise.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I have a couple of test requirements that I would ap=
preciate guidance on how to perform with fio.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">1. 80/20 mix of random/sequential IO<o:p></o:p></p>
<p class=3D"MsoNormal">2. 80% Random, 10% '00', &amp; 10% 'FF' mixture of d=
ata patterns<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thank you in advance for your assistance / guidance.=
<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal"><b><span style=3D"font-size:9.0pt;font-family:&quot;=
Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#005996">Keith A. Locke</sp=
an></b><b><span style=3D"font-size:10.0pt;font-family:&quot;Trebuchet MS&qu=
ot;,&quot;sans-serif&quot;;color:#555555"><br>
</span></b><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&qu=
ot;,&quot;sans-serif&quot;;color:#595959">Test Systems Engineer, Engineering
<br>
Office </span><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS=
&quot;,&quot;sans-serif&quot;;color:#7F7F7F">949.476.1180 x5574</span><span=
 style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&quot;,&quot;sans-s=
erif&quot;;color:#595959"> &#8226; Fax
</span><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&quot;,=
&quot;sans-serif&quot;;color:#7F7F7F">949.910.5447</span><span style=3D"fon=
t-size:10.0pt;font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;c=
olor:#555555"><br>
<br>
</span><b><span style=3D"font-size:6.0pt;font-family:&quot;Trebuchet MS&quo=
t;,&quot;sans-serif&quot;;color:#2D2D2D"><o:p></o:p></span></b></p>
<p class=3D"MsoNormal"><b><span style=3D"font-size:9.0pt;font-family:&quot;=
Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#005996">STEC, Inc.</span><=
/b><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&quot;,&quo=
t;sans-serif&quot;;color:#595959"> |
</span><b><span style=3D"font-size:9.0pt;font-family:&quot;Trebuchet MS&quo=
t;,&quot;sans-serif&quot;;color:#005996">The SSD Company</span></b><span st=
yle=3D"font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;color:bl=
ue"><br>
</span><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&quot;,=
&quot;sans-serif&quot;;color:#595959">NASDAQ
</span><span style=3D"font-size:8.0pt;font-family:&quot;Trebuchet MS&quot;,=
&quot;sans-serif&quot;;color:#7F7F7F">STEC</span><span style=3D"font-size:8=
.0pt;font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#595=
959"> &#8226; Web
</span><span style=3D"font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif=
&quot;"><a href=3D"http://www.stec-inc.com/"><span style=3D"font-size:8.0pt=
;color:#7F7F7F">www.stec-inc.com</span></a></span><span style=3D"font-size:=
8.0pt;font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#7F=
7F7F"><o:p></o:p></span></p>
<p class=3D"MsoNormal"><b><span style=3D"font-size:3.0pt;font-family:&quot;=
Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#7F7F7F"><o:p>&nbsp;</o:p><=
/span></b></p>
<p class=3D"MsoNormal"><a href=3D"http://www.facebook.com/userstecinc"><b><=
span style=3D"font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;c=
olor:#7F7F7F;text-decoration:none"><img border=3D"0" width=3D"28" height=3D=
"47" id=3D"Picture_x0020_2" src=3D"cid:image013.jpg@01CDA6D2.CA970410" alt=
=3D"Description: facebook-32x32.png"></span></b></a><a href=3D"http://twitt=
er.com/#!/stec_inc"><b><span style=3D"font-family:&quot;Trebuchet MS&quot;,=
&quot;sans-serif&quot;;color:#7F7F7F;text-decoration:none"><img border=3D"0=
" width=3D"28" height=3D"47" id=3D"Picture_x0020_3" src=3D"cid:image014.jpg=
@01CDA6D2.CA970410" alt=3D"Description: twitter-32x32.png"></span></b></a><=
a href=3D"http://www.youtube.com/user/stecincssd"><b><span style=3D"font-fa=
mily:&quot;Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#7F7F7F;text-dec=
oration:none"><img border=3D"0" width=3D"28" height=3D"47" id=3D"Picture_x0=
020_4" src=3D"cid:image015.jpg@01CDA6D2.CA970410" alt=3D"Description: youtu=
be-32x32.png"></span></b></a><a href=3D"http://www.linkedin.com/in/stecinc"=
><b><span style=3D"font-family:&quot;Trebuchet MS&quot;,&quot;sans-serif&qu=
ot;;color:#7F7F7F;text-decoration:none"><img border=3D"0" width=3D"28" heig=
ht=3D"47" id=3D"Picture_x0020_5" src=3D"cid:image016.jpg@01CDA6D2.CA970410"=
 alt=3D"Description: linkedin-32x32.png"></span></b></a><a href=3D"http://w=
ww.stecblog.com/"><b><span style=3D"font-family:&quot;Trebuchet MS&quot;,&q=
uot;sans-serif&quot;;color:#7F7F7F;text-decoration:none"><img border=3D"0" =
width=3D"28" height=3D"47" id=3D"Picture_x0020_6" src=3D"cid:image017.jpg@0=
1CDA6D2.CA970410" alt=3D"Description: wordpress-32x32.png"></span></b></a><=
a href=3D"http://www.stec-inc.com/rss/"><b><span style=3D"font-family:&quot=
;Trebuchet MS&quot;,&quot;sans-serif&quot;;color:#7F7F7F;text-decoration:no=
ne"><img border=3D"0" width=3D"28" height=3D"47" id=3D"Picture_x0020_7" src=
=3D"cid:image018.jpg@01CDA6D2.CA970410" alt=3D"Description: rss-32x32.png">=
</span></b></a><b><span style=3D"font-family:&quot;Trebuchet MS&quot;,&quot=
;sans-serif&quot;;color:#7F7F7F"><o:p></o:p></span></b></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
</div>
<br><div style=3D"font-family: Arial, Helvetica, sans-serif; font-size:9px;=
 color: #787878"><strong><u>PROPRIETARY-CONFIDENTIAL INFORMATION INCLUDED</=
u></strong><br>=0D
This electronic transmission, and any documents attached hereto, may contai=
n confidential, proprietary and/or legally privileged information.  The inf=
ormation is intended only for use by the recipient named above. If you rece=
ived this electronic message in error, please notify the sender and delete =
the electronic message.  Any disclosure, copying, distribution, or use of t=
he contents of information received in error is strictly prohibited, and vi=
olators will be pursued legally.</div>
&nbsp;&nbsp;&shy;&shy;&nbsp;&nbsp;</body>
</html>

--_000_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_--

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image013.jpg"
Content-Description: image013.jpg
Content-Disposition: inline; filename="image013.jpg"; size=1009;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image013.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD13xV4j/sa
2EUBH2mQZBIzsHr9fSvLby/nvpzLcO0jnu5ya0vFk11qGsahcxxs8NvcG3OB
k5XIxj8CawEgvJVkZLabEaF2yh6f5NAHTeH/ABZd6TcIksjS2hOGjY5wPVfT
6V6xDNHcQpNEwaN1DKw7g18+wx3k7N5dvL8qlyShHAGa9Z+HWoNf+FwHzm3n
aEZ9MBv/AGbFAHnuta5feF/FmqwxwRyB7t518zOBuyQR+DVnp4+1GINttYAG
cuRuONxwf5iu9+JHg+bV4l1XT4y91Eu2WNesijoR7ivFLhZInKOjKwOCCMEU
AdYfiTqsbFltbXcc9j368f5xXpHwpt5IvCEk8i7RdXckyj2wq/zU14/4Y8Ka
h4n1NIYImWAEebOR8qD6+vtX0fp9jBpmnwWVsu2GBAiD2FABfXf2SHcq7pD9
1a4fU9Ij1W7Nzd2lvJKe5iFd1LbLM+5qZ9hj9BQBh6JdPp8aWjQotuOF2KF2
/lXTZzVT7BH6CrKLsQL6UAf/2Q==

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image014.jpg"
Content-Description: image014.jpg
Content-Disposition: inline; filename="image014.jpg"; size=936;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image014.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3DUb0wDyo
iBIRktjO0f41gS7JnLSIHb+8/wAxNLf3nmXU/PSVl/75O3+hrS+wfbNNtWiZ
EYLliR1oAq2d7JaMNhJjHWPORj29DXRxyLLGsiHKsMg1xd+zafcmF3VmUA5F
b/hy6+06dIO0UpQfTAb/ANmoA5XUg8GoXaN1E8h/BjuH6GtVYzrGi2qQXXky
wHDAHH51P4m0iScfbbZC7hcSovUgdGHuP5VwsssiMdjsD0O1sH8aALWrwSaf
etBJKJXwG3A5zmuy8FxPHosjt0lnZl+gCr/NTXD6Xpd5rN6I4gx5+eU8hB6k
+vtXqtpax2VpFbQjEcShRQAXExhT5Rlz0Fc5e6VBfTma4t4pJD1YoK6Zog5y
aaIE7jNAGXprmyjW3EarAOAFXG2tnrUJt0zwKlUbVA9KAP/Z

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image015.jpg"
Content-Description: image015.jpg
Content-Disposition: inline; filename="image015.jpg"; size=934;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image015.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3a5mYN5UZ
wxGWbGdo/wAaovbwyHLxhz/efkmob7U4LPMlwxUSzmMH3HAH6Gs/U/EENmkf
2Uw3Mjhm2+ZgYUZ/OgDZjZrb5oclB96LORj29DWkjrIiupyrDINcRYeKp55I
ftOmvAkg3Bwc7ecc+nNdZpsm+KZB0jlKj6YB/rQBiappi6nBLaySNGY7lpAw
GepJH/oVctP4NvdPMdxpt6lzMCdyXI2DBXBwRXf6hbujm6iUuCMSIOpHYj3F
YN1egg7WBoA54x+ICRDcxWMUDOGdo5izY3Z4H6V3mgBjZSyt0kmLD6YA/pXM
2ltcanciOIHbn5n7KK7e3gS2t0hjGEQYFACyOVGFGWPQVk3WmxXMpkmiR3Pc
qK2CoJzSFAaAKFmxtlEWwCMdMDGK0ajMSmngYAHpQB//2Q==

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image016.jpg"
Content-Description: image016.jpg
Content-Disposition: inline; filename="image016.jpg"; size=905;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image016.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD3e4mZSIoz
hyMlv7oqq1vExy672/vPyagn1O0t55hPMqPuyQey7toP0zUTaxYu7xpeQFkI
U/vB1IyPrQBcST7Ow8snaOqE8fh71oqwdQynIIyK4S88W2URLReZcICQZIBu
AIPI/Suu0mf7RZBx0zx9CAf60Acx4h8PW+rTyNcXVxCCGidIjgOpbcM/nXL3
Hw/0Z52kE10NzZKB/l+ntXpeqWTTKZYwScfMB1+tc68LqxGM+4oAwbPQX022
NtZXeI25YyJlic5PTtzXoGhwmDTgh7HAP0AH9KxrKxknmXA6fkPc11EUawxL
GvRRigAkfYOOTWdNbxzSF3jVmPcitIqG60nlCgCvbEQqECgIOwHSrdM8sU8D
AxQB/9k=

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image017.jpg"
Content-Description: image017.jpg
Content-Disposition: inline; filename="image017.jpg"; size=1069;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image017.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD1Lxv4tHh2
zWG3I+2SqSCRny19cevpXkE8mr65K1zIskzEbt0h3HH41o+K7yTXPiBc2ygu
UnaJUz12fKB+Y/Wuu0/xR/ZPgmw1ODTrRY2u/sl2GzmNt23cT3/+uKAOZ8M+
NdT8PX0dveNJJZnh4XOdo9VP+RXt8E8d1bxzwuHikUMrDuDXhfj+0uote1aS
SONYIfLlhaMYADD+uD+VehfCrU21LwYoY5+zTvAD7YDD/wBCoA8n1+SXw/8A
FW7ll4H21pgT3DtvH866kWH9tt4q8O2pZ7W4H9rWrr0UsvC/XeOntWx8VfA0
2uwLrGmxGS8hTbNEo5kQdCPUivHrLxLrWhvKkLMkrL5btyrEDsaAOq8WeJ01
HwRau+FvLwIJF7gIuwD89xr0L4M2Ulp4EMkgwLm6eVPptVP5oa8b8N+GNY8b
axFEkZS2Q/vJQuI4lzyfc/qa+nNN0+30rTbewtV2wW8YRB7CgBNQvfsUG5V3
yH7q/wCNcBquix61eNdXljbzSn+Iwr/hXoU1qs77mpUtY0JwoIxigDm9Au30
2OOyaBEtl4XYgXb+VdWDkZqo1hE2CQM1ZjXYgX04oA//2Q==

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_
Content-Type: image/jpeg; name="image018.jpg"
Content-Description: image018.jpg
Content-Disposition: inline; filename="image018.jpg"; size=986;
	creation-date="Wed, 10 Oct 2012 17:34:14 GMT";
	modification-date="Wed, 10 Oct 2012 17:34:14 GMT"
Content-ID: <image018.jpg@01CDA6D2.CA970410>
Content-Transfer-Encoding: base64

/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsL
DBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/
2wBDAQkJCQwLDBgNDRgyIRwhMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIy
MjIyMjIyMjIyMjIyMjIyMjIyMjIyMjL/wAARCAAvABwDASIAAhEBAxEB/8QA
HwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUF
BAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkK
FhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1
dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXG
x8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEB
AQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAEC
AxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRom
JygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOE
hYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU
1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD2rWNTNmoh
h/1zjrjO0f4ntXH3jzSTZuY2D/8ATUZP61Y1O+kn14rER5guCiZ6ZU7R/Kta
bUWV1svENoiJKdqXC/dz9e1AGbpesz2EqjczwfxRk549vQ128UiTRLJGdyMM
gjuK811m3k0e/MDNlCN0b/3lrrfCF4bvRSDz5MrRj6YDf+zUAcTrMc8XiS5h
UlZWuWKHp95twP61vwSXEslx4c1mRbhpYfMhmHUH/wCtVnxjoEt4F1GyUtPG
MSIvVgOhHuK89l1LUI7/AO1/aJPtS/KJD1HtQB0GsztqHgu1nlybmynMDt3I
6f4V03gCB4fDrO44mnZ1+mFX/wBlNcJotlq2uyNYxyP9leTzJmI+VT3JPr7V
67Z2kVjZw2sIxHEoVRQAXVx5EeVG5z0Fctf6ZDqFwZ7m2hkkP8RjFdY8Ku2W
5pPITfu2igDI0uY2SJbeWqwjgbVxtrc61CbdNpGByc1Kq7VA9KAP/9k=

--_009_AC83A371D8ED1741AC9D5BEAF6551948B0DED3sambx4stecincad_--


