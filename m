Return-Path: <jmcvay@micron.com>
From: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Subject: FIO 2.1 iops logging problem
Date: Tue, 28 May 2013 21:01:52 +0000
Message-ID: <C8CA972100601A41AE302914E9CE194680367B7E@NTXBOIMBX03.micron.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_C8CA972100601A41AE302914E9CE194680367B7ENTXBOIMBX03micr_"
MIME-Version: 1.0
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--_000_C8CA972100601A41AE302914E9CE194680367B7ENTXBOIMBX03micr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

I cannot seem to get the write_iops_log working with FIO 2.1.

I found that write_bw_log now requires write_bw_log=3D<text> to work. Howev=
er that does not seem to work on the iops logging. Any idea what I am doing=
 wrong?

Thanks,
Jeff

--_000_C8CA972100601A41AE302914E9CE194680367B7ENTXBOIMBX03micr_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:x=3D"urn:schemas-microsoft-com:office:excel" xmlns:m=3D"http://schema=
s.microsoft.com/office/2004/12/omml" xmlns=3D"http://www.w3.org/TR/REC-html=
40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 12 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
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
<p class=3D"MsoNormal">Hi Jens,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I cannot seem to get the write_iops_log working with=
 FIO 2.1.<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">I found that write_bw_log now requires write_bw_log=
=3D&lt;text&gt; to work. However that does not seem to work on the iops log=
ging. Any idea what I am doing wrong?<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thanks,<o:p></o:p></p>
<p class=3D"MsoNormal">Jeff<o:p></o:p></p>
</div>
</body>
</html>

--_000_C8CA972100601A41AE302914E9CE194680367B7ENTXBOIMBX03micr_--


