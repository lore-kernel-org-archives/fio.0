Return-Path: <kyle.hailey@delphix.com>
MIME-Version: 1.0
In-Reply-To: <502A4E20.8020402@kernel.dk>
References: <CACiQ3FDXKEV0VVjrxaUH9U4CkXhHmVrz_d0eW6QyHKE2HHwacw@mail.gmail.com>
 <502A4E20.8020402@kernel.dk>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Fri, 14 Sep 2012 10:57:22 -0700
Message-ID: <CACiQ3FCocuuM_EaH4ZkfqqDdyEwg8oSGqUZPiErA+SqCWvvMZw@mail.gmail.com>
Subject: Re: raw device size used by fio
Content-Type: multipart/related; boundary=f46d042f9ef418bbb704c9ad29d4
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--f46d042f9ef418bbb704c9ad29d4
Content-Type: multipart/alternative; boundary=f46d042f9ef418bbb404c9ad29d3

--f46d042f9ef418bbb404c9ad29d3
Content-Type: text/plain; charset=ISO-8859-1

Follow-up question: Is this following a correct picture, if job file has

files=/dev/disk1:/dev/disk2:/dev/diskN
size=S

will this use the first S/N bytes of each file / disk?

If I have a raw device of 16GB and I specify

files=/dev/disk1

size=8g
rw=randread

will fio scatter the 8G of reads across the 16GB or will it limit the reads
to the first 8G?
I want to do the latter. I'm setting up fio to test I/O subsystems but I
first have to initialize the I/O subsystem with writes because some I/O
subsystems "know" there is no data if the data has never been written to,
but I want to limit the amount of data I have to initialize. For example
yesterday the client had 8TB of raw LUNs. It would have been sufficient for
my testing purposes to only use the first 8G across their 16 LUNs.



Thanks
Kyle


On Tue, Aug 14, 2012 at 6:09 AM, Jens Axboe <axboe@kernel.dk> wrote:

> On 08/08/2012 08:29 PM, Kyle Hailey wrote:
> > I was running a number of tests with raw devices and no size set (but
> > did use offsets).
> > In the case where a raw device is specified  but no size, what
> > happens? does fio have a way to figure out the size of the raw device?
>
> Yes, fio will figure out the size. If it could not, then it'll complain
> since it doesn't know how much IO to do.
>
> > What is the usage of the size parameter when there are multiple raw
> devices.
> > For example if I have multiple raw devices
> >
> >       filename=/dev/rdsk/c4t3d0p0:/dev/rdsk/c4t4d0p0
> >
> > and a set size
> >
> >      size=8000m
> >
> > will it treat the 8000m as the total size of the two devices or is the
> > 8000m the size of each?
>
> It'll do 8000m of IO in total.
>
> > If it's the total, then I guess fio can't work with multiple raw
> > devices of different sizes?
>
> Sure, lets say the first is 2g and the second is 10g. You should end up
> with 2g of IO done from the first one, the remainder from the last one.
> At least with the default file service policy.
>
> --
> Jens Axboe
>
>


-- 
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com

--f46d042f9ef418bbb404c9ad29d3
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Follow-up question:=A0Is this following a correct picture, if=A0job file ha=
s<div><div><br><blockquote style=3D"margin:0px 0px 0px 40px;border:none;pad=
ding:0px"><div><span style=3D"color:rgb(34,34,34);font-family:arial,sans-se=
rif;font-size:13px;background-color:rgb(255,255,255)">files=3D/dev/disk1:/d=
ev/disk2:/</span><span style=3D"color:rgb(34,34,34);font-family:arial,sans-=
serif;font-size:13px;background-color:rgb(255,255,255)">dev/diskN</span></d=
iv>

<div><span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-s=
ize:13px;background-color:rgb(255,255,255)">size=3DS</span></div><div><br><=
/div></blockquote></div><div><span style=3D"color:rgb(34,34,34);font-family=
:arial,sans-serif;font-size:13px;background-color:rgb(255,255,255)">will th=
is use the first S/N bytes of each file / disk?</span></div>

<br class=3D"Apple-interchange-newline"><div>If I have a raw device of 16GB=
 and I specify</div><div><br></div><div><blockquote style=3D"margin:0 0 0 4=
