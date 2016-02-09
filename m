Return-Path: <Kurt_Dorsey@dell.com>
From: <Kurt_Dorsey@Dell.com>
Subject: RE: output_format=terse,json core dumping
Date: Tue, 9 Feb 2016 20:30:05 +0000
Message-ID: <87c43402f1e2478c8b383be5fd54eec3@AUSX13MPC107.AMER.DELL.COM>
References: <loom.20160209T200431-709@post.gmane.org>
 <56BA4A05.7010300@kernel.dk>
In-Reply-To: <56BA4A05.7010300@kernel.dk>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_87c43402f1e2478c8b383be5fd54eec3AUSX13MPC107AMERDELLCOM_"
MIME-Version: 1.0
Return-Path: Kurt_Dorsey@Dell.com
To: axboe@kernel.dk, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--_000_87c43402f1e2478c8b383be5fd54eec3AUSX13MPC107AMERDELLCOM_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Dell - Internal Use - Confidential
Thank you Jens for the quick turn around on this!

This version works much better.  The only thing is, it seems to be adding n=
ewline before the device field in terse (sdb) and does not newline after th=
e terse and at the beginning of the json.  Very minor for my work and I can=
 work around it.  I just wanted to let you know

fio --ioengine=3Dlibaio --buffered=3D0 --direct=3D1 --norandommap --name=3D=
test  --filename=3D/dev/sdb --iodepth=3D32  --ba=3D4k --rw=3Drandrw --rwmix=
write=3D65 --bs=3D8K --numjobs=3D1 --runtime=3D10 --ramp_time=3D0 --time_ba=
sed --output-format=3Dterse,json
3;fio-2.6-11-g6efb;test;0;0;2743024;274274;34284;10001;2;66;5.068155;2.0817=
77;53;4259;680.945963;661.510225;1.000000%=3D104;5.000000%=3D135;10.000000%=
=3D159;20.000000%=3D195;30.000000%=3D227;40.000000%=3D262;50.000000%=3D330;=
60.000000%=3D494;70.000000%=3D812;80.000000%=3D1160;90.000000%=3D1928;95.00=
0000%=3D2096;99.000000%=3D2288;99.500000%=3D2384;99.900000%=3D2768;99.95000=
0%=3D2992;99.990000%=3D3504;0%=3D0;0%=3D0;0%=3D0;60;4264;686.156050;661.478=
202;267168;285200;99.936944%;274101.052632;4453.180205;5081192;508068;63508=
;10001;1;58;5.145164;2.105941;25;3766;127.001488;67.905687;1.000000%=3D38;5=
.000000%=3D47;10.000000%=3D56;20.000000%=3D73;30.000000%=3D90;40.000000%=3D=
108;50.000000%=3D125;60.000000%=3D143;70.000000%=3D159;80.000000%=3D175;90.=
000000%=3D195;95.000000%=3D211;99.000000%=3D258;99.500000%=3D282;99.900000%=
=3D338;99.950000%=3D374;99.990000%=3D3088;0%=3D0;0%=3D0;0%=3D0;36;3770;132.=
306972;67.892863;495424;529328;99.953467%;507831.578947;7758.193363;14.0200=
00%;56.580000%;76256;0;34;0.1%;0.1%;0.1%;0.1%;0.1%;100.0%;0.0%;0.00%;0.00%;=
0.00%;0.00%;4.13%;19.17%;53.74%;8.98%;2.77%;3.12%;5.18%;2.91%;0.01%;0.00%;0=
.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;sdb;339716;629126;0;0;216452=
;53142;269548;99.14%
;sdb;339716;629126;0;0;216452;53142;269548;99.14%{
  "fio version" : "fio-2.6-11-g6efb",
  "timestamp" : 1455049466,
  "time" : "Tue Feb  9 14:24:26 2016",

Thank you!
-Kurt

-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]
Sent: Tuesday, February 09, 2016 2:20 PM
To: Dorsey, Kurt ; fio@vger.kernel.org
Subject: Re: output_format=3Dterse,json core dumping

