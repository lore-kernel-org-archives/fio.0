Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5427716A.1080407@kernel.dk>
References: <542179FA.5040106@gmail.com>
	<CANvN+enrUD45Zp1CJKQ3kxQncHLyhp7hE1jr4AnzRD65oDTUvg@mail.gmail.com>
	<54228237.5000805@gmail.com>
	<CALjAwxg+o05=3YDOmXaKskrdg3AHU88T-pkqZw=QFQkwRTjdwA@mail.gmail.com>
	<CALjAwxirUW+v662QZ9zQG-2zuTNtE8xkpfaJqv=5ArLviqjhGw@mail.gmail.com>
	<5427716A.1080407@kernel.dk>
Date: Sun, 28 Sep 2014 11:32:50 +0100
Message-ID: <CALjAwxhokxGnoNbA-5C-hPA=a2A1OZKTqgvok3kyORpDpOKHYQ@mail.gmail.com>
Subject: Re: [Question] How to perform stride access?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: multipart/alternative; boundary=14dae9cc9c680c270c05041dac30
To: Jens Axboe <axboe@kernel.dk>
Cc: Akira Hayakawa <ruby.wktk@gmail.com>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

--14dae9cc9c680c270c05041dac30
Content-Type: text/plain; charset=UTF-8

On 28 September 2014 03:24, Jens Axboe <axboe@kernel.dk> wrote:
>> On 24 September 2014 10:52, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>>>
>>> This looks like a bug. I can reproduce it with 2.1.11-11-gb7f5 too:
>>>
>>> dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
>>> fio --bs=4k --rw=write:4k --filename=/dev/shm/1M --stonewall --name=1M
>>> --io_limit=1M  --name=2M --io_limit=2M
>>> [...]
>>>
>>> Run status group 0 (all jobs):
>>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>>> mint=2msec, maxt=2msec
>>>
>>> Run status group 1 (all jobs):
>>>    WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
>>> mint=2msec, maxt=2msec
>>>
>>> Why isn't io 1024KB for group 0? Additionally, shouldn't the total io
>>> written each group be different? Jens?
>
> You are doing a sequential workload, skipping 4k every time. First write
> will be to offset 0, next to 8KB, etc. Write 128 would be to 1040384,
which
> is 1MB - 8KB. Hence the next feasible offset after that would be 1MB,
which
> is end of the file. So how could it do more than 512KB of IO? That's 128 *
> 4KB.
>
> I didn't read the whole thread in detail, just looked at your last example
> here. And for that one, I don't see anything wrong.

I guess I would have thought io_limit always forced wraparound. For example:

# dd if=/dev/zero of=/dev/shm/1M bs=1M count=1
# fio --bs=4k --filename=/dev/shm/1M --name=go1 --rw=write
[...]
Run status group 0 (all jobs):
  WRITE: io=1024KB, aggrb=341333KB/s, minb=341333KB/s, maxb=341333KB/s,
mint=3msec, maxt=3msec
# fio --bs=4k --filename=/dev/shm/1M --name=go2 --io_limit=2M --rw=write
Run status group 0 (all jobs):
  WRITE: io=2048KB, aggrb=341333KB/s, minb=341333KB/s, maxb=341333KB/s,
mint=6msec, maxt=6msec
[...]
# fio --bs=4k --filename=/dev/shm/1M --name=go3 --io_limit=2M --rw=write:4k
[...]
  WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
mint=2msec, maxt=2msec
Run status group 0 (all jobs):
# fio --bs=4k --filename=/dev/shm/1M --name=go4 --io_limit=2M --rw=write:4k
[...]
Run status group 0 (all jobs):
  WRITE: io=512KB, aggrb=256000KB/s, minb=256000KB/s, maxb=256000KB/s,
mint=2msec, maxt=2msec

go2 is a plain sequential job that does twice as much I/O as go1. Given
that the size of the file being written to has not changed between the runs
one could guess that fio simply wrapped around and started from the first
offset (0) to write the second MB of data. Given this isn't it a fair
assumption that when doing a skipping workload if io_limit is used (as in
go4) and an offset beyond the end of the device is produced the same
wraparound behaviour as go2 should occur and the total io done should match
that specified in io_limit?

-- 
Sitsofe | http://sucs.org/~sits/

