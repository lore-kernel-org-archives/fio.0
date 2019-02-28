Return-Path: <kailash.mallikarjunaswamy@skhms.com>
From: Kailash Mallikarjunaswamy <Kailash.Mallikarjunaswamy@skhms.com>
Subject: Fio version 3.1 on CentOS - Possible bug reporting
Date: Thu, 28 Feb 2019 23:35:47 +0000
Message-ID: <18dd8eb6f2ee414195c87d0117c9e9dc@N111XMB0239.skhms.com>
References: <1551233986158.86408@skhms.com>
In-Reply-To: <1551233986158.86408@skhms.com>
Content-Language: en-US
MIME-Version: 1.0
Content-Type: multipart/alternative;
	boundary="_000_18dd8eb6f2ee414195c87d0117c9e9dcN111XMB0239skhmscom_"
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, "majordomo@vger.kernel.org" <majordomo@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: Yi Tong <yi.tong@skhms.com>, "Sean (Seong Won) Shin" <seongwon.shin@skhms.com>
List-ID: <fio@vger.kernel.org>

--_000_18dd8eb6f2ee414195c87d0117c9e9dcN111XMB0239skhmscom_
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable

Hi,



I am writing to report a possible* bug on:



fio version - 3.1

Operating System - CentOS  7.6.1810

kernel: 3.10.0-957.1.3.el7.x86_64



I use a HP Proliant Enterprise Server hardware to run the metrics



Bug: In some of the runs, the max value of completion latency (clat) is les=
ser than the 9-nines percentile value. How is this possible? I have marked =
the numbers in red below. Kindly take a look.

___________________________________________________________________________=
_

Workload:



sudo chrt -f 1 fio  --filename=3D/dev/nvme0n1 --numjobs=3D1 --iodepth=3D512=
 --offset=3D0M --bs=3D

7681501126656 --size=3D

7681501126656 --io_size=3D%s --rw=3Dread --buffered=3D0 --thread --time_bas=
ed --runtime=3D60 --name=3Dseqtest0 --group_reporting --disable_lat=3D1 --d=
isable_slat=3D1 --disable_bw_measurement=3D1 --zero_buffers --ioengine=3Dli=
baio --percentile=3D99:99.9:99.99:99.999:99.9999:99.99999:99.999999:99.9999=
999 --output-format=3Djson,normal --eta=3Dnever --invalidate=3D1 --end_fsyn=
c=3D0 --refill_buffers



___________________________________________________________________________=
_

Result:



seqtest0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3908: Tue Feb 26 18:02:2=
5 2019
   read: IOPS=3D25.1k, BW=3D3135MiB/s (3287MB/s)(184GiB/60021msec)
    clat (usec): min=3D16426, max=3D41005, avg=3D20384.67, stdev=3D337.20
    clat percentiles (usec):
     | 99.0000000th=3D[20579], 99.9000000th=3D[21103], 99.9900000th=3D[3801=
1],
     | 99.9990000th=3D[40633], 99.9999000th=3D[41157], 99.9999900th=3D[4115=
7],
     | 99.9999990th=3D[41157], 99.9999999th=3D[41157]
   bw (  MiB/s): min=3D 2981, max=3D 3144, per=3D100.00%, avg=3D3135.58, st=
dev=3D14.46, samples=3D120
   iops        : min=3D23848, max=3D25154, avg=3D25084.63, stdev=3D115.65, =
samples=3D120
  lat (msec)   : 20=3D0.31%, 50=3D99.69%
  cpu          : usr=3D4.10%, sys=3D64.00%, ctx=3D742962, majf=3D0, minf=3D=
44
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.1%
     issued rwt: total=3D1505214,0,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D512

Run status group 0 (all jobs):
   READ: bw=3D3135MiB/s (3287MB/s), 3135MiB/s-3135MiB/s (3287MB/s-3287MB/s)=
, io=3D184GiB (197GB), run=3D60021-60021msec

___________________________________________________________________________=
_



Any inputs/help will be greatly appreciated.



Thanks in advance!



The information contained in this e-mail is considered confidential of SK h=
ynix memory solutions America Inc. and intended only for the persons addres=
sed or copied in this e-mail. Any unauthorized use, dissemination of the in=
formation, or copying of this message is strictly prohibited. If you are no=
t the intended recipient, please contact the sender immediately and permane=
ntly delete the original and any copies of this email.

