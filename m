Return-Path: <brianclam@gmail.com>
MIME-Version: 1.0
Date: Thu, 05 Sep 2013 12:56:11 -0700 (PDT)
Message-Id: <1378410970250.8ab05bfc@Nodemailer>
In-Reply-To: <5228DDC8.9070201@kernel.dk>
References: <5228DDC8.9070201@kernel.dk>
From: "Brian Lam" <brianclam@gmail.com>
Subject: Re: Invalid argument error (EINVAL) on Lustre filesystem with
 ioengine=libaio enabled
Content-Type: multipart/alternative;
 boundary="----Nodemailer-0.5.0-?=_1-1378410971352"
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Juergen Salk <juergen.salk@uni-ulm.de>
List-ID: <fio@vger.kernel.org>

------Nodemailer-0.5.0-?=_1-1378410971352
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

I experienced an error when trying to use libaio on local disks. I will =
check when I get back to my desk to see if it is similiar to your errors. =
=C2=A0I vaguely remember getting a segfault so I am not sure if they are =
related.=C2=A0

    =E2=80=94
Sent from Mailbox for iPhone

On Thu, Sep 5, 2013 at 12:39 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 09/05/2013 09:15 AM, Juergen Salk wrote:
>> Hi,
>>=20
>> I tried to run fio on a Lustre filesystem with ioengine=3Dlibaio =
enabled:
>>=20
>> $ ../tools/fio/2.1.2/bin/fio seqwrite.fio=20
>> sequential=5Fwrite: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, =
ioengine=3Dlibaio, iodepth=3D32
>> fio-2.1.2
>> Starting 1 process
>> fio: pid=3D31956, err=3D22/file:ioengines.c:381, func=3Dio commit, =
error=3DInvalid argument
>>=20
>> sequential=5Fwrite: (groupid=3D0, jobs=3D1): err=3D22 (file:ioengines.=
c:381, func=3Dio commit, error=3DInvalid argument): pid=3D31956: Thu Sep  5=
 16:43:56 2013
>>   cpu          : usr=3D0.00%, sys=3D100.00%, ctx=3D23, majf=3D0, =
minf=3D49
>>   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%, >=3D64=3D0.0%
>>      submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>      complete  : 0=3D100.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>>      issued    : total=3Dr=3D0/w=3D1/d=3D0, short=3Dr=3D0/w=3D0/d=3D0
>>=20
>> Run status group 0 (all jobs):
>>=20
>> This is the content of the job file:
>>=20
>> --- snip ---
>>=20
>> [global]
>> ioengine=3Dlibaio
>> # ioengine=3Dsync
>> iodepth=3D32
>> direct=3D1
>> invalidate=3D1
>> filename=5Fformat=3Dfile.$jobnum
>> group=5Freporting
>> bs=3D1024k
>> size=3D1g
>> numjobs=3D1
>> directory=3D/scratch1/ws/jsalk-bench-0
>>=20
>> [sequential=5Fwrite]
>> rw=3Dwrite
>>=20
>> --- snip ---
>>=20
>> It works with ioengine=3Dsync, though. It also works on the same =
machine
>> with ioengine=3Dlibaio enabled but with the work directory located on a
>> locally attached disk (with ext3 file system).
>>=20
>> An strace log is attached. Are there any ideas of what might be
>> causing this problem on Lustre=3F
> I'm guessing that lustre doesn't support async IO, though I have never
> tried it myself. From the error out of fio and the strace, io=5Fsubmit()
> is returning EINVAL. The context id is valid, fio is submitting 1 iocb,
> and the opcode is a read operation on fd 3 - all of which are good.
> --=20
> Jens Axboe
> --
> To unsubscribe from this list: send the line =22unsubscribe fio=22 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.=
html
------Nodemailer-0.5.0-?=_1-1378410971352
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable


    <div>I experienced an error when trying to use libaio on local disks. I=
 will check when I get back to my desk to see if it is similiar to your =
errors. =C2=A0I vaguely remember getting a segfault so I am not sure if =
they are related.=C2=A0</div>
    <div class=3D=22mailbox=5Fsignature=22>=E2=80=94<br>Sent from <a =
