Return-Path: <lakshmipriya.teekeyan@gmail.com>
MIME-Version: 1.0
From: Lakshmipriya Teekeyan <lakshmipriya.teekeyan@gmail.com>
Date: Mon, 22 Oct 2012 14:07:01 -0600
Subject: Fwd: Errors while running FIO
Message-ID: 
 <CANcZX_QdEWr0j+1=m4HL8UPy8j=GaVfGzpiVbhTEHL77D8YgbA@mail.gmail.com>
References: 
 <CANcZX_TT=1tV_ZBL-7Efi_zKG6t6AHgu8Whfs97dyDXj2htgNw@mail.gmail.com>
	<5082E328.30500@fusionio.com>
	<CANcZX_QD4OAQqYUUuLyo+YNrHRZah=2o9S7=dXYH62zuUkhvUg@mail.gmail.com>
In-Reply-To: 
 <CANcZX_QD4OAQqYUUuLyo+YNrHRZah=2o9S7=dXYH62zuUkhvUg@mail.gmail.com>
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_CANcZXQdEWr0j1m4HL8UPy8jGaVfGzpiVbhTEHL77D8YgbAmailgmai_"
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--_000_CANcZXQdEWr0j1m4HL8UPy8jGaVfGzpiVbhTEHL77D8YgbAmailgmai_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable



---------- Forwarded message ----------
From: Lakshmipriya Teekeyan <lakshmipriya.teekeyan@gmail.com<mailto:lakshmi=
priya.teekeyan@gmail.com>>
Date: Mon, Oct 22, 2012 at 1:06 PM
Subject: Re: Errors while running FIO
To: Jens Axboe <jaxboe@fusionio.com<mailto:jaxboe@fusionio.com>>, fio@vger.=
kernel.org<mailto:fio@vger.kernel.org>


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




--_000_CANcZXQdEWr0j1m4HL8UPy8jGaVfGzpiVbhTEHL77D8YgbAmailgmai_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<br><br><div class=3D"gmail_quote">---------- Forwarded message ----------<=
br>From: <b class=3D"gmail_sendername">Lakshmipriya Teekeyan</b> <span dir=
=3D"ltr">&lt;<a href=3D"mailto:lakshmipriya.teekeyan@gmail.com">lakshmipriy=
a.teekeyan@gmail.com</a>&gt;</span><br>
Date: Mon, Oct 22, 2012 at 1:06 PM<br>Subject: Re: Errors while running FIO=
<br>To: Jens Axboe &lt;<a href=3D"mailto:jaxboe@fusionio.com">jaxboe@fusion=
io.com</a>&gt;, <a href=3D"mailto:fio@vger.kernel.org">fio@vger.kernel.org<=
/a><br>
<br><br><div>Jens, </div><div>=A0</div><div>=A0 I am running fio on a windo=
ws share. </div><div>The version is fio-2.0.9. </div><div>=A0</div><div>A s=
mall subset of job file is given below:</div><div>=A0</div><div>[exawritedi=
r2]<br>
rw=3Dwrite <br>
ioengine=3Dsync<br>bs=3D16k<br>size=3D20g<br>nrfiles=3D20<br>scramble_buffe=
rs=3D1<br>overwrite=3D0<br>verify=3Dsha1<br>directory=3DW:/Write2<br>thread=
<br>stonewall</div><div>=A0</div><div>Thanks,</div><div>Lakshmi<br></div><d=
iv class=3D"HOEnZb">
<div class=3D"h5"><div class=3D"gmail_quote">
On Sat, Oct 20, 2012 at 10:45 AM, Jens Axboe <span dir=3D"ltr">&lt;<a href=
=3D"mailto:jaxboe@fusionio.com" target=3D"_blank">jaxboe@fusionio.com</a>&g=
t;</span> wrote:<br><blockquote style=3D"margin:0px 0px 0px 0.8ex;padding-l=
eft:1ex;border-left-color:rgb(204,204,204);border-left-width:1px;border-lef=
t-style:solid" class=3D"gmail_quote">

<div><div>On 2012-10-20 01:51, Lakshmipriya Teekeyan wrote:<br>
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
rg" target=3D"_blank">fio@vger.kernel.org</a>. See the<br>
REPORTING-BUGS file included with fio.<br>
<span><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br>
</div></div></div><br>

--_000_CANcZXQdEWr0j1m4HL8UPy8jGaVfGzpiVbhTEHL77D8YgbAmailgmai_--


