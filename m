Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
Date: Fri, 4 Dec 2015 15:28:35 -0600
Message-ID: <CAEyTGCcRHC6_D7n8aCs_tEqJMTLigZp-dDVzAtk8mEw0sD1V9A@mail.gmail.com>
Subject: blkparse gives bad trace magic 7746165
From: Lakshmi <sendtold@gmail.com>
Content-Type: multipart/alternative; boundary=001a114526be9ee82a0526193052
To: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

--001a114526be9ee82a0526193052
Content-Type: text/plain; charset=UTF-8

Hi all,
   I ran the below blktrace command and collected the trace for 4 devices
and there were 80 blktrace.bin files created for each device and there were
a total of 1120 .bin files.

blktrace -d /dev/sda /dev/sdb /dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdq
/dev/sdp /dev/sds /dev/sdr /dev/sdt /dev/sdw /dev/sdv /dev/sdu -w 900 -a
write -a read -b 8192

I tried doing  a blkparse on these binary files using below command
blkparse -i ./*.blktrace.0 -d ./bp.bin -o bp.txt -w 0:900

and I get

bad trace magic 7746165
Input file ./sdw.blktrace.19 added
bad trace magic 7746165
Input file ./sdw.blktrace.20 added
bad trace magic 7746165
Input file ./sdw.blktrace.21 added
..........

for all of the files.

Did I miss something while collecting the trace ? I am not able to figure
out and there is not much information available online too.

If any of you have faced similar issue, please suggest your ideas.

Thanks
Ld

--001a114526be9ee82a0526193052
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div><div><div><div><div>Hi all,<br></div>=
=C2=A0=C2=A0 I ran the below blktrace command and collected the trace for 4=
 devices and there were 80 blktrace.bin files created for each device and t=
here were a total of 1120 .bin files.<br><br>blktrace -d /dev/sda /dev/sdb =
/dev/sdl /dev/sdm /dev/sdn /dev/sdo /dev/sdq /dev/sdp /dev/sds /dev/sdr /de=
v/sdt /dev/sdw /dev/sdv /dev/sdu -w 900 -a write -a read -b 8192 <br><br></=
div>I tried doing=C2=A0 a blkparse on these binary files using below comman=
d<br>blkparse -i ./*.blktrace.0 -d ./bp.bin -o bp.txt -w 0:900<br><br></div=
>and I get <br><br>bad trace magic 7746165<br>Input file ./sdw.blktrace.19 =
added<br>bad trace magic 7746165<br>Input file ./sdw.blktrace.20 added<br>b=
ad trace magic 7746165<br>Input file ./sdw.blktrace.21 added<br>..........<=
br><br></div>for all of the files.<br><br></div>Did I miss something while =
collecting the trace ? I am not able to figure out and there is not much in=
formation available online too.<br><br></div>If any of you have faced simil=
ar issue, please suggest your ideas.<br><br></div>Thanks<br></div>Ld<br></d=
iv>

--001a114526be9ee82a0526193052--

