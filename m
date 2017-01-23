Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
References: <90865544-f790-513c-97df-7e6a6af20ca8@gmail.com>
 <CANvN+en2ihATNgrbgzwNXAK87wNh+6jXHinmg2-VmHon31AJzA@mail.gmail.com>
 <061acabe-dbd0-ae07-cd69-772eccd15b21@gmail.com> <CANvN+em0cjWRnQWccdORKFEJk0OSeQOrZq+XE6kzPmqMPB--4g@mail.gmail.com>
 <49ef9d71-8e52-26e4-76f7-ea03fb331a38@gmail.com> <CALjAwxjmW-NgWEcH7+nKNN8U_oUxFoYa23dui9wM6WDqiShWhw@mail.gmail.com>
 <15418080-0bf6-ab40-c05f-69a3fb3d9cc3@gmail.com> <CALjAwxhsvfH0-D=4U6nkjFg109Z1ZgVRsOx37X+Lb-EqTf_jOA@mail.gmail.com>
 <6b2cacaf-2946-6046-51c2-b909c6ee0784@gmail.com> <CANvN+emLjb9idri9r42V3W9ia6v0EDGdJYFfhzq6rAuzGWec8Q@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 24 Jan 2017 00:42:40 +0300
Message-ID: <CANvN+emJBzMeUmjBw5PBSZc66LmjG8-Pz+39dBeL5GseMCdo6g@mail.gmail.com>
Subject: Re: 4x lower IOPS: Linux MD vs indiv. devices - why?
Content-Type: multipart/alternative; boundary=94eb2c19ec0a11b18f0546c9e1e2
To: Tobias Oberstein <tobias.oberstein@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

--94eb2c19ec0a11b18f0546c9e1e2
Content-Type: text/plain; charset=UTF-8

On Jan 24, 2017 00:22, "Tobias Oberstein" <tobias.oberstein@gmail.com>
wrote:

Am 23.01.2017 um 21:24 schrieb Sitsofe Wheeler:

> On 23 January 2017 at 19:40, Tobias Oberstein
> <tobias.oberstein@gmail.com> wrote:
>
>> Am 23.01.2017 um 20:13 schrieb Sitsofe Wheeler:
>>
>>>
>>> On 23 January 2017 at 18:33, Tobias Oberstein
>>> <tobias.oberstein@gmail.com> wrote:
>>>
>>>>
>>>> libaio is nowhere near what I get with engine=sync and high job counts.
>>>> Mmh.
>>>> Plus the strange behavior.
>>>>
>>>
>>> Have you tried batching the IOs and controlling how much are you
>>> reaping at any one time? See
>>>
>>> http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-a
>>> rg-iodepth_batch_submit
>>> for some of the options for controlling this...
>>>
>>
>> Thanks! Nice.
>>
>> For libaio, and with all the hints applied (no 4k sectors yet), I get (4k
>> randread)
>>
>> Individual NVMes: iops=7350.4K
>> MD (RAID-0) over NVMes: iops=4112.8K
>>
>> The going up and down of IOPS is gone.
>>
>> It's becoming more apparent I'd say, that tthere is a MD bottleneck
>> though.
>>
>
> If you're "just" trying for higher IOPS you can also try gtod_reduce
> (see http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-a
> rg-gtod_reduce
> ). This subsumes things like disable_lat but you'll get fewer and less
> accurate measurement stats back. With libaio userspace reap
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-
> arg-userspace_reap
> ) can sometimes nudge numbers up but at the cost of CPU.
>
>
Using that option plus bumping to QD=64 and batch submit 16, I get

plain NVMes:   iops=7415.9K
MD over NVMes: iops=4112.4K

These are staggering numbers for sure!

In fact, the Intel P3608 4TB datasheet says: up to 850k random 4kB

Since we have 8 (physical) of these, the real world measurement (7.4 mio)
is even above the datasheet (6.8 mio).

I'd say: very good job Intel =)

The price of course is the CPU load to reach these numbers .. we have the
2nd largest Intel Xeon available

Intel(R) Xeon(R) CPU E7-8880 v4 @ 2.20GHz

and 4 of these .. and even that isn't enough to saturate these NVMe beasts
while still having room to do useful work (PostgreSQL).



The root cause behind the high cpu utilization is the IRQ load your eight
NVMe drives generate, although context switching your 2048 threads also add
a lot.

To cope with the unsustainable interrupt rate, you might want to give a
shot to the psync engine with RWF_HIPRI option set, which turns on polling
mode in the block layer (Jens has been very much behind it, so he's the guy
in the know of the details).

Polling avoids interrupts at the price of the somewhat inflated latency,
but reduces the cpu load noticeably, so it may turn out a good option for
your box specifically. Notice you'll need preadv2/pwrirev2 syscall support
in your kernel.

Regards,
Andrey



So we're gonna be CPU bound .. again - this is the 2nd iteration of such a
box. The first one has 48 cores E7 v2 and 8 x P3700 2TB. Also CPU bound on
PostgreSQL anyway .. with 3TB RAM.

