Return-Path: <sendtold@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAEyTGCfpBS1jE09EkGVFyMU5mn4Rtpt6aozdyyid2bxke+QvVQ@mail.gmail.com>
References: <CAEyTGCfpBS1jE09EkGVFyMU5mn4Rtpt6aozdyyid2bxke+QvVQ@mail.gmail.com>
Date: Wed, 17 Dec 2014 17:46:03 -0600
Message-ID: <CAEyTGCc1W7J60WXQ3uLFHxpsV-pM3tbqWPxTzjWWUcLgHyd8wg@mail.gmail.com>
Subject: Fwd: Huge eta with R/W mix job and job hangs
From: Lakshmi <sendtold@gmail.com>
Content-Type: multipart/alternative; boundary=047d7bfd029221127a050a721428
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--047d7bfd029221127a050a721428
Content-Type: text/plain; charset=UTF-8

Hi Jens,
 I am using the latest version of fio 2.1.10

Thanks
ld
---------- Forwarded message ----------
From: Lakshmi <sendtold@gmail.com>
Date: Wed, Dec 17, 2014 at 2:27 PM
Subject: Huge eta with R/W mix job and job hangs
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi Jens,
  I am using the below job file, and this works fine when the numjobs
is less(ex: 5,10) however when I specify a huge numjobs , the job
hangs and shows a huge eta as shown below.

# fio FIO_Test.job
test: (g=0): rw=randrw, bs=71K-71K/20K-20K/20K-20K, ioengine=posixaio,
iodepth=32
...
fio-2.1.10
Starting 20 processes
Killed1 (f=1): [__________________m_] [0.0% done] [0KB/0KB/0KB /s]
[0/0/0 iops] [eta 1158050441d:06h:50m:07s]


When I just run a 100% Reads (71K) or 100% writes(20K) separately
with the below below parameters it works fine, but it is only when i
do a mix of reads and writes.

Any idea what is going on and if i am missing something?
OS:RHEL7
HDDs(sdf):2x300GB Hdds on RAID10

[test]
 name=test
 ioengine=posixaio
 invalidate=1
 iodepth=32
 bs=71K,20K
 group_reporting=1
 rw=randrw
 rwmixread=96
 rwmixwrite=4
 direct=1
 buffered=0
 size=1M
 time_based
 runtime=300
 filename=/dev/sdf
 numjobs=64

Please help!!
Thanks

--047d7bfd029221127a050a721428
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div>Hi Jens,<br></div>=C2=A0I am using the late=
st version of fio 2.1.10<br><br></div>Thanks<br></div>ld<br><div><div><div>=
<div><div class=3D"gmail_quote">---------- Forwarded message ----------<br>=
From: <b class=3D"gmail_sendername">Lakshmi</b> <span dir=3D"ltr">&lt;<a hr=
ef=3D"mailto:sendtold@gmail.com">sendtold@gmail.com</a>&gt;</span><br>Date:=
 Wed, Dec 17, 2014 at 2:27 PM<br>Subject: Huge eta with R/W mix job and job=
 hangs<br>To: &quot;<a href=3D"mailto:fio@vger.kernel.org">fio@vger.kernel.=
org</a>&quot; &lt;<a href=3D"mailto:fio@vger.kernel.org">fio@vger.kernel.or=
g</a>&gt;<br><br>Hi Jens,<br>
=C2=A0 I am using the below job file, and this works fine when the numjobs<=
br>
is less(ex: 5,10) however when I specify a huge numjobs , the job<br>
hangs and shows a huge eta as shown below.<br>
<br>
# fio FIO_Test.job<br>
test: (g=3D0): rw=3Drandrw, bs=3D71K-71K/20K-20K/20K-20K, ioengine=3Dposixa=
io,<br>
iodepth=3D32<br>
...<br>
fio-2.1.10<br>
Starting 20 processes<br>
Killed1 (f=3D1): [__________________m_] [0.0% done] [0KB/0KB/0KB /s]<br>
[0/0/0 iops] [eta 1158050441d:06h:50m:07s]<br>
<br>
<br>
When I just run a 100% Reads (71K) or 100% writes(20K) separately<br>
with the below below parameters it works fine, but it is only when i<br>
do a mix of reads and writes.<br>
<br>
Any idea what is going on and if i am missing something?<br>
OS:RHEL7<br>
HDDs(sdf):2x300GB Hdds on RAID10<br>
<br>
[test]<br>
=C2=A0name=3Dtest<br>
=C2=A0ioengine=3Dposixaio<br>
=C2=A0invalidate=3D1<br>
=C2=A0iodepth=3D32<br>
=C2=A0bs=3D71K,20K<br>
=C2=A0group_reporting=3D1<br>
=C2=A0rw=3Drandrw<br>
=C2=A0rwmixread=3D96<br>
=C2=A0rwmixwrite=3D4<br>
=C2=A0direct=3D1<br>
=C2=A0buffered=3D0<br>
=C2=A0size=3D1M<br>
=C2=A0time_based<br>
=C2=A0runtime=3D300<br>
=C2=A0filename=3D/dev/sdf<br>
=C2=A0numjobs=3D64<br>
<br>
Please help!!<br>
Thanks<br>
</div></div></div></div></div></div>

--047d7bfd029221127a050a721428--

