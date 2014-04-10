Return-Path: <prvs=1177ddc46d=mario.carino@aig.com>
From: "Carino, Mario" <Mario.Carino@AIG.com>
Date: Thu, 10 Apr 2014 12:22:49 -0400
Subject: RE: fio on AIX - fallocate error
Message-ID: <E2B4022DB0264A4B90C5F1B01B8E677D73322971@LIVP3MMBX13.mail.aig.net>
References: <E2B4022DB0264A4B90C5F1B01B8E677D733225E0@LIVP3MMBX13.mail.aig.net>
 <5346A3FE.10106@kernel.dk>
In-Reply-To: <5346A3FE.10106@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Here's the output. No need to break as it stopped immediately. All of the 4=
ktest files are zero length.

Command line
./fio  --debug=3Dfile  examples/test1.fio

fio: set debug option file
file     48824354 dup files: 0
file     48824354 add file 4ktest.0.0
file     48824354 resize file array to 2 files
file     48824354 file b0002028 "4ktest.0.0" added at 0
4ktest: (g=3D0): rw=3Drandwrite, bs=3D4K-4K/4K-4K/4K-4K, ioengine=3Dsync, i=
odepth=3D16
file     48824354 dup files: 1
file     48824354 add file 4ktest.15.0
file     48824354 resize file array to 2 files
file     48824354 file b00022a8 "4ktest.15.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.14.0
file     48824354 resize file array to 2 files
file     48824354 file b0002528 "4ktest.14.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.13.0
file     48824354 resize file array to 2 files
file     48824354 file b00027a8 "4ktest.13.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.12.0
file     48824354 resize file array to 2 files
file     48824354 file b0002a28 "4ktest.12.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.11.0
file     48824354 resize file array to 2 files
file     48824354 file b0002ca8 "4ktest.11.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.10.0
file     48824354 resize file array to 2 files
file     48824354 file b0002f28 "4ktest.10.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.9.0
file     48824354 resize file array to 2 files
file     48824354 file b00031a8 "4ktest.9.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.8.0
file     48824354 resize file array to 2 files
file     48824354 file b0003428 "4ktest.8.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.7.0
file     48824354 resize file array to 2 files
file     48824354 file b00036a8 "4ktest.7.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.6.0
file     48824354 resize file array to 2 files
file     48824354 file b0003928 "4ktest.6.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.5.0
file     48824354 resize file array to 2 files
file     48824354 file b0003ba8 "4ktest.5.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.4.0
file     48824354 resize file array to 2 files
file     48824354 file b0003e28 "4ktest.4.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.3.0
file     48824354 resize file array to 2 files
file     48824354 file b00040a8 "4ktest.3.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.2.0
file     48824354 resize file array to 2 files
file     48824354 file b0004328 "4ktest.2.0" added at 0
file     48824354 dup files: 1
file     48824354 add file 4ktest.1.0
file     48824354 resize file array to 2 files
file     48824354 file b00045a8 "4ktest.1.0" added at 0
...
fio-2.1.7
Starting 16 processes
file     48824354 setup files
file     48824354 get file size for b0002028/0/b0002148
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.0.0
file     48824354 open file 4ktest.0.0, flags 101
file     48824354 posix_fallocate file 4ktest.0.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00022a8/0/b00023c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.15.0
file     48824354 open file 4ktest.15.0, flags 101
file     48824354 posix_fallocate file 4ktest.15.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0002528/0/b0002648
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.14.0
file     48824354 open file 4ktest.14.0, flags 101
file     48824354 posix_fallocate file 4ktest.14.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00027a8/0/b00028c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.13.0
file     48824354 open file 4ktest.13.0, flags 101
file     48824354 posix_fallocate file 4ktest.13.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0002a28/0/b0002b48
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.12.0
file     48824354 open file 4ktest.12.0, flags 101
file     48824354 posix_fallocate file 4ktest.12.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0002ca8/0/b0002dc8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.11.0
file     48824354 open file 4ktest.11.0, flags 101
file     48824354 posix_fallocate file 4ktest.11.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0002f28/0/b0003048
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.10.0
file     48824354 open file 4ktest.10.0, flags 101
file     48824354 posix_fallocate file 4ktest.10.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00031a8/0/b00032c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.9.0
file     48824354 open file 4ktest.9.0, flags 101
file     48824354 posix_fallocate file 4ktest.9.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0003428/0/b0003548
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.8.0
file     48824354 open file 4ktest.8.0, flags 101
file     48824354 posix_fallocate file 4ktest.8.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00036a8/0/b00037c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.7.0
file     48824354 open file 4ktest.7.0, flags 101
file     48824354 posix_fallocate file 4ktest.7.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0003928/0/b0003a48
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.6.0
file     48824354 open file 4ktest.6.0, flags 101
file     48824354 posix_fallocate file 4ktest.6.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0003ba8/0/b0003cc8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.5.0
file     48824354 open file 4ktest.5.0, flags 101
file     48824354 posix_fallocate file 4ktest.5.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0003e28/0/b0003f48
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.4.0
file     48824354 open file 4ktest.4.0, flags 101
file     48824354 posix_fallocate file 4ktest.4.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00040a8/0/b00041c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.3.0
file     48824354 open file 4ktest.3.0, flags 101
file     48824354 posix_fallocate file 4ktest.3.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b0004328/0/b0004448
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.2.0
file     48824354 open file 4ktest.2.0, flags 101
file     48824354 posix_fallocate file 4ktest.2.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument
file     48824354 setup files
file     48824354 get file size for b00045a8/0/b00046c8
4ktest: Laying out IO file(s) (1 file(s) / 2048MB)
file     48824354 layout unlink 4ktest.1.0
file     48824354 open file 4ktest.1.0, flags 101
file     48824354 posix_fallocate file 4ktest.1.0 size 2147483648
fio: posix_fallocate fails: Invalid argument
fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache, error=
=3DInvalid argument


Run status group 0 (all jobs):







Mario Carino


-----Original Message-----
From: Jens Axboe [mailto:axboe@kernel.dk]=20
Sent: Thursday, April 10, 2014 10:00 AM
To: Carino, Mario; fio@vger.kernel.org
Subject: Re: fio on AIX - fallocate error

On 2014-04-09 20:52, Carino, Mario wrote:
> Hi.
> We're trying to run fio 2.1.7 on AIX 6 and we can't seem to eliminate the=
se errors:
>
> fio: posix_fallocate fails: Invalid argument

This one you can ignore, or you can get rid of it by adding:

fallocate=3Dnone

to the job file.

> fio: pid=3D0, err=3D22/file:filesetup.c:418, func=3Dinvalidate_cache,=20
> error=3DInvalid argument

Fio should probably just ignore these flush-cache warnings and continue on,=
 it's not really a fatal condition. I have attached a patch for you, can yo=
u apply that and give it a go?

> we always get one or the other. It doesn't matter too much what=20
> command we run, what options,  etc. We saw a web page which indicates=20
> that fio requires an Asynch IO package to be installed and running on=20
> AIX. Is that correct? We're
 > trying to find out if we have it installed on our test box.

You'd get a different error if that was your issue.

> (We're lowly non-root
 > DBA's so getting anything done requires a committee.)

Isn't that always the case with AIX? :-)

--
Jens Axboe