Cheers,
/Tobias




randread-individual-nvmes: (groupid=0, jobs=128): err= 0: pid=37454: Mon
Jan 23 22:12:30 2017
  read : io=869361MB, bw=28968MB/s, iops=7415.9K, runt= 30011msec
  cpu          : usr=6.14%, sys=64.55%, ctx=59170293, majf=0, minf=8320

randread-md-over-nvmes: (groupid=1, jobs=128): err= 0: pid=37582: Mon Jan
23 22:12:30 2017
  read : io=481982MB, bw=16064MB/s, iops=4112.4K, runt= 30004msec
  cpu          : usr=3.88%, sys=95.88%, ctx=14209, majf=0, minf=6784



[global]
group_reporting
size=30G
ioengine=libaio
iodepth=64
iodepth_batch_submit=16

thread=1
direct=1
time_based=1
randrepeat=0
norandommap=1
disable_lat=1
gtod_reduce=1

bs=4k
runtime=30

[randread-individual-nvmes]
stonewall
filename=/dev/nvme0n1:/dev/nvme1n1:/dev/nvme2n1:/dev/nvme3n1
:/dev/nvme4n1:/dev/nvme5n1:/dev/nvme6n1:/dev/nvme7n1:/dev/nv
me8n1:/dev/nvme9n1:/dev/nvme10n1:/dev/nvme11n1:/dev/nvme12n1
:/dev/nvme13n1:/dev/nvme14n1:/dev/nvme15n1
rw=randread
numjobs=128

[randread-md-over-nvmes]
stonewall
filename=/dev/md1
rw=randread
numjobs=128

--94eb2c19ec0a11b18f0546c9e1e2
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><br><div class=3D"gmail_extra"><br><div class=3D"gma=
il_quote">On Jan 24, 2017 00:22, &quot;Tobias Oberstein&quot; &lt;<a href=
=3D"mailto:tobias.oberstein@gmail.com" target=3D"_blank">tobias.oberstein@g=
mail.com</a>&gt; wrote:<br type=3D"attribution"><blockquote class=3D"m_-905=
3517219362182363quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc soli=
d;padding-left:1ex"><div class=3D"m_-9053517219362182363elided-text">Am 23.=
01.2017 um 21:24 schrieb Sitsofe Wheeler:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 23 January 2017 at 19:40, Tobias Oberstein<br>
&lt;<a href=3D"mailto:tobias.oberstein@gmail.com" target=3D"_blank">tobias.=
oberstein@gmail.com</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Am 23.01.2017 um 20:13 schrieb Sitsofe Wheeler:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
On 23 January 2017 at 18:33, Tobias Oberstein<br>
&lt;<a href=3D"mailto:tobias.oberstein@gmail.com" target=3D"_blank">tobias.=
oberstein@gmail.com</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
libaio is nowhere near what I get with engine=3Dsync and high job counts.<b=
r>
Mmh.<br>
Plus the strange behavior.<br>
</blockquote>
<br>
Have you tried batching the IOs and controlling how much are you<br>
reaping at any one time? See<br>
<br>
<a href=3D"http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-i=
odepth_batch_submit" rel=3D"noreferrer" target=3D"_blank">http://fio.readth=
edocs.io/en/l<wbr>atest/fio_doc.html#cmdoption-a<wbr>rg-iodepth_batch_submi=
t</a><br>
for some of the options for controlling this...<br>
</blockquote>
<br>
Thanks! Nice.<br>
<br>
For libaio, and with all the hints applied (no 4k sectors yet), I get (4k<b=
r>
randread)<br>
<br>
Individual NVMes: iops=3D7350.4K<br>
MD (RAID-0) over NVMes: iops=3D4112.8K<br>
<br>
The going up and down of IOPS is gone.<br>
<br>
It&#39;s becoming more apparent I&#39;d say, that tthere is a MD bottleneck=
 though.<br>
