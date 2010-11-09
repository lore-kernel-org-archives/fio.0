Return-Path: <bart.vanassche@gmail.com>
MIME-Version: 1.0
From: Bart Van Assche <bvanassche@acm.org>
Sender: "bart.vanassche@gmail.com" <bart.vanassche@gmail.com>
Date: Tue, 9 Nov 2010 04:53:41 -0700
Subject: Re: RFC: Data pattern buffer filling race condition fix
Message-ID: <AANLkTinSscynOzVHfNO_fFMyuqgaaEN0tJTK6GHpj=54@mail.gmail.com>
References: <201011061035.18709.bvanassche@acm.org>
 <4CD690DF.6090807@fusionio.com>
 <AANLkTimVcMvOH55xZvTFHxbZHesTXoyi=Y3bRqnALLTS@mail.gmail.com>
 <4CD7F53E.1050201@fusionio.com>
In-Reply-To: <4CD7F53E.1050201@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Radha Ramachandran <radha@google.com>
List-ID: <fio@vger.kernel.org>

On Mon, Nov 8, 2010 at 2:03 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> On 2010-11-07 13:58, Bart Van Assche wrote:
> > On Sun, Nov 7, 2010 at 12:43 PM, Jens Axboe <jaxboe@fusionio.com> wrote=
:
> >>
> >> On 2010-11-06 10:35, Bart Van Assche wrote:
> >>> On multicore non-x86 CPUs fio has been observed to frequently reports=
 false
> >>> data verification failures with I/O engine libaio and I/O depths abov=
e one.
> >>> This is because of a race condition in the function fill_pattern(). T=
he code
> >>> in that function only works correct if all CPUs of a multicore system
> >>> observe store instructions in the order they were issued. That is the=
 case for
> >>> multicore x86 systems but not for all other CPU families, such as e.g=
. the
> >>> POWER CPU family.
> >>>
> >>> [ ... ]
>
> Forgive me, but I'm still a little confused. This second write_barrier()
> is now protecting against the order of the fill and the length
> assignment. IOW, if you see the new length, you are guaranteed to also
> see the new content. This means that the first memory barrier should be
> a read_barrier().
>
> And ditto for the other case.
>
> Can you verify whether that works as expected and send an updated patch?

Hello Jens,

I'm afraid that I will have to do more testing and that I'll have to
make sure that I understand the entire fio code base before I can
develop and send a new patch - something I do not have the time for
now unfortunately. I ran into this issue on 32-bit 2.6.34.7 kernel
while running a test on a local ext3 filesystem, something I will have
to analyze further before I can proceed:

$ valgrind ./fio --ioengine=3Dlibaio --overwrite=3D1 --verify=3Dmd5
--iodepth=3D10 --direct=3D1 --loops=3D10 --size=3D1MB --name=3Dtest --threa=
d
--numjobs=3D10 --group_reporting
=3D=3D13318=3D=3D Memcheck, a memory error detector
=3D=3D13318=3D=3D Copyright (C) 2002-2010, and GNU GPL'd, by Julian Seward =
et al.
=3D=3D13318=3D=3D Using Valgrind-3.7.0.SVN and LibVEX; rerun with -h for co=
pyright info
=3D=3D13318=3D=3D Command: ./fio --ioengine=3Dlibaio --overwrite=3D1 --veri=
fy=3Dmd5
--iodepth=3D10 --direct=3D1 --loops=3D10 --size=3D1MB --name=3Dtest --threa=
d
--numjobs=3D10 --group_reporting
=3D=3D13318=3D=3D
test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=3D10
...
test: (g=3D0): rw=3Dread, bs=3D4K-4K/4K-4K, ioengine=3Dlibaio, iodepth=3D10
Starting 10 threads
verify: bad magic header 0, wanted f00baaef at file test.9.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.2.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.3.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.3.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.8.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.8.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.2.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.1.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.1.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.6.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.6.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.5.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.5.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.4.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.4.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.7.0 offset 0, leng=
th 0
verify: bad magic header 0, wanted f00baaef at file test.7.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.10.0 offset 0, len=
gth 0
verify: bad magic header 0, wanted f00baaef at file test.10.0 offset
4096, length 0
verify: bad magic header 0, wanted f00baaef at file test.9.0 offset
4096, length 0
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character
fio: pid=3D13318, err=3D84/file:io_u.c:1346, func=3Dio_u_queued_complete,
error=3DInvalid or incomplete multibyte or wide character

test: (groupid=3D0, jobs=3D10): err=3D84 (file:io_u.c:1346,
func=3Dio_u_queued_complete, error=3DInvalid or incomplete multibyte or
wide character): pid=3D13318
  read : io=3D81920 B, bw=3D576901 B/s, iops=3D704 , runt=3D   142msec
    slat (usec): min=3D26 , max=3D6642 , avg=3D40.86, stdev=3D21.59
    clat (msec): min=3D1 , max=3D99 , avg=3D41.51, stdev=3D 6.25
     lat (msec): min=3D1 , max=3D100 , avg=3D41.56, stdev=3D 6.25
  cpu          : usr=3D73.15%, sys=3D20.23%, ctx=3D598, majf=3D0, minf=3D14=
05
  IO depths    : 1=3D10.0%, 2=3D20.0%, 4=3D40.0%, 8=3D30.0%, 16=3D0.0%, 32=
=3D0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued r/w/d: total=3D100/0/0, short=3D0/0/0

     lat (msec): 2=3D1.00%, 4=3D3.00%, 10=3D1.00%, 50=3D6.00%, 100=3D9.00%

Run status group 0 (all jobs):
   READ: io=3D80KB, aggrb=3D563KB/s, minb=3D576KB/s, maxb=3D576KB/s,
mint=3D142msec, maxt=3D142msec

Disk stats (read/write):
  sda: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D-nan%
=3D=3D13318=3D=3D
=3D=3D13318=3D=3D HEAP SUMMARY:
=3D=3D13318=3D=3D     in use at exit: 18,102 bytes in 114 blocks
=3D=3D13318=3D=3D   total heap usage: 370 allocs, 256 frees, 849,743 bytes =
allocated
=3D=3D13318=3D=3D
=3D=3D13318=3D=3D LEAK SUMMARY:
=3D=3D13318=3D=3D    definitely lost: 2,401 bytes in 40 blocks
=3D=3D13318=3D=3D    indirectly lost: 15,680 bytes in 70 blocks
=3D=3D13318=3D=3D      possibly lost: 0 bytes in 0 blocks
=3D=3D13318=3D=3D    still reachable: 21 bytes in 4 blocks
=3D=3D13318=3D=3D         suppressed: 0 bytes in 0 blocks
=3D=3D13318=3D=3D Rerun with --leak-check=3Dfull to see details of leaked m=
emory
=3D=3D13318=3D=3D
=3D=3D13318=3D=3D For counts of detected and suppressed errors, rerun with:=
 -v
=3D=3D13318=3D=3D ERROR SUMMARY: 0 errors from 0 contexts (suppressed: 5 fr=
om 5)

Bart.