--14dae9cc9c680c270c05041dac30
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On 28 September 2014 03:24, Jens Axboe &lt;<a href=3D"mail=
to:axboe@kernel.dk">axboe@kernel.dk</a>&gt; wrote:<br>&gt;&gt; On 24 Septem=
ber 2014 10:52, Sitsofe Wheeler &lt;<a href=3D"mailto:sitsofe@gmail.com">si=
tsofe@gmail.com</a>&gt; wrote:<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; This looks l=
ike a bug. I can reproduce it with 2.1.11-11-gb7f5 too:<br>&gt;&gt;&gt;<br>=
&gt;&gt;&gt; dd if=3D/dev/zero of=3D/dev/shm/1M bs=3D1M count=3D1<br>&gt;&g=
t;&gt; fio --bs=3D4k --rw=3Dwrite:4k --filename=3D/dev/shm/1M --stonewall -=
-name=3D1M<br>&gt;&gt;&gt; --io_limit=3D1M =C2=A0--name=3D2M --io_limit=3D2=
M<br>&gt;&gt;&gt; [...]<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; Run status group 0 =
(all jobs):<br>&gt;&gt;&gt; =C2=A0 =C2=A0WRITE: io=3D512KB, aggrb=3D256000K=
B/s, minb=3D256000KB/s, maxb=3D256000KB/s,<br>&gt;&gt;&gt; mint=3D2msec, ma=
xt=3D2msec<br>&gt;&gt;&gt;<br>&gt;&gt;&gt; Run status group 1 (all jobs):<b=
r>&gt;&gt;&gt; =C2=A0 =C2=A0WRITE: io=3D512KB, aggrb=3D256000KB/s, minb=3D2=
56000KB/s, maxb=3D256000KB/s,<br>&gt;&gt;&gt; mint=3D2msec, maxt=3D2msec<br=
>&gt;&gt;&gt;<br>&gt;&gt;&gt; Why isn&#39;t io 1024KB for group 0? Addition=
ally, shouldn&#39;t the total io<br>&gt;&gt;&gt; written each group be diff=
erent? Jens?<br>&gt;<br>&gt; You are doing a sequential workload, skipping =
4k every time. First write<br>&gt; will be to offset 0, next to 8KB, etc. W=
rite 128 would be to 1040384, which<br>&gt; is 1MB - 8KB. Hence the next fe=
asible offset after that would be 1MB, which<br>&gt; is end of the file. So=
 how could it do more than 512KB of IO? That&#39;s 128 *<br>&gt; 4KB.<br>&g=
t;<br>&gt; I didn&#39;t read the whole thread in detail, just looked at you=
r last example<br>&gt; here. And for that one, I don&#39;t see anything wro=
ng.<br><br>I guess I would have thought io_limit always forced wraparound. =
For example:<br><br># dd if=3D/dev/zero of=3D/dev/shm/1M bs=3D1M count=3D1<=
br># fio --bs=3D4k --filename=3D/dev/shm/1M --name=3Dgo1 --rw=3Dwrite<br>[.=
..]<br>Run status group 0 (all jobs):<br>=C2=A0 WRITE: io=3D1024KB, aggrb=
=3D341333KB/s, minb=3D341333KB/s, maxb=3D341333KB/s, mint=3D3msec, maxt=3D3=
msec<div># fio --bs=3D4k --filename=3D/dev/shm/1M --name=3Dgo2 --io_limit=
=3D2M --rw=3Dwrite</div><div>Run status group 0 (all jobs):</div><div>=C2=
=A0=C2=A0WRITE: io=3D2048KB, aggrb=3D341333KB/s, minb=3D341333KB/s, maxb=3D=
341333KB/s, mint=3D6msec, maxt=3D6msec</div><div><div>[...]</div></div><div=
><div># fio --bs=3D4k --filename=3D/dev/shm/1M --name=3Dgo3 --io_limit=3D2M=
 --rw=3Dwrite:4k</div><div><div>[...]</div><div>=C2=A0=C2=A0WRITE: io=3D512=
KB, aggrb=3D256000KB/s, minb=3D256000KB/s, maxb=3D256000KB/s, mint=3D2msec,=
 maxt=3D2msec</div><div>Run status group 0 (all jobs):</div></div></div><di=
v># fio --bs=3D4k --filename=3D/dev/shm/1M --name=3Dgo4 --io_limit=3D2M --r=
w=3Dwrite:4k</div><div><div>[...]</div><div>Run status group 0 (all jobs):<=
/div></div><div>=C2=A0=C2=A0WRITE: io=3D512KB, aggrb=3D256000KB/s, minb=3D2=
56000KB/s, maxb=3D256000KB/s, mint=3D2msec, maxt=3D2msec<br><br>go2 is a pl=
ain sequential job that does twice as much I/O as go1. Given that the size =
of the file being written to has not changed between the runs one could gue=
ss that fio simply wrapped around and started from the first offset (0) to =
write the second MB of data. Given this isn&#39;t it a fair assumption that=
 when doing a skipping workload if io_limit is used (as in go4) and an offs=
et beyond the end of the device is produced the same wraparound behaviour a=
s go2 should occur and the total io done should match that specified in io_=
limit?<br><br>-- <br>Sitsofe | <a href=3D"http://sucs.org/~sits/">http://su=
cs.org/~sits/</a></div></div>

--14dae9cc9c680c270c05041dac30--

