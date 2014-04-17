Return-Path: <xiaofei.du008@gmail.com>
MIME-Version: 1.0
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
 <534DB18A.4050507@kernel.dk> <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com>
 <534DE08D.2070604@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
From: Xiaofei Du <xiaofei.du008@gmail.com>
Date: Wed, 16 Apr 2014 18:08:55 -0700
Message-ID: <CAND_vCYxvpDc8cqpQCoZye-eBHCWDajKhecCixDKac7aUOimMw@mail.gmail.com>
Subject: Re: Question about FIO sequential writes
Content-Type: multipart/alternative; boundary=089e013c661421de8604f732afd6
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

--089e013c661421de8604f732afd6
Content-Type: text/plain; charset=UTF-8

Robert,

Thanks for the tips. I don't understand the last point (- to avoid
filesystem interference, directly access the drive with /dev/disk/by-path,
/dev/disk/by-id, ...)

I googled it, but didn't find something related directly. Maybe I googled
the wrong key words. So could you please help to explain this last point,
or send me some links to read? Thanks a lot.

Best,
Xiaofei


On Tue, Apr 15, 2014 at 9:47 PM, Elliott, Robert (Server Storage) <
Elliott@hp.com> wrote:

> > On 2014-04-15 17:04, Xiaofei Du wrote:
> > > [global]
> > > bs=4k
> > > size=100m
> > > direct=1
> > > filename=100mfile
> > >
>
> A few more tips:
> - I don't see ioengine=libaio or iodepth=nn in that excerpt.
> - use iostat -mxyz 2 while the test is running to see the IO sizes that
> the block layer is sending to the LLD, how many block layer merges are
> occurring, the IO depth being maintained to the LLD, and the IOPS rate.
> - set /sys/block/<drive name>/queue/nomerges to 2 to disable block
> layer/scheduler merging.
> - your LLD or controller might have its own cache and/or do sequential
> merging (coalescing) too.  What controller are you using?
> - by using a file, you don't know whether it's on the inner tracks or
> outer tracks or somewhere in between.
> - by using a file, you don't know whether it's fragmented, making
> sequential transfers really random to the drive.
> - by using a file, if using an "advanced format" drive (with large
> physical sectors), you have to be wary of unaligned transfers.  Is the
> partition aligned so all the accesses really go to the drive aligned to 4
> KiB boundaries?
> - by using a tiny file size like 100 MiB, writes could easily get buffered
> in a write cache somewhere along the way; 64 and 128 MiB HDD volatile write
> cache sizes are common nowadays, and RAID controllers have multi-GiB
> non-volatile write caches.
> - although you didn't report results with reads, beware that the drive
> could end up serving all 100 MiB of random read data from its cache (reads
> can always be cached, volatile or not), while throwing away sequential
> prefetched read data after returning that data because the drive does not
> expect the data to be read again.
> - to avoid filesystem interference, directly access the drive with
> /dev/disk/by-path, /dev/disk/by-id, or /dev/sdNN type names (or
> \\.\PhysicalDriveNN in Windows).  If using /dev/sdNN or PhysicalDriveNN, be
> very careful not to overwrite your boot drive, since the mapping can change
> every reboot; I don't think fio provides any protection from doing so.
>
>

--089e013c661421de8604f732afd6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Robert,<div><br></div><div>Thanks for the tips. I don&#39;=
t understand the last point (<span style=3D"font-family:arial,sans-serif;fo=
nt-size:13px">- to avoid filesystem interference, directly access the drive=
 with /dev/disk/by-path, /dev/disk/by-id, ...)</span></div>

<div><span style=3D"font-family:arial,sans-serif;font-size:13px"><br></span=
></div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">I g=
oogled it, but didn&#39;t find something related directly. Maybe I googled =
the wrong key words. So could you please help to explain this last point, o=
r send me some links to read? Thanks a lot.</span></div>

<div><span style=3D"font-family:arial,sans-serif;font-size:13px"><br></span=
></div><div><span style=3D"font-family:arial,sans-serif;font-size:13px">Bes=
t,</span></div><div><span style=3D"font-family:arial,sans-serif;font-size:1=
3px">Xiaofei</span></div>

</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Tue,=
 Apr 15, 2014 at 9:47 PM, Elliott, Robert (Server Storage) <span dir=3D"ltr=
">&lt;<a href=3D"mailto:Elliott@hp.com" target=3D"_blank">Elliott@hp.com</a=
>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">&gt; On 2014-04-15 17:04, Xi=
aofei Du wrote:<br>
&gt; &gt; [global]<br>
&gt; &gt; bs=3D4k<br>
&gt; &gt; size=3D100m<br>
&gt; &gt; direct=3D1<br>
&gt; &gt; filename=3D100mfile<br>
&gt; &gt;<br>
<br>
</div>A few more tips:<br>
- I don&#39;t see ioengine=3Dlibaio or iodepth=3Dnn in that excerpt.<br>
- use iostat -mxyz 2 while the test is running to see the IO sizes that the=
 block layer is sending to the LLD, how many block layer merges are occurri=
ng, the IO depth being maintained to the LLD, and the IOPS rate.<br>
- set /sys/block/&lt;drive name&gt;/queue/nomerges to 2 to disable block la=
yer/scheduler merging.<br>
- your LLD or controller might have its own cache and/or do sequential merg=
ing (coalescing) too. =C2=A0What controller are you using?<br>
- by using a file, you don&#39;t know whether it&#39;s on the inner tracks =
or outer tracks or somewhere in between.<br>
- by using a file, you don&#39;t know whether it&#39;s fragmented, making s=
equential transfers really random to the drive.<br>
- by using a file, if using an &quot;advanced format&quot; drive (with larg=
e physical sectors), you have to be wary of unaligned transfers. =C2=A0Is t=
he partition aligned so all the accesses really go to the drive aligned to =
4 KiB boundaries?<br>


- by using a tiny file size like 100 MiB, writes could easily get buffered =
in a write cache somewhere along the way; 64 and 128 MiB HDD volatile write=
 cache sizes are common nowadays, and RAID controllers have multi-GiB non-v=
olatile write caches.<br>


- although you didn&#39;t report results with reads, beware that the drive =
could end up serving all 100 MiB of random read data from its cache (reads =
can always be cached, volatile or not), while throwing away sequential pref=
etched read data after returning that data because the drive does not expec=
t the data to be read again.<br>


- to avoid filesystem interference, directly access the drive with /dev/dis=
k/by-path, /dev/disk/by-id, or /dev/sdNN type names (or \\.\PhysicalDriveNN=
 in Windows). =C2=A0If using /dev/sdNN or PhysicalDriveNN, be very careful =
not to overwrite your boot drive, since the mapping can change every reboot=
; I don&#39;t think fio provides any protection from doing so.<br>


<br>
</blockquote></div><br></div>

--089e013c661421de8604f732afd6--