0px;border:none;padding:0px"><div>files=3D<span style=3D"background-color:r=
gb(255,255,255);color:rgb(34,34,34);font-family:arial,sans-serif;font-size:=
13px">/dev/disk1</span></div>

</blockquote><div><blockquote style=3D"margin:0 0 0 40px;border:none;paddin=
g:0px"><div>size=3D8g</div><div><div>rw=3Drandread</div></div><div><br></di=
v></blockquote>will fio scatter the 8G of reads across the 16GB or will it =
limit the reads to the first 8G?</div>

<div>I want to do the latter. I&#39;m setting up fio to test I/O subsystems=
 but I first have to initialize the I/O subsystem with writes because some =
I/O subsystems &quot;know&quot; there is no data if the data has never been=
 written to, but I want to limit the amount of data I have to initialize. F=
or example yesterday the client had 8TB of raw LUNs. It would have been suf=
ficient for my testing purposes to only use the first 8G across their 16 LU=
Ns.<br>

<blockquote style=3D"margin:0 0 0 40px;border:none;padding:0px"><div><br></=
div></blockquote></div><div><span style=3D"color:rgb(34,34,34);font-family:=
arial,sans-serif;font-size:13px;background-color:rgb(255,255,255)"><br></sp=
an></div>

<div><span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-s=
ize:13px;background-color:rgb(255,255,255)">Thanks</span></div><div><span s=
tyle=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-size:13px;bac=
kground-color:rgb(255,255,255)">Kyle</span></div>

<div><span style=3D"color:rgb(34,34,34);font-family:arial,sans-serif;font-s=
ize:13px;background-color:rgb(255,255,255)"><br></span></div><div><div><br>=
<div class=3D"gmail_quote">On Tue, Aug 14, 2012 at 6:09 AM, Jens Axboe <spa=
n dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=3D"_blank">axbo=
e@kernel.dk</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"im">On 08/08/2012 08:29 PM, Ky=
le Hailey wrote:<br>
&gt; I was running a number of tests with raw devices and no size set (but<=
br>
&gt; did use offsets).<br>
&gt; In the case where a raw device is specified =A0but no size, what<br>
&gt; happens? does fio have a way to figure out the size of the raw device?=
<br>
<br>
</div>Yes, fio will figure out the size. If it could not, then it&#39;ll co=
mplain<br>
since it doesn&#39;t know how much IO to do.<br>
<div class=3D"im"><br>
&gt; What is the usage of the size parameter when there are multiple raw de=
vices.<br>
&gt; For example if I have multiple raw devices<br>
&gt;<br>
&gt; =A0 =A0 =A0 filename=3D/dev/rdsk/c4t3d0p0:/dev/rdsk/c4t4d0p0<br>
&gt;<br>
&gt; and a set size<br>
&gt;<br>
&gt; =A0 =A0 =A0size=3D8000m<br>
&gt;<br>
&gt; will it treat the 8000m as the total size of the two devices or is the=
<br>
&gt; 8000m the size of each?<br>
<br>
</div>It&#39;ll do 8000m of IO in total.<br>
<div class=3D"im"><br>
&gt; If it&#39;s the total, then I guess fio can&#39;t work with multiple r=
aw<br>
&gt; devices of different sizes?<br>
<br>
</div>Sure, lets say the first is 2g and the second is 10g. You should end =
up<br>
with 2g of IO done from the first one, the remainder from the last one.<br>
At least with the default file service policy.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r><span style=3D"font-family:Calibri,Verdana,Helvetica,Arial;border-collaps=
e:collapse"><div><span style=3D"font-family:Calibri,Verdana,Helvetica,Arial=
;border-collapse:collapse">- Kyle=A0</span></div>

<img src=3D"cid:3383216829_8476078"><br>O: +1.415.341.3430<br>F: +1.650.494=
.1676<br>275 Middlefield Road, Suite 50<br>Menlo Park, CA 94025<br><a href=
=3D"http://www.delphix.com/" style=3D"color:rgb(42,93,176);font-size:13px" =
target=3D"_blank">http://www.delphix.com</a><br>

</span><br>
</div></div></div></div>

--f46d042f9ef418bbb404c9ad29d3--

--f46d042f9ef418bbb704c9ad29d4
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
--f46d042f9ef418bbb704c9ad29d4--