</blockquote>
<br>
If you&#39;re &quot;just&quot; trying for higher IOPS you can also try gtod=
_reduce<br>
(see <a href=3D"http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-=
arg-gtod_reduce" rel=3D"noreferrer" target=3D"_blank">http://fio.readthedoc=
s.io/en/l<wbr>atest/fio_doc.html#cmdoption-a<wbr>rg-gtod_reduce</a><br>
). This subsumes things like disable_lat but you&#39;ll get fewer and less<=
br>
accurate measurement stats back. With libaio userspace reap<br>
(<a href=3D"http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-=
userspace_reap" rel=3D"noreferrer" target=3D"_blank">http://fio.readthedocs=
.io/en/<wbr>latest/fio_doc.html#cmdoption-<wbr>arg-userspace_reap</a><br>
) can sometimes nudge numbers up but at the cost of CPU.<br>
<br>
</blockquote>
<br></div>
Using that option plus bumping to QD=3D64 and batch submit 16, I get<br>
<br>
plain NVMes:=C2=A0 =C2=A0iops=3D7415.9K<br>
MD over NVMes: iops=3D4112.4K<br>
<br>
These are staggering numbers for sure!<br>
<br>
In fact, the Intel P3608 4TB datasheet says: up to 850k random 4kB<br>
<br>
Since we have 8 (physical) of these, the real world measurement (7.4 mio) i=
s even above the datasheet (6.8 mio).<br>
<br>
I&#39;d say: very good job Intel =3D)<br>
<br>
The price of course is the CPU load to reach these numbers .. we have the 2=
nd largest Intel Xeon available<br>
<br>
Intel(R) Xeon(R) CPU E7-8880 v4 @ 2.20GHz<br>
<br>
and 4 of these .. and even that isn&#39;t enough to saturate these NVMe bea=
sts while still having room to do useful work (PostgreSQL).<br></blockquote=
></div></div></div><div dir=3D"auto"><br></div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">The root cause behind the high cpu utilization is the IRQ=
 load your eight NVMe drives generate, although context switching your 2048=
 threads also add a lot.=C2=A0</div><div dir=3D"auto"><br></div><div dir=3D=
"auto">To cope with the unsustainable interrupt rate, you might want to giv=
e a shot to the psync engine with=C2=A0RWF_HIPRI option set, which turns on=
 polling mode in the block layer (Jens has been very much behind it, so he&=
#39;s the guy in the know of the details).=C2=A0</div><div dir=3D"auto"><br=
></div><div dir=3D"auto">Polling avoids interrupts at the price of the some=
what inflated latency, but reduces the cpu load noticeably, so it may turn =
out a good option for your box specifically. Notice you&#39;ll need preadv2=
/pwrirev2 syscall support in your kernel.</div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">Regards,</div><div dir=3D"auto">Andrey</div><div dir=3D"a=
uto"><br></div><div dir=3D"auto"><br></div><div dir=3D"auto"><div class=3D"=
gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"m_-90535172193=
62182363quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;paddin=
g-left:1ex">
<br>
So we&#39;re gonna be CPU bound .. again - this is the 2nd iteration of suc=
h a box. The first one has 48 cores E7 v2 and 8 x P3700 2TB. Also CPU bound=
 on PostgreSQL anyway .. with 3TB RAM.<br>
<br>
Cheers,<br>
/Tobias<br>
<br>
<br>
<br>
<br>
randread-individual-nvmes: (groupid=3D0, jobs=3D128): err=3D 0: pid=3D37454=
: Mon Jan 23 22:12:30 2017<br>
=C2=A0 read : io=3D869361MB, bw=3D28968MB/s, iops=3D7415.9K, runt=3D 30011m=
sec<br>
=C2=A0 cpu=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : usr=3D6.14%, sys=3D64.55%, c=
tx=3D59170293, majf=3D0, minf=3D8320<br>
<br>
randread-md-over-nvmes: (groupid=3D1, jobs=3D128): err=3D 0: pid=3D37582: M=
on Jan 23 22:12:30 2017<br>
=C2=A0 read : io=3D481982MB, bw=3D16064MB/s, iops=3D4112.4K, runt=3D 30004m=
sec<br>
=C2=A0 cpu=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : usr=3D3.88%, sys=3D95.88%, c=
tx=3D14209, majf=3D0, minf=3D6784<br>
<br>
<br>
<br>
[global]<br>
group_reporting<br>
size=3D30G<br>
ioengine=3Dlibaio<br>
iodepth=3D64<br>
iodepth_batch_submit=3D16<div class=3D"m_-9053517219362182363quoted-text"><=
br>
thread=3D1<br>
direct=3D1<br>
time_based=3D1<br>
randrepeat=3D0<br>
norandommap=3D1<br>
disable_lat=3D1<br></div>
gtod_reduce=3D1<div class=3D"m_-9053517219362182363elided-text"><br>
bs=3D4k<br>
runtime=3D30<br>
<br>
[randread-individual-nvmes]<br>
stonewall<br>
filename=3D/dev/nvme0n1:/dev/nvm<wbr>e1n1:/dev/nvme2n1:/dev/nvme3n1<wbr>:/d=
ev/nvme4n1:/dev/nvme5n1:/de<wbr>v/nvme6n1:/dev/nvme7n1:/dev/nv<wbr>me8n1:/d=
ev/nvme9n1:/dev/nvme10<wbr>n1:/dev/nvme11n1:/dev/nvme12n1<wbr>:/dev/nvme13n=
1:/dev/nvme14n1:/<wbr>dev/nvme15n1<br>
rw=3Drandread<br>
numjobs=3D128<br>
<br>
[randread-md-over-nvmes]<br>
stonewall<br>
filename=3D/dev/md1<br>
rw=3Drandread<br>
numjobs=3D128<br>
<br>
</div></blockquote></div><br></div></div></div>

--94eb2c19ec0a11b18f0546c9e1e2--

