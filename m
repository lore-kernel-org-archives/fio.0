Return-Path: <kyle.hailey@delphix.com>
MIME-Version: 1.0
In-Reply-To: <20120807144721.GF12248@splice>
References: <20120807010300.GD12248@splice> <50211B6A.2070505@kernel.dk> <20120807144721.GF12248@splice>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Tue, 7 Aug 2012 22:23:39 -0700
Message-ID: <CACiQ3FCF3aszv2QUj7vjxpioHJAS4M-5NBPHdWwFWvrmqAZXGQ@mail.gmail.com>
Subject: Re: generating latency logs
Content-Type: multipart/related; boundary=e89a8f50311a7e7c5504c6ba51eb
To: Mike Ryan <mike.ryan@inktank.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--e89a8f50311a7e7c5504c6ba51eb
Content-Type: multipart/alternative; boundary=e89a8f50311a7e7c5304c6ba51ea

--e89a8f50311a7e7c5304c6ba51ea
Content-Type: text/plain; charset=ISO-8859-1

very cool, so if I add the changes to init.c and run


fio --latency-log --output  test.job


I get extra four  files

 -rw-r--r--  1 me staff   14937 Aug  8  2012 fiotest_lat.log
-rw-r--r--  1 me staff       0 Aug  8  2012 fiotest_slat.log
-rw-r--r--  1 me staff   14932 Aug  8  2012 fiotest_clat.log
-rw-r--r--  1 me staff 4194304 Aug  8  2012 fiotest.1.0


What's the format?

$ more fiotest_lat*
1, 19, 1, 4096
1, 18, 1, 4096
1, 8, 1, 4096
1, 7, 1, 4096
1, 7, 1, 4096

What's the format? OK, found http://www.spinics.net/lists/fio/msg01064.html

Format of entries is:

   time, rate/latency, data direction, block size

 Time: in milliseconds. Bandwidth logs are usually 500 or 1000ms apart; that
 can be controlled by the config file with "bwavgtime=[x ms]".

 Rate/latency: for bandwidth, this is in KB/sec. For latency, it's
 microseconds.

 Data direction: 0 is read, 1 is write.

 Block size: block size of IOs in bytes.



the clat and lat look pretty much the same except clat is faster than lat
(clat is completion time ie  submission time plus I/O completion time - was
never that clear on this)


$ paste fiotest_lat* fiotest_c* | more
1, 19, 1, 4096  1, 17, 1, 4096
1, 18, 1, 4096  1, 17, 1, 4096
1, 8, 1, 4096   1, 7, 1, 4096
1, 7, 1, 4096   1, 6, 1, 4096
1, 7, 1, 4096   1, 6, 1, 4096

what is the format of the file fiotest.1.0 ?
Is there a way to get the latency files without this file to avoid too much
output.


Thanks

- Kyle


On Tue, Aug 7, 2012 at 7:47 AM, Mike Ryan <mike.ryan@inktank.com> wrote:

> On Tue, Aug 07, 2012 at 03:43:06PM +0200, Jens Axboe wrote:
> > >   fio --latency-log=/tmp/log --output=/tmp/log random_write.fio
> >
> > The latency/bw logs are named from the job name, so you can't actually
> > give it a specific name with the (global) command line option. You'd
> > need to use the job option to do that.
>
> The argument requires an option. It appears that option is discarded.
>
> > That said, it does look broken in that we don't inherit the global
> > setting. Does the below make it work?
>
> Yes! The files are named log_lat.log, log_slat.log, and log_clat.log.
> They are not named after the job.
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com

--e89a8f50311a7e7c5304c6ba51ea
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div><br></div>very cool, so if I add the changes to init.c and run<div><bl=
ockquote style=3D"margin:0 0 0 40px;border:none;padding:0px"><div><br></div=
><div><span style=3D"color:rgb(0,96,0);font-family:monospace;font-size:13.6=
3636302947998px;line-height:11.818181991577148px;background-color:rgb(239,2=
39,239)">fio --latency-log --output =A0test.job</span>=A0</div>

</blockquote></div><div><br></div><div>I get extra four =A0files</div><div>=
<br></div><blockquote style=3D"margin:0 0 0 40px;border:none;padding:0px"><=
div><div>=A0-<font face=3D"courier new, monospace">rw-r--r-- =A01 me staff =
=A0 14937 Aug =A08 =A02012 fiotest_lat.log</font></div>

</div><div><div><font face=3D"courier new, monospace">-rw-r--r-- =A01 me st=
aff =A0 =A0 =A0 0 Aug =A08 =A02012 fiotest_slat.log</font></div></div><div>=
<div><font face=3D"courier new, monospace">-rw-r--r-- =A01 me staff =A0 149=
32 Aug =A08 =A02012 fiotest_clat.log</font></div>

