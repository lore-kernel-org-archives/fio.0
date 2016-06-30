Return-Path: <Vincent.Fu@sandisk.com>
From: Vincent Fu <Vincent.Fu@sandisk.com>
Subject: terminating fio jobs upon reaching steady state
Date: Thu, 30 Jun 2016 15:49:35 +0000
Message-ID: <CY1PR0201MB1882D39478B9483993B429488C240@CY1PR0201MB1882.namprd02.prod.outlook.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CY1PR0201MB1882D39478B9483993B429488C240CY1PR0201MB1882_"
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_000_CY1PR0201MB1882D39478B9483993B429488C240CY1PR0201MB1882_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Jens, I have been working on a patch to give fio the ability to terminate a=
 job when steady state is attained. I have a crude implementation that is w=
orking at https://bitbucket.org/vincentfu/fio/commits/all but I'm hoping to=
 receive some feedback on its design.

Currently, the feature works via helper_thread_main(). It collects data in =
a ring buffer for a specified duration and carries out the termination test=
 when the ring buffer is full. If the test passes, the job terminates. If t=
he test fails, the job continues, the oldest data point in the buffer is dr=
opped, a new data point is added, and the termination test is carried out a=
gain. The cycle repeats until the job terminates because steady state was a=
ttained or for other reasons.

Reporting of results is done via JSON output and includes per second IOPS/B=
W measurements from the ring buffer.

Three new job options control this feature:

ss_dur =3D size of the ring buffer used for termination test. Data points a=
re collected once per second.

ss_ramp =3D ramp time once job is underway before data collection begins (t=
o avoid false positives detecting steady state for jobs run on freshly form=
atted SSDs)

ss =3D criterion:limit

criterion is one of iops, bw, iops_ slope, bw_slope

iops, bw                        terminate the job when the all data points =
in the buffer are within the specified limit of the mean

iops_slope, bw_slope    terminate the job when the magnitude of the least s=
quares slope falls below the specified limit

limit can be either a fixed number or a percentage. ss=3Diops:10 will termi=
nate the job when all IOPS values in the buffer are within 10 of the mean. =
ss=3Dbw_slope:0.01% will terminate the job when the least squares slope fal=
ls below 0.01% of the mean bandwidth in the buffer.

This command:

./fio --name=3Dtest --rw=3Drandrw --rwmixread=3D100 --filename=3Dfio --time=
_based --runtime=3D30s --ss_dur=3D10 --ss_ramp=3D3 --ss=3Diops:10000 --outp=
ut-format=3Djson

results in something like this:

 "steadystate" : {
        "ss" : "iops:10000.000000",
        "duration" : 10,
        "steadystate_ramptime" : 3,
        "attained" : 1,
        "criterion" : 9664.599609,
        "data" : [
          613354,
          624473,
          623099,
          617032,
          617280,
          614679,
          607775,
          620743,
          617561,
          618400
        ] }


I'm wondering how important are the following requirements?

1) Full bandwidth/IOPS series for the entire runtime

I can imagine a use case where a user would want to see how the device beha=
ves as it approaches steady state, in addition to the behavior of the devic=
e while it is in steady state. Right now the patch only reports IOPS/BW dat=
a from the ring buffer that was used for testing the termination criterion.

2) Ability to report latency data for the steady state period

An obvious use case is to run a workload in steady state for a long duratio=
n and then report its latency distribution. The only way I can imagine to h=
ave this feature provide latency data is to maintain a ring buffer of io_u_=
plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] arrays, one for each thread. Then th=
e latency distribution for the steady state period will be the difference b=
etween the overall final latency distribution and the distribution at the h=
ead of the ring buffer. The disadvantage of this approach is high memory co=
nsumption. A work-around is to have one job use this feature to drive the d=
evice to steady state and then follow up with a second time-based identical=
 follow-up job for latency data collection, although there will be no guara=
ntee that the second job will meet the steady state criterion.

3) How should this interact with group_reporting?

Since reporting will be for the entire group, it seems sensible to have ste=
ady state detection operate at the group level, with BW and IOPS values sum=
med over all threads in a group and all threads in a group terminating when=
 steady state is attained.


Vincent

--
Vincent Fu
Software Dev Engr II
SanDisk | a Western Digital brand
Remote Worker, Rockville, MD, USA
T: 801 987 7079
Vincent.Fu@SanDisk.com<mailto:Vincent.Fu@SanDisk.com>

PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this message in error and that any review, disse=
mination, distribution, or copying of this message is strictly prohibited. =
If you have received this communication in error, please notify the sender =
by telephone or e-mail (as shown above) immediately and destroy any and all=
 copies of this message in your possession (whether hard copies or electron=
ically stored copies).