--_000_18dd8eb6f2ee414195c87d0117c9e9dcN111XMB0239skhmscom_
Content-Type: text/html; charset=WINDOWS-1252
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
=09{font-family:"Cambria Math";
=09panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
=09{font-family:Calibri;
=09panose-1:2 15 5 2 2 2 4 3 2 4;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
=09{margin:0in;
=09margin-bottom:.0001pt;
=09font-size:12.0pt;
=09font-family:"Times New Roman","serif";}
a:link, span.MsoHyperlink
=09{mso-style-priority:99;
=09color:#0563C1;
=09text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
=09{mso-style-priority:99;
=09color:#954F72;
=09text-decoration:underline;}
p
=09{mso-style-priority:99;
=09margin:0in;
=09margin-bottom:.0001pt;
=09font-size:12.0pt;
=09font-family:"Times New Roman","serif";}
span.EmailStyle18
=09{mso-style-type:personal-reply;
=09font-family:"Calibri","sans-serif";
=09color:#1F497D;}
.MsoChpDefault
=09{mso-style-type:export-only;
=09font-size:10.0pt;}
@page WordSection1
=09{size:8.5in 11.0in;
=09margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
=09{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body bgcolor=3D"white" lang=3D"EN-US" link=3D"#0563C1" vlink=3D"#954F72">
<div class=3D"WordSection1">
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Hi,<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">I am writing to report a possible* bug on:
<o:p></o:p></span></p>
<p><span style=3D"font-size:11.0pt;font-family:&quot;Calibri&quot;,&quot;sa=
ns-serif&quot;;color:#1F497D"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black;background:yellow">fio version - 3.1</span><span style=3D"font-fa=
mily:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black"><o:p></o:p></s=
pan></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black;background:yellow">Operating System - CentOS &nbsp;7.6.1810
</span><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot=
;;color:black"><o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black;background:yellow">kernel: 3.10.0-957.1.3.el7.x86_64</span><span =
style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;color:black=
"><o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">I use a HP Proliant Enterprise Server hardware to run the metric=
s<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Bug: In some of the runs, the max value of completion latency (c=
lat) is lesser than the 9-nines percentile value. How is this possible? I h=
ave marked the numbers in red below. Kindly take a look.<o:p></o:p></span><=
/p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">________________________________________________________________=
____________<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Workload:<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">sudo chrt -f 1 fio&nbsp; --filename=3D/dev/nvme0n1 --numjobs=3D1=
 --iodepth=3D512 --offset=3D0M --bs=3D<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">7681501126656 --size=3D<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">7681501126656 --io_size=3D%s --rw=3Dread --buffered=3D0 --thread=
 --time_based --runtime=3D60 --name=3Dseqtest0 --group_reporting --disable_=
lat=3D1 --disable_slat=3D1 --disable_bw_measurement=3D1 --zero_buffers
 --ioengine=3Dlibaio --percentile=3D99:99.9:99.99:99.999:99.9999:99.99999:9=
9.999999:99.9999999 --output-format=3Djson,normal --eta=3Dnever --invalidat=
e=3D1 --end_fsync=3D0 --refill_buffers<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">________________________________________________________________=
____________<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Result:<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">seqtest0: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3908: Tue Feb=
 26 18:02:25 2019<br>
&nbsp;&nbsp; read: IOPS=3D25.1k, BW=3D3135MiB/s (3287MB/s)(184GiB/60021msec=
)<br>
&nbsp;&nbsp;&nbsp; clat (usec): min=3D16426, max=3D<span style=3D"backgroun=
d:red">41005</span>, avg=3D20384.67, stdev=3D337.20<br>
&nbsp;&nbsp;&nbsp; clat percentiles (usec):<br>
&nbsp;&nbsp;&nbsp;&nbsp; | 99.0000000th=3D[20579], 99.9000000th=3D[21103], =
99.9900000th=3D[38011],<br>
&nbsp;&nbsp;&nbsp;&nbsp; | 99.9990000th=3D[40633], 99.9999000th=3D[41157], =
99.9999900th=3D[41157],<br>
&nbsp;&nbsp;&nbsp;&nbsp; | 99.9999990th=3D[41157], 99.9999999th=3D[<span st=
yle=3D"background:red">41157</span>]<br>
&nbsp;&nbsp; bw (&nbsp; MiB/s): min=3D 2981, max=3D 3144, per=3D100.00%, av=
g=3D3135.58, stdev=3D14.46, samples=3D120<br>
&nbsp;&nbsp; iops&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : min=3D23848, =
max=3D25154, avg=3D25084.63, stdev=3D115.65, samples=3D120<br>
&nbsp; lat (msec)&nbsp;&nbsp; : 20=3D0.31%, 50=3D99.69%<br>
&nbsp; cpu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; : usr=3D4.=
10%, sys=3D64.00%, ctx=3D742962, majf=3D0, minf=3D44<br>
&nbsp; IO depths&nbsp;&nbsp;&nbsp; : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%=
, 16=3D0.1%, 32=3D0.1%, &gt;=3D64=3D100.0%<br>
&nbsp;&nbsp;&nbsp;&nbsp; submit&nbsp;&nbsp;&nbsp; : 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%<br>
&nbsp;&nbsp;&nbsp;&nbsp; complete&nbsp; : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.1%<br>
&nbsp;&nbsp;&nbsp;&nbsp; issued rwt: total=3D1505214,0,0, short=3D0,0,0, dr=
opped=3D0,0,0<br>
&nbsp;&nbsp;&nbsp;&nbsp; latency&nbsp;&nbsp; : target=3D0, window=3D0, perc=
entile=3D100.00%, depth=3D512<br>
<br>
Run status group 0 (all jobs):<br>
&nbsp;&nbsp; READ: bw=3D3135MiB/s (3287MB/s), 3135MiB/s-3135MiB/s (3287MB/s=
-3287MB/s), io=3D184GiB (197GB), run=3D60021-60021msec<o:p></o:p></span></p=
>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">________________________________________________________________=
____________<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Any inputs/help will be greatly appreciated.<o:p></o:p></span></=
p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black">Thanks in advance!<o:p></o:p></span></p>
<p><span style=3D"font-family:&quot;Calibri&quot;,&quot;sans-serif&quot;;co=
lor:black"><o:p>&nbsp;</o:p></span></p>
</div>
The information contained in this e-mail is considered confidential of SK h=
ynix memory solutions America Inc. and intended only for the persons addres=
sed or copied in this e-mail. Any unauthorized use, dissemination of the in=
formation, or copying of this message
 is strictly prohibited. If you are not the intended recipient, please cont=
act the sender immediately and permanently delete the original and any copi=
es of this email.
</body>
</html>

--_000_18dd8eb6f2ee414195c87d0117c9e9dcN111XMB0239skhmscom_--