</div><div><div><font face=3D"courier new, monospace">-rw-r--r-- =A01 me st=
aff 4194304 Aug =A08 =A02012 fiotest.1.0</font></div></div></blockquote><di=
v><br></div><div>What&#39;s the format?</div><div><br></div><blockquote sty=
le=3D"margin:0 0 0 40px;border:none;padding:0px">

<div><div><font face=3D"courier new, monospace">$ more fiotest_lat* =A0</fo=
nt></div></div><div><div><font face=3D"courier new, monospace">1, 19, 1, 40=
96 =A0=A0</font></div></div><div><div><font face=3D"courier new, monospace"=
>1, 18, 1, 4096 =A0=A0</font></div>

</div><div><div><font face=3D"courier new, monospace">1, 8, 1, 4096 =A0 =A0=
</font></div></div><div><div><font face=3D"courier new, monospace">1, 7, 1,=
 4096 =A0 =A0</font></div></div><div><div><font face=3D"courier new, monosp=
ace">1, 7, 1, 4096 =A0 =A0</font></div>

</div><div><font face=3D"courier new, monospace"><br></font></div></blockqu=
ote><div><div>What&#39;s the format? OK, found=A0<a href=3D"http://www.spin=
ics.net/lists/fio/msg01064.html">http://www.spinics.net/lists/fio/msg01064.=
html</a></div>

<div><br></div></div><blockquote style=3D"margin:0 0 0 40px;border:none;pad=
ding:0px"><div><div><div><div>Format of entries is:</div><div>=A0</div><div=
>=A0 =A0time, rate/latency, data direction, block size</div><div>=A0</div><=
div>=A0Time: in milliseconds. Bandwidth logs are usually 500 or 1000ms apar=
t; that</div>

<div>=A0can be controlled by the config file with &quot;bwavgtime=3D[x ms]&=
quot;.</div><div>=A0</div><div>=A0Rate/latency: for bandwidth, this is in K=
B/sec. For latency, it&#39;s</div><div>=A0microseconds.</div><div>=A0</div>=
<div>=A0Data direction: 0 is read, 1 is write.</div>

<div>=A0</div><div>=A0Block size: block size of IOs in bytes.</div></div></=
div></div></blockquote><div><div><br></div><div><br></div><div>the clat and=
 lat look pretty much the same except clat is faster than lat (clat is comp=
letion time ie =A0submission time plus I/O completion time - was never that=
 clear on this)</div>

</div><blockquote style=3D"margin:0 0 0 40px;border:none;padding:0px"><div>=
<div><br></div></div><div><div><font face=3D"courier new, monospace">$ past=
e fiotest_lat* fiotest_c* | more</font></div><div><font face=3D"courier new=
, monospace">1, 19, 1, 4096 =A01, 17, 1, 4096</font></div>

<div><font face=3D"courier new, monospace">1, 18, 1, 4096 =A01, 17, 1, 4096=
</font></div><div><font face=3D"courier new, monospace">1, 8, 1, 4096 =A0 1=
, 7, 1, 4096</font></div><div><font face=3D"courier new, monospace">1, 7, 1=
, 4096 =A0 1, 6, 1, 4096</font></div>

<div><font face=3D"courier new, monospace">1, 7, 1, 4096 =A0 1, 6, 1, 4096<=
/font></div></div><div><br></div></blockquote><div>what is the format of th=
e file=A0<span style=3D"font-family:&#39;courier new&#39;,monospace">fiotes=
t.1.0 ?</span></div>

<div><span style=3D"font-family:&#39;courier new&#39;,monospace">Is there a=
 way to get the latency files without this file to avoid too much output.</=
span></div><div><span style=3D"font-family:&#39;courier new&#39;,monospace"=
><br>

</span></div><div><span style=3D"font-family:&#39;courier new&#39;,monospac=
e"><br></span></div><div><font face=3D"courier new, monospace">Thanks</font=
></div><div><font face=3D"courier new, monospace"><br></font></div><div><fo=
nt face=3D"courier new, monospace">- Kyle</font></div>

