Return-Path: <Alan.Brunelle@hp.com>
Subject: Bug in fio: infinite loop when using two volumes crafted from one  MD?
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Sep 2009 11:59:49 -0400
Message-Id: <1252684789.5814.29.camel@cail>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: fio@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
List-ID: <fio@vger.kernel.org>

I have a somewhat complex (but practical) situation I'm trying to
measure (looking at Goyal's io-controller patches). 

o  24-disk MD RAID10 set (/dev/md0)

o  12 linear LV volumes crafted from /dev/md0

o  Ext3 FS created on each LV volume

o  16GiB test file created on each FS

# du -s -h /mnt/lv[01]/data.bin
33G     /mnt/lv0/data.bin
33G     /mnt/lv1/data.bin

When I execute the following job file (only using 2 of the 12 files/FS):

[global]
rw=3Drw
rwmixread=3D80
randrepeat=3D1
size=3D32g
direct=3D0
ioengine=3Dlibaio
iodepth=3D32
iodepth_low=3D32
iodepth_batch=3D32
iodepth_batch_complete=3D6
overwrite=3D0
bs=3D4k
runtime=3D30

[lv0]
filename=3D/mnt/lv0/data.bin

[test]
filename=3D/mnt/lv1/data.bin

the I/O portion of the run completes, but whilst attempting to display
the Disk stats it hangs whilst outputting:

...
Run status group 0 (all jobs):
   READ: io=3D3,602MB, aggrb=3D120MB/s, minb=3D61,754KB/s, maxb=3D64,135KB/=
s,
mint=3D30002msec, maxt=3D30005msec
  WRITE: io=3D903MB, aggrb=3D30,813KB/s, minb=3D15,537KB/s, maxb=3D16,016KB=
/s,
mint=3D30002msec, maxt=3D30005msec

Disk stats (read/write):

<<<hangs...>>>

Breaking in (via gdb) yields:
(gdb) where
#0  0x0000000000428bb4 in aggregate_slaves_stats
(masterdu=3D0x7f21bbf511e8)
    at diskutil.c:458
#1  0x000000000042905c in show_disk_util () at diskutil.c:528
#2  0x00000000004121bb in show_run_stats () at stat.c:663
#3  0x000000000040acad in main (argc=3D2, argv=3D0x7fff6b83bba8) at
fio.c:1654

setting a break at:

454                     ios[0] +=3D dus->ios[0];

and using 'cont' & "print *slavedu" yields:

(gdb) print *slavedu
$3 =3D {list =3D {next =3D 0x28000156a7, prev =3D 0x1571500006e19}, slaveli=
st =3D
{
    next =3D 0x7f21bbf513f8, prev =3D 0x7f21bbf513f8}, 
  name =3D 0x74b4 <Address 0x74b4 out of bounds>, 
  sysfs_root =3D 0x4aaa6cce <Address 0x4aaa6cce out of bounds>, 
  path =3D "\030=EF=BF=BD\r\000\000\000\000\000\000\020i=EF=BF=BD!\177\000\=
000\000\000\000
\000\000\000\000\000=EF=BF=BDZ=EF=BF=BDZ\000\000\000\000\024\000\000\000=EF=
=BE=AD=EF=BF=BDdm-1\000\000
\000\000=EF=BF=BDZ=EF=BF=BDZ", '\0' <repeats 12 times>, "=EF=BF=BD\001\000\=
000=EF=BE=AD=EF=BF=BD=EF=BF=BDG=EF=BF=BD!\177\000
\000=EF=BF=BDG=EF=BF=BD!\177\000\000=EF=BF=BDG=EF=BF=BD!\177\000\000=EF=BF=
=BDG=EF=BF=BD!\177\000\000=EF=BF=BDI=EF=BF=BD!\177\000\000=EF=BF=BDW
\203k=EF=BF=BD\177\000\000/sys/block/dm-1/slaves/../../md0/stat", '\0' <rep=
eats
98 times>, major =3D 0, minor =3D 0, 
  dus =3D {ios =3D {0, 0}, merges =3D {0, 0}, sectors =3D {0, 0}, ticks =3D=
 {0,
0}, 
    io_ticks =3D 0, time_in_queue =3D 0}, last_dus =3D {ios =3D {0, 0}, mer=
ges =3D
{0, 
      0}, sectors =3D {0, 0}, ticks =3D {0, 0}, io_ticks =3D 0, time_in_que=
ue
=3D 0}, 
  slaves =3D {next =3D 0x0, prev =3D 0x0}, msec =3D 9, time =3D {tv_sec =3D=
 0, 
    tv_usec =3D 0}, lock =3D 0x0, users =3D 0}
(gdb) cont
Continuing.

Breakpoint 1, aggregate_slaves_stats (masterdu=3D0x7f21bbf511e8)
    at diskutil.c:454
454                     ios[0] +=3D dus->ios[0];
(gdb) print *slavedu
$4 =3D {list =3D {next =3D 0x7f21bbf515e8, prev =3D 0x7f21bbf511e8}, slavel=
ist =3D
{
    next =3D 0x7f21bbf54780, prev =3D 0x7f21bbf54780}, 
  name =3D 0x7f21bbf515c8 "md0", 
  sysfs_root =3D 0x7fff6b8357f0 "/sys/block/dm-1/slaves/../../md0", 
  path =3D "/sys/block/dm-0/slaves/../../md0/stat", '\0' <repeats 218
times>, 
  major =3D 9, minor =3D 0, dus =3D {ios =3D {0, 0}, merges =3D {0, 0}, sec=
tors =3D
{0, 
      0}, ticks =3D {0, 0}, io_ticks =3D 0, time_in_queue =3D 0}, last_dus =
=3D
{ios =3D {
      567924, 118793}, merges =3D {0, 0}, sectors =3D {71929094, 950344},
ticks =3D {
      0, 0}, io_ticks =3D 0, time_in_queue =3D 0}, slaves =3D {
    next =3D 0x7f21bbf515f8, prev =3D 0x7f21bbf543f8}, msec =3D 0, time =3D=
 {
    tv_sec =3D 1252682928, tv_usec =3D 935566}, lock =3D 0x7f21bc973000, us=
ers
=3D 0}
(gdb) cont
Continuing.

Breakpoint 1, aggregate_slaves_stats (masterdu=3D0x7f21bbf511e8)
    at diskutil.c:454
454                     ios[0] +=3D dus->ios[0];
(gdb) print *slavedu
$5 =3D {list =3D {next =3D 0x28000156a7, prev =3D 0x1571500006e19}, slaveli=
st =3D
{
    next =3D 0x7f21bbf513f8, prev =3D 0x7f21bbf513f8}, 
  name =3D 0x74b4 <Address 0x74b4 out of bounds>, 
  sysfs_root =3D 0x4aaa6cce <Address 0x4aaa6cce out of bounds>, 
  path =3D "\030=EF=BF=BD\r\000\000\000\000\000\000\020i=EF=BF=BD!\177\000\=
000\000\000\000
\000\000\000\000\000=EF=BF=BDZ=EF=BF=BDZ\000\000\000\000\024\000\000\000=EF=
=BE=AD=EF=BF=BDdm-1\000\000
\000\000=EF=BF=BDZ=EF=BF=BDZ", '\0' <repeats 12 times>, "=EF=BF=BD\001\000\=
000=EF=BE=AD=EF=BF=BD=EF=BF=BDG=EF=BF=BD!\177\000
\000=EF=BF=BDG=EF=BF=BD!\177\000\000=EF=BF=BDG=EF=BF=BD!\177\000\000=EF=BF=
=BDG=EF=BF=BD!\177\000\000=EF=BF=BDI=EF=BF=BD!\177\000\000=EF=BF=BDW
\203k=EF=BF=BD\177\000\000/sys/block/dm-1/slaves/../../md0/stat", '\0' <rep=
eats
98 times>, major =3D 0, minor =3D 0, 
  dus =3D {ios =3D {0, 0}, merges =3D {0, 0}, sectors =3D {0, 0}, ticks =3D=
 {0,
0}, 
    io_ticks =3D 0, time_in_queue =3D 0}, last_dus =3D {ios =3D {0, 0}, mer=
ges =3D
{0, 
      0}, sectors =3D {0, 0}, ticks =3D {0, 0}, io_ticks =3D 0, time_in_que=
ue
=3D 0}, 
  slaves =3D {next =3D 0x0, prev =3D 0x0}, msec =3D 9, time =3D {tv_sec =3D=
 0, 
    tv_usec =3D 0}, lock =3D 0x0, users =3D 0}

and then it seems to be bouncing between these two "things". 

Now using a totally separate disk & FS & data file:

# du -s -h /mnt/lv0/data.bin /mnt/test/data.bin 
33G     /mnt/lv0/data.bin
33G     /mnt/test/data.bin

(/mnt/test is *not* constructed from the MD device) 

and changing the job file to look like:

[test]
filename=3D/mnt/test/data.bin

(Removing the /dev/vg/lv1 file)

It runs to completion correctly.

It seems to me that there may be some error in the logic dealing with
finding the underlying devices for different mount points/files the come
to the same underlying device (/dev/md0, in this case?)? 

Alan