href=3D=22https://www.dropbox.com/mailbox=22>Mailbox</a> for iPhone</div>
  <br><br><div class=3D=22gmail=5Fquote=22><p>On Thu, Sep 5, 2013 at 12:39 =
PM, Jens Axboe <span dir=3D=22ltr=22>&lt;<a href=3D=22mailto:axboe@kernel.=
dk=22 target=3D=22=5Fblank=22>axboe@kernel.dk</a>&gt;</span> =
wrote:<br></p><blockquote class=3D=22gmail=5Fquote=22 style=3D=22margin:0 0=
 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;=22><p>On 09/05/2013 =
09:15 AM, Juergen Salk wrote:
<br>&gt; Hi,
<br>&gt;=20
<br>&gt; I tried to run fio on a Lustre filesystem with ioengine=3Dlibaio =
enabled:
<br>&gt;=20
<br>&gt; $ ../tools/fio/2.1.2/bin/fio seqwrite.fio=20
<br>&gt; sequential=5Fwrite: (g=3D0): rw=3Dwrite, bs=3D1M-1M/1M-1M/1M-1M, =
ioengine=3Dlibaio, iodepth=3D32
<br>&gt; fio-2.1.2
<br>&gt; Starting 1 process
<br>&gt; fio: pid=3D31956, err=3D22/file:ioengines.c:381, func=3Dio commit,=
 error=3DInvalid argument
<br>&gt;=20
<br>&gt; sequential=5Fwrite: (groupid=3D0, jobs=3D1): err=3D22 =
(file:ioengines.c:381, func=3Dio commit, error=3DInvalid argument): =
pid=3D31956: Thu Sep  5 16:43:56 2013
<br>&gt;   cpu          : usr=3D0.00%, sys=3D100.00%, ctx=3D23, majf=3D0, =
minf=3D49
<br>&gt;   IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.=
0%, 32=3D0.0%, &gt;=3D64=3D0.0%
<br>&gt;      submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, 64=3D0.0%, &gt;=3D64=3D0.0%
<br>&gt;      complete  : 0=3D100.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0=
.0%, 64=3D0.0%, &gt;=3D64=3D0.0%
<br>&gt;      issued    : total=3Dr=3D0/w=3D1/d=3D0, =
short=3Dr=3D0/w=3D0/d=3D0
<br>&gt;=20
<br>&gt; Run status group 0 (all jobs):
<br>&gt;=20
<br>&gt; This is the content of the job file:
<br>&gt;=20
<br>&gt; --- snip ---
<br>&gt;=20
<br>&gt; [global]
<br>&gt; ioengine=3Dlibaio
<br>&gt; # ioengine=3Dsync
<br>&gt; iodepth=3D32
<br>&gt; direct=3D1
<br>&gt; invalidate=3D1
<br>&gt; filename=5Fformat=3Dfile.$jobnum
<br>&gt; group=5Freporting
<br>&gt; bs=3D1024k
<br>&gt; size=3D1g
<br>&gt; numjobs=3D1
<br>&gt; directory=3D/scratch1/ws/jsalk-bench-0
<br>&gt;=20
<br>&gt; [sequential=5Fwrite]
<br>&gt; rw=3Dwrite
<br>&gt;=20
<br>&gt; --- snip ---
<br>&gt;=20
<br>&gt; It works with ioengine=3Dsync, though. It also works on the same =
machine
<br>&gt; with ioengine=3Dlibaio enabled but with the work directory located=
 on a
<br>&gt; locally attached disk (with ext3 file system).
<br>&gt;=20
<br>&gt; An strace log is attached. Are there any ideas of what might be
<br>&gt; causing this problem on Lustre=3F
<br><br>I'm guessing that lustre doesn't support async IO, though I have =
never
<br>tried it myself. From the error out of fio and the strace, =
io=5Fsubmit()
<br>is returning EINVAL. The context id is valid, fio is submitting 1 iocb,=

<br>and the opcode is a read operation on fd 3 - all of which are good.
<br><br>--=20
<br>Jens Axboe
<br><br>--
<br>To unsubscribe from this list: send the line =22unsubscribe fio=22 in
<br>the body of a message to majordomo@vger.kernel.org
<br>More majordomo info at  http://vger.kernel.org/majordomo-info.html
<br></p></blockquote></div><br>
------Nodemailer-0.5.0-?=_1-1378410971352--