<div><font face=3D"courier new, monospace"><br></font></div><div><div><br><=
/div><div class=3D"gmail_quote">On Tue, Aug 7, 2012 at 7:47 AM, Mike Ryan <=
span dir=3D"ltr">&lt;<a href=3D"mailto:mike.ryan@inktank.com" target=3D"_bl=
ank">mike.ryan@inktank.com</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On Tue, Aug 07, 2012 at 03=
:43:06PM +0200, Jens Axboe wrote:<br>
&gt; &gt; =A0 fio --latency-log=3D/tmp/log --output=3D/tmp/log random_write=
.fio<br>
&gt;<br>
&gt; The latency/bw logs are named from the job name, so you can&#39;t actu=
ally<br>
&gt; give it a specific name with the (global) command line option. You&#39=
;d<br>
&gt; need to use the job option to do that.<br>
<br>
</div>The argument requires an option. It appears that option is discarded.=
<br>
<div class=3D"im"><br>
&gt; That said, it does look broken in that we don&#39;t inherit the global=
<br>
&gt; setting. Does the below make it work?<br>
<br>
</div>Yes! The files are named log_lat.log, log_slat.log, and log_clat.log.=
<br>
They are not named after the job.<br>
<div class=3D"HOEnZb"><div class=3D"h5">--<br>
To unsubscribe from this list: send the line &quot;unsubscribe fio&quot; in=
<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<span style=3D"font-family:Calibri,Verdana,Helvetica,Arial;border-collapse:=
collapse"><div><span style=3D"font-family:Calibri,Verdana,Helvetica,Arial;b=
order-collapse:collapse">- Kyle=A0</span></div>

<img src=3D"cid:3383216829_8476078"><br>O: +1.415.341.3430<br>F: +1.650.494=
.1676<br>275 Middlefield Road, Suite 50<br>Menlo Park, CA 94025<br><a href=
=3D"http://www.delphix.com/" style=3D"color:rgb(42,93,176);font-size:13px" =
target=3D"_blank">http://www.delphix.com</a><br>

</span><br>
</div>

--e89a8f50311a7e7c5304c6ba51ea--

--e89a8f50311a7e7c5504c6ba51eb
Content-Type: image/png; name="image.png"
Content-Transfer-Encoding: base64
Content-ID: <3383216829_8476078>
X-Attachment-Id: d30e9113d2365089_0.2

iVBORw0KGgoAAAANSUhEUgAAAI8AAAA7CAYAAABCONnwAAAC/ElEQVR42u2cgY2jMBBFKYESKIES
KIESKIES6CAlUAIlUAIlUAIlsEFnSz7LJMx4iPZy70mj1UbJ2Ix/xh9IUhQAAAAAAAAAAAAAAADw
G9iLontGTSVAKpz6GQOVAKlwymcsx1+qAVLxzM/oqQRIhTM+Y6USoDHI+zNaqgFSg3wIZ6YaIDXI
mxNPQ0VAIp7FCWekGiA1yLuLioqA1CAf8aAiIDXIu/M7XBAEsUHeuQ0BGoNM1wG1QabrgMog03VA
ZZDpOqA2yHQdUBlkug6oDTJdB1QGma4DaoNM17mB477OnBlHjnhRjv8ng9w+ugyDvF+8c94ZzPMY
ozrJ22SsU5uoQypv7x7L+eaHX7sxcRybi87V2yS2qGitYW4fWoN89c75bFiLcPE293jOh83mRI5U
3nAenWKcOsi7R8I8xlmKPx/VXcLBVuU7LZxseBCVG8BqMYYLwhlfCOfKwg1R4XJiSiyotXhSecdo
HpJPDHTR8S/RjjI5nay+K/knDhktbjlR6m8wyD66D01lvbjId4nHW5E9EsGrdamcMOJGUCby+q5j
Ih7f6uI8pdt/B4PolQY5jKtGucqY93iyoGF319ZAKsou0UV9x/A5Hydb9fBmret4AkP+m/+vdt0Z
+51WYZB9LMr93mq+lnWQdDSpddikO4eFeMrEHjvcaMavGuRd+K2IyWiu/UmNPy0ezRpMheByhoV4
+oTDH+72QW8Msmbbmt+JNbMrf8rzlIntaHVrE65FE5zux8+tJQc2umSSaKN9fgtU22bmjqMSGuQ4
HsoF+tfEUwf+6KwTpmgSr+uuHphF9JH6N8Pcq9Aga864vkE8m6aDRBcHw7q/fP12g3BeOX4L8VSu
8wzuhwlWow40Ja7RWDAb5E3NLZV3O7lGI2G8Kp7KYEsp36i5uXkMf9bVHL9w4bzQ/EJA68m3Q8sr
YylPKHLzpnKkHquMPGZd/O8/buW6VOu61BSdnc0fvHgIXySqJtj6Jve3oTIAAAAAAAAAAAAAAAAA
38cP4ack3pH//KgAAAAASUVORK5CYII=
--e89a8f50311a7e7c5504c6ba51eb--


