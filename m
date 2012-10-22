Return-Path: <lakshmipriya.teekeyan@gmail.com>
MIME-Version: 1.0
From: Lakshmipriya Teekeyan <lakshmipriya.teekeyan@gmail.com>
Date: Mon, 22 Oct 2012 14:06:01 -0600
Subject: Re: Errors while running FIO
Message-ID: 
 <CANcZX_QD4OAQqYUUuLyo+YNrHRZah=2o9S7=dXYH62zuUkhvUg@mail.gmail.com>
References: 
 <CANcZX_TT=1tV_ZBL-7Efi_zKG6t6AHgu8Whfs97dyDXj2htgNw@mail.gmail.com>
	<5082E328.30500@fusionio.com>
In-Reply-To: <5082E328.30500@fusionio.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CANcZXQD4OAQqYUUuLyoYNrHRZah2o9S7dXYH62zuUkhvUgmailgmai_"
To: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_000_CANcZXQD4OAQqYUUuLyoYNrHRZah2o9S7dXYH62zuUkhvUgmailgmai_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Jens,

  I am running fio on a windows share.
The version is fio-2.0.9.

A small subset of job file is given below:

[exawritedir2]
rw=3Dwrite
ioengine=3Dsync
bs=3D16k
size=3D20g
nrfiles=3D20
scramble_buffers=3D1
overwrite=3D0
verify=3Dsha1
directory=3DW:/Write2
thread
stonewall

Thanks,
Lakshmi
On Sat, Oct 20, 2012 at 10:45 AM, Jens Axboe <jaxboe@fusionio.com<mailto:ja=
xboe@fusionio.com>> wrote:
On 2012-10-20 01:51, Lakshmipriya Teekeyan wrote:
> Hello Jens,
>
>   I am a newbie in FIO. I was running FIO to create 3 dirs with 20 files =
each of 1GB size.
>
> I am getting the following errors:
>
> fio: pid=3D5808, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=3DIn=
valid argument
>
> fio: pid=3D7976, err=3D22/file:filesetup.c:534, func=3Dopen(W:/Write2/exa=
writedir2.2.0
> ), error=3DInvalid argument
>
> fio: pid=3D5668, err=3D22/file:filesetup.c:534, func=3Dopen(W:/Write1/exa=
writedir1.1.0
> ), error=3DInvalid argument
>
>
> Can you please take a look and let me know what went wrong?

Some problem with O_DIRECT? You should include the fio version and job
file when writing a report, and also CC fio@vger.kernel.org<mailto:fio@vger=
.kernel.org>. See the
REPORTING-BUGS file included with fio.

--
Jens Axboe



--_000_CANcZXQD4OAQqYUUuLyoYNrHRZah2o9S7dXYH62zuUkhvUgmailgmai_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<div>Jens, </div><div>=A0</div><div>=A0 I am running fio on a windows share=
. </div><div>The version is fio-2.0.9. </div><div>=A0</div><div>A small sub=
set of job file is given below:</div><div>=A0</div><div>[exawritedir2]<br>r=
w=3Dwrite <br>
ioengine=3Dsync<br>bs=3D16k<br>size=3D20g<br>nrfiles=3D20<br>scramble_buffe=
rs=3D1<br>overwrite=3D0<br>verify=3Dsha1<br>directory=3DW:/Write2<br>thread=
<br>stonewall</div><div>=A0</div><div>Thanks,</div><div>Lakshmi<br></div><d=
iv class=3D"gmail_quote">
On Sat, Oct 20, 2012 at 10:45 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jaxboe@fusionio.com" target=3D"_blank">jaxboe@fusionio.com</a>&g=
t;</span> wrote:<br><blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-l=
eft:1ex;border-left-color:rgb(204,204,204);border-left-width:1px;border-lef=
t-style:solid" class=3D"gmail_quote">
<div class=3D"HOEnZb"><div class=3D"h5">On 2012-10-20 01:51, Lakshmipriya T=
eekeyan wrote:<br>
&gt; Hello Jens,<br>
&gt;<br>
&gt; =A0 I am a newbie in FIO. I was running FIO to create 3 dirs with 20 f=
iles each of 1GB size.<br>
&gt;<br>
&gt; I am getting the following errors:<br>
&gt;<br>
&gt; fio: pid=3D5808, err=3D22/file:engines/sync.c:62, func=3Dxfer, error=
=3DInvalid argument<br>
&gt;<br>
&gt; fio: pid=3D7976, err=3D22/file:filesetup.c:534, func=3Dopen(W:/Write2/=
exawritedir2.2.0<br>
&gt; ), error=3DInvalid argument<br>
&gt;<br>
&gt; fio: pid=3D5668, err=3D22/file:filesetup.c:534, func=3Dopen(W:/Write1/=
exawritedir1.1.0<br>
&gt; ), error=3DInvalid argument<br>
&gt;<br>
&gt;<br>
&gt; Can you please take a look and let me know what went wrong?<br>
<br>
</div></div>Some problem with O_DIRECT? You should include the fio version =
and job<br>
file when writing a report, and also CC <a href=3D"mailto:fio@vger.kernel.o=
rg">fio@vger.kernel.org</a>. See the<br>
REPORTING-BUGS file included with fio.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br>

--_000_CANcZXQD4OAQqYUUuLyoYNrHRZah2o9S7dXYH62zuUkhvUgmailgmai_--