--_000_CY1PR0201MB1882D39478B9483993B429488C240CY1PR0201MB1882_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
</head>
<body bgcolor=3D"#FFFFFF" text=3D"#000000">
<p>Jens, I have been working on a patch to give fio the ability to terminat=
e a job when steady state is attained. I have a crude implementation that i=
s working at
<a class=3D"moz-txt-link-freetext" href=3D"https://bitbucket.org/vincentfu/=
fio/commits/all">
https://bitbucket.org/vincentfu/fio/commits/all</a> but I'm hoping to recei=
ve some feedback on its design.</p>
<p>Currently, the feature works via helper_thread_main(). It collects data =
in a ring buffer for a specified duration and carries out the termination t=
est when the ring buffer is full. If the test passes, the job terminates. I=
f the test fails, the job continues,
 the oldest data point in the buffer is dropped, a new data point is added,=
 and the termination test is carried out again. The cycle repeats until the=
 job terminates because steady state was attained or for other reasons.</p>
<p>Reporting of results is done via JSON output and includes per second IOP=
S/BW measurements from the ring buffer.</p>
<p>Three new job options control this feature:</p>
<p>ss_dur =3D size of the ring buffer used for termination test. Data point=
s are collected once per second.</p>
<p>ss_ramp =3D ramp time once job is underway before data collection begins=
 (to avoid false positives detecting steady state for jobs run on freshly f=
ormatted SSDs)<br>
</p>
<p>ss =3D criterion:limit</p>
<p>criterion is one of iops, bw, iops_ slope, bw_slope</p>
<p>iops, bw&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&=
nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; terminate the job when th=
e all data points in the buffer are within the specified limit of the mean<=
/p>
<p>iops_slope, bw_slope&nbsp;&nbsp;&nbsp; terminate the job when the magnit=
ude of the least squares slope falls below the specified limit</p>
<p>limit can be either a fixed number or a percentage. ss=3Diops:10 will te=
rminate the job when all IOPS values in the buffer are within 10 of the mea=
n. ss=3Dbw_slope:0.01% will terminate the job when the least squares slope =
falls below 0.01% of the mean bandwidth
 in the buffer.</p>
<p>This command:</p>
<p>./fio --name=3Dtest --rw=3Drandrw --rwmixread=3D100 --filename=3Dfio --t=
ime_based --runtime=3D30s --ss_dur=3D10 --ss_ramp=3D3 --ss=3Diops:10000 --o=
utput-format=3Djson</p>
results in something like this:<br>
<p></p>
<p>&nbsp;&quot;steadystate&quot; : {<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;ss&quot; : &quot;iops:1000=
0.000000&quot;,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;duration&quot; : 10,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;steadystate_ramptime&quot;=
 : 3,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;attained&quot; : 1,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;criterion&quot; : 9664.599=
609,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &quot;data&quot; : [<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 613354,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 624473,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 623099,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 617032,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 617280,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 614679,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 607775,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 620743,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 617561,<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 618400<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ] }<br>
</p>
<p><br>
</p>
<p>I'm wondering how important are the following requirements?</p>
<p>1) Full bandwidth/IOPS series for the entire runtime</p>
<p>I can imagine a use case where a user would want to see how the device b=
ehaves as it approaches steady state, in addition to the behavior of the de=
vice while it is in steady state. Right now the patch only reports IOPS/BW =
data from the ring buffer that was
 used for testing the termination criterion.<br>
</p>
<p>2) Ability to report latency data for the steady state period</p>
<p>An obvious use case is to run a workload in steady state for a long dura=
tion and then report its latency distribution. The only way I can imagine t=
o have this feature provide latency data is to maintain a ring buffer of io=
_u_plat[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR]
 arrays, one for each thread. Then the latency distribution for the steady =
state period will be the difference between the overall final latency distr=
ibution and the distribution at the head of the ring buffer. The disadvanta=
ge of this approach is high memory
 consumption. A work-around is to have one job use this feature to drive th=
e device to steady state and then follow up with a second time-based identi=
cal follow-up job for latency data collection, although there will be no gu=
arantee that the second job will
 meet the steady state criterion. </p>
<p>3) How should this interact with group_reporting?</p>
<p>Since reporting will be for the entire group, it seems sensible to have =
steady state detection operate at the group level, with BW and IOPS values =
summed over all threads in a group and all threads in a group terminating w=
hen steady state is attained.</p>
<p><br>
</p>
<p>Vincent<br>
</p>
<pre class=3D"moz-signature" cols=3D"72">-- =0A=
Vincent Fu=0A=
Software Dev Engr II=0A=
SanDisk | a Western Digital brand=0A=
Remote Worker, Rockville, MD, USA=0A=
T: 801 987 7079=0A=
<a class=3D"moz-txt-link-abbreviated" href=3D"mailto:Vincent.Fu@SanDisk.com=
">Vincent.Fu@SanDisk.com</a></pre>
PLEASE NOTE: The information contained in this electronic mail message is i=
ntended only for the use of the designated recipient(s) named above. If the=
 reader of this message is not the intended recipient, you are hereby notif=
ied that you have received this
 message in error and that any review, dissemination, distribution, or copy=
ing of this message is strictly prohibited. If you have received this commu=
nication in error, please notify the sender by telephone or e-mail (as show=
n above) immediately and destroy
 any and all copies of this message in your possession (whether hard copies=
 or electronically stored copies).
</body>
</html>

--_000_CY1PR0201MB1882D39478B9483993B429488C240CY1PR0201MB1882_--

