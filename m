Return-Path: <bruce@cran.org.uk>
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: Question about FIO sequential writes
From: Bruce Cran <bruce@cran.org.uk>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
Date: Mon, 21 Apr 2014 10:38:00 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <6CDB5463-C1E6-46E0-8888-5016654122E0@cran.org.uk>
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com> <534DB18A.4050507@kernel.dk> <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com> <534DE08D.2070604@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B402956EDA0F2@G9W0745.americas.hpqcorp.net>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, Xiaofei Du <xiaofei.du008@gmail.com>, fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

Windows prevents you from overwriting a block if it contains a mounted volum=
e.

Bruce

Sent from my iPhone

On Apr 15, 2014, at 10:47 PM, "Elliott, Robert (Server Storage)" <Elliott@hp=
.com> wrote:

>>> On 2014-04-15 17:04, Xiaofei Du wrote:
>>> [global]
>>> bs=3D4k
>>> size=3D100m
>>> direct=3D1
>>> filename=3D100mfile
>=20
> A few more tips:
> - I don't see ioengine=3Dlibaio or iodepth=3Dnn in that excerpt.
> - use iostat -mxyz 2 while the test is running to see the IO sizes that th=
e block layer is sending to the LLD, how many block layer merges are occurri=
ng, the IO depth being maintained to the LLD, and the IOPS rate.
> - set /sys/block/<drive name>/queue/nomerges to 2 to disable block layer/s=
cheduler merging.
> - your LLD or controller might have its own cache and/or do sequential mer=
ging (coalescing) too.  What controller are you using?
> - by using a file, you don't know whether it's on the inner tracks or oute=
r tracks or somewhere in between.
> - by using a file, you don't know whether it's fragmented, making sequenti=
al transfers really random to the drive.
> - by using a file, if using an "advanced format" drive (with large physica=
l sectors), you have to be wary of unaligned transfers.  Is the partition al=
igned so all the accesses really go to the drive aligned to 4 KiB boundaries=
?=20
> - by using a tiny file size like 100 MiB, writes could easily get buffered=
 in a write cache somewhere along the way; 64 and 128 MiB HDD volatile write=
 cache sizes are common nowadays, and RAID controllers have multi-GiB non-vo=
latile write caches.
> - although you didn't report results with reads, beware that the drive cou=
ld end up serving all 100 MiB of random read data from its cache (reads can a=
lways be cached, volatile or not), while throwing away sequential prefetched=
 read data after returning that data because the drive does not expect the d=
ata to be read again.
> - to avoid filesystem interference, directly access the drive with /dev/di=
sk/by-path, /dev/disk/by-id, or /dev/sdNN type names (or \\.\PhysicalDriveNN=
 in Windows).  If using /dev/sdNN or PhysicalDriveNN, be very careful not to=
 overwrite your boot drive, since the mapping can change every reboot; I don=
't think fio provides any protection from doing so.
>=20
> N=E2=80=B9=C2=A7=C2=B2=C3=A6=C3=ACr=C2=B8=E2=80=BAy=C3=BA=C3=A8=C5=A1=C3=98=
b=C2=B2X=C2=AC=C2=B6=C3=87=C2=A7v=C3=98^=E2=80=93)=C3=9E=C2=BA{.n=C3=87+=E2=80=
=B0=C2=B7=C5=B8=C5=A0=CB=86=C2=A7=C2=B6=17=E2=80=BA=C2=A1=C3=9C=C2=A8}=C2=A9=
=C5=BE=C2=B2=C3=86 z=C3=9A&j:+v=E2=80=B0=C2=A8=C2=BE=07=C2=AB=E2=80=98=C3=AA=
=C3=A7zZ+=E2=82=AC=C3=8A+zf=C2=A3=C2=A2=C2=B7h=C5=A1=CB=86=C2=A7~=E2=80=A0=C2=
=AD=E2=80=A0=C3=9Bi=C3=BF=C3=BB=C3=A0z=C2=B9=1E=C2=AEw=C2=A5=C2=A2=C2=B8?=E2=
=84=A2=C2=A8=C3=A8=C2=AD=C3=9A&=C2=A2)=C3=9F=C2=A2=1Bf