On 02/09/2016 12:12 PM, Kurt Dorsey wrote:
> I am trying to get multiple output formats working with fio and I am
> getting a core dump
> fio: diskutil.c:710: show_disk_util: Assertion `parent' failed.
> Aborted (core dumped)
>
> I am utilizing format from
> commit a666cab8ed3d2a2fa782be345425a2e88734a007
> Author: Jens Axboe
> Date: Tue Oct 27 13:45:21 2015 +0900
>
> Enable the use of multiple output formats
>
> You can now do
>
> ./fio --output-format=3Dnormal,json jobfile.fio
>
> and get both types of output.
>
> Signed-off-by: Jens Axboe
>
>
> fio -v
> fio-2.6-10-g820b
>
>
>
> fio --ioengine=3Dlibaio --buffered=3D0 --direct=3D1 --norandommap
> --name=3Dtest --filename=3D/dev/sdb --iodepth=3D32 --ba=3D4k --rw=3Drandr=
w
> --rwmixwrite=3D65 -- bs=3D8K --numjobs=3D1 --runtime=3D10 --ramp_time=3D0
> --time_based --output- format=3Dterse,json
>
> I have also tried
> --format=3Dnormal,json and I get the same issue
>
>
> --output-format=3Dnormal,terse
> Works just fine but I really would like to have json output along with
> terse.
>
>
> Is there a workaround to get both terse and json (or json+)?

This should fix it:

http://git.kernel.dk/cgit/fio/commit/?id=3D6efb21c218d4ec38c1a4d7dbb86f2028=
f122acaa

Update to latest -git and test, let me know how it goes.

--
Jens Axboe

--_000_87c43402f1e2478c8b383be5fd54eec3AUSX13MPC107AMERDELLCOM_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"Trebuchet MS";
	panose-1:2 11 6 3 2 2 2 2 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:#0563C1;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:#954F72;
	text-decoration:underline;}
p
	{mso-style-priority:99;
	mso-margin-top-alt:auto;
	margin-right:0in;
	mso-margin-bottom-alt:auto;
	margin-left:0in;
	font-size:12.0pt;
	font-family:"Times New Roman",serif;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri",sans-serif;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;
	font-family:"Calibri",sans-serif;}
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
<body lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p><b><span style=3D"font-size:9.0pt;font-family:&quot;Trebuchet MS&quot;,s=
ans-serif;color:#AAAAAA">Dell - Internal Use - Confidential
</span></b><o:p></o:p></p>
<p class=3D"MsoNormal">Thank you Jens for the quick turn around on this!<o:=
p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">This version works much better.&nbsp; The only thing=
 is, it seems to be adding newline before the device field in terse (sdb) a=
nd does not newline after the terse and at the beginning of the json.&nbsp;=
 Very minor for my work and I can work around
 it.&nbsp; I just wanted to let you know<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">fio --ioengine=3Dlibaio --buffered=3D0 --direct=3D1 =
--norandommap --name=3Dtest&nbsp; --filename=3D/dev/sdb --iodepth=3D32&nbsp=
; --ba=3D4k --rw=3Drandrw --rwmixwrite=3D65 --bs=3D8K --numjobs=3D1 --runti=
me=3D10 --ramp_time=3D0 --time_based --output-format=3Dterse,json<o:p></o:p=
></p>
<p class=3D"MsoNormal">3;fio-2.6-11-g6efb;test;0;0;2743024;274274;34284;100=
01;2;66;5.068155;2.081777;53;4259;680.945963;661.510225;1.000000%=3D104;5.0=
00000%=3D135;10.000000%=3D159;20.000000%=3D195;30.000000%=3D227;40.000000%=
=3D262;50.000000%=3D330;60.000000%=3D494;70.000000%=3D812;80.000000%=3D1160=
;90.000000%=3D1928;95.000000%=3D2096;99.000000%=3D2288;99.500000%=3D2384;99=
.900000%=3D2768;99.950000%=3D2992;99.990000%=3D3504;0%=3D0;0%=3D0;0%=3D0;60=
;4264;686.156050;661.478202;267168;285200;99.936944%;274101.052632;4453.180=
205;5081192;508068;63508;10001;1;58;5.145164;2.105941;25;3766;127.001488;67=
.905687;1.000000%=3D38;5.000000%=3D47;10.000000%=3D56;20.000000%=3D73;30.00=
0000%=3D90;40.000000%=3D108;50.000000%=3D125;60.000000%=3D143;70.000000%=3D=
159;80.000000%=3D175;90.000000%=3D195;95.000000%=3D211;99.000000%=3D258;99.=
500000%=3D282;99.900000%=3D338;99.950000%=3D374;99.990000%=3D3088;0%=3D0;0%=
=3D0;0%=3D0;36;3770;132.306972;67.892863;495424;529328;99.953467%;507831.57=
8947;7758.193363;14.020000%;56.580000%;76256;0;34;0.1%;0.1%;0.1%;0.1%;0.1%;=
100.0%;0.0%;0.00%;0.00%;0.00%;0.00%;4.13%;19.17%;53.74%;8.98%;2.77%;3.12%;5=
.18%;2.91%;0.01%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;0.00%;sdb;=
339716;629126;0;0;216452;53142;269548;99.14%<o:p></o:p></p>
<p class=3D"MsoNormal">;sdb;339716;629126;0;0;216452;53142;269548;99.14%{<o=
:p></o:p></p>
<p class=3D"MsoNormal">&nbsp; &quot;fio version&quot; : &quot;fio-2.6-11-g6=
efb&quot;,<o:p></o:p></p>
<p class=3D"MsoNormal">&nbsp; &quot;timestamp&quot; : 1455049466,<o:p></o:p=
></p>
<p class=3D"MsoNormal">&nbsp; &quot;time&quot; : &quot;Tue Feb&nbsp; 9 14:2=
4:26 2016&quot;,<o:p></o:p></p>
<p class=3D"MsoNormal"><o:p>&nbsp;</o:p></p>
<p class=3D"MsoNormal">Thank you!<o:p></o:p></p>
<p class=3D"MsoNormal">-Kurt <o:p></o:p></p>
<p>-----Original Message-----<br>
From: Jens Axboe [mailto:axboe@kernel.dk] <br>
Sent: Tuesday, February 09, 2016 2:20 PM<br>
To: Dorsey, Kurt ; fio@vger.kernel.org<br>
Subject: Re: output_format=3Dterse,json core dumping<br>
<br>
On 02/09/2016 12:12 PM, Kurt Dorsey wrote:<br>
&gt; I am trying to get multiple output formats working with fio and I am <=
br>
&gt; getting a core dump<br>
&gt; fio: diskutil.c:710: show_disk_util: Assertion `parent' failed.<br>
&gt; Aborted (core dumped)<br>
&gt;<br>
&gt; I am utilizing format from<br>
&gt; commit a666cab8ed3d2a2fa782be345425a2e88734a007<br>
&gt; Author: Jens Axboe <br>
&gt; Date: Tue Oct 27 13:45:21 2015 &#43;0900<br>
&gt;<br>
&gt; Enable the use of multiple output formats<br>
&gt;<br>
&gt; You can now do<br>
&gt;<br>
&gt; ./fio --output-format=3Dnormal,json jobfile.fio<br>
&gt;<br>
&gt; and get both types of output.<br>
&gt;<br>
&gt; Signed-off-by: Jens Axboe <br>
&gt;<br>
&gt;<br>
&gt; fio -v<br>
&gt; fio-2.6-10-g820b<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; fio --ioengine=3Dlibaio --buffered=3D0 --direct=3D1 --norandommap <br>
&gt; --name=3Dtest --filename=3D/dev/sdb --iodepth=3D32 --ba=3D4k --rw=3Dra=
ndrw <br>
&gt; --rwmixwrite=3D65 -- bs=3D8K --numjobs=3D1 --runtime=3D10 --ramp_time=
=3D0 <br>
&gt; --time_based --output- format=3Dterse,json<br>
&gt;<br>
&gt; I have also tried<br>
&gt; --format=3Dnormal,json and I get the same issue<br>
&gt;<br>
&gt;<br>
&gt; --output-format=3Dnormal,terse<br>
&gt; Works just fine but I really would like to have json output along with=
 <br>
&gt; terse.<br>
&gt;<br>
&gt;<br>
&gt; Is there a workaround to get both terse and json (or json&#43;)?<br>
<br>
This should fix it:<br>
<br>
http://git.kernel.dk/cgit/fio/commit/?id=3D6efb21c218d4ec38c1a4d7dbb86f2028=
f122acaa<br>
<br>
Update to latest -git and test, let me know how it goes.<br>
<br>
--<br>
Jens Axboe<o:p></o:p></p>
</div>
</body>
</html>

--_000_87c43402f1e2478c8b383be5fd54eec3AUSX13MPC107AMERDELLCOM_--

