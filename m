Return-Path: <dongjin.lee@auckland.ac.nz>
MIME-Version: 1.0
In-Reply-To: <20100427064224.GX27497@kernel.dk>
References: <4BD62D8A.5050109@auckland.ac.nz>
	 <20100427064224.GX27497@kernel.dk>
Date: Tue, 27 Apr 2010 18:49:02 +1200
Message-ID: <k2v8baae1371004262349sb41985e9i73f4d3a2e42aca7c@mail.gmail.com>
Subject: Re: Using offsets in fio
From: DongJin Lee <dongjin.lee@auckland.ac.nz>
Content-Type: multipart/alternative; boundary=000e0cdf1bd8fbe22704853249b5
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Michael O'Sullivan <michael.osullivan@auckland.ac.nz>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--000e0cdf1bd8fbe22704853249b5
Content-Type: text/plain; charset=ISO-8859-1

So for example, you'd expect, for example,
at the end of 1TB position (1073741824 bytes) the offset is to be 1073741824
?
and similarly for end of 2TB position, the offset would be the twice?

Regards


On Tue, Apr 27, 2010 at 6:42 PM, Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Apr 27 2010, Michael O'Sullivan wrote:
> > Hi everyone,
> >
> > We are using fio to emulate the SPC-1 benchmark (we hope to get this
> > included as a --profile in fio in the not too distant future). However,
> > we have noticed that when running our benchmark the disk we are testing
> > does not seem to be overly busy seeking to different locations on the
> > disk. When we run tests using Iometer we can hear the disk seeking to
> > different sections of the disk pretty much the whole time. We are using
> > io_u->offset to define the position in the file we wish to read/write
> > at, but it is not clear to us whether this is having the desired effect.
> > It doesn't seem so at this point... We have been using the sync and
> > libaio engines.
>
> io_u->offset is the byte offset that the engine will seek to before
> performing IO, so whatever you put in there will be the real offset. If
> the disk doesn't sound as busy as it should, perhaps it's because
> iometer drives a higher queue depth as well?
>
> > Can someone please give us some advice to help us troubleshoot this
> > problem? Or point us to a tool that will let us see where fio is
> > reading/writing on the disk? Any help is greatly appreciated.
>
> For shorter samples, you could always just strace fio and see what it's
> doing. For a better view, you could use blktrace.
>
> --
> Jens Axboe
>
>

--000e0cdf1bd8fbe22704853249b5
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

So for example, you&#39;d expect, for example, <br>at the end of 1TB positi=
on (1073741824 bytes) the offset is to be 1073741824 ?<br>and similarly for=
 end of 2TB position, the offset would be the twice?<br><br>Regards<br><br>
<br><div class=3D"gmail_quote">On Tue, Apr 27, 2010 at 6:42 PM, Jens Axboe =
<span dir=3D"ltr">&lt;<a href=3D"mailto:jens.axboe@oracle.com">jens.axboe@o=
racle.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=
=3D"border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; p=
adding-left: 1ex;">
<div class=3D"im">On Tue, Apr 27 2010, Michael O&#39;Sullivan wrote:<br>
&gt; Hi everyone,<br>
&gt;<br>
&gt; We are using fio to emulate the SPC-1 benchmark (we hope to get this<b=
r>
&gt; included as a --profile in fio in the not too distant future). However=
,<br>
&gt; we have noticed that when running our benchmark the disk we are testin=
g<br>
&gt; does not seem to be overly busy seeking to different locations on the<=
br>
&gt; disk. When we run tests using Iometer we can hear the disk seeking to<=
br>
&gt; different sections of the disk pretty much the whole time. We are usin=
g<br>
&gt; io_u-&gt;offset to define the position in the file we wish to read/wri=
te<br>
&gt; at, but it is not clear to us whether this is having the desired effec=
t.<br>
&gt; It doesn&#39;t seem so at this point... We have been using the sync an=
d<br>
&gt; libaio engines.<br>
<br>
</div>io_u-&gt;offset is the byte offset that the engine will seek to befor=
e<br>
performing IO, so whatever you put in there will be the real offset. If<br>
the disk doesn&#39;t sound as busy as it should, perhaps it&#39;s because<b=
r>
iometer drives a higher queue depth as well?<br>
<div class=3D"im"><br>
&gt; Can someone please give us some advice to help us troubleshoot this<br=
>
&gt; problem? Or point us to a tool that will let us see where fio is<br>
&gt; reading/writing on the disk? Any help is greatly appreciated.<br>
<br>
</div>For shorter samples, you could always just strace fio and see what it=
&#39;s<br>
doing. For a better view, you could use blktrace.<br>
<br>
--<br>
<font color=3D"#888888">Jens Axboe<br>
<br>
</font></blockquote></div><br>

--000e0cdf1bd8fbe22704853249b5--


