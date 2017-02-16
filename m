Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:35035 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752609AbdBPFx5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 16 Feb 2017 00:53:57 -0500
Received: by mail-ua0-f170.google.com with SMTP id y9so4655490uae.2
        for <fio@vger.kernel.org>; Wed, 15 Feb 2017 21:53:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DM5PR10MB16252D3CAB3A3F949AD3F6B09D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
References: <DM5PR10MB1625AEDC8488B039FBE439BF9D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
 <DM5PR10MB16252D3CAB3A3F949AD3F6B09D5B0@DM5PR10MB1625.namprd10.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 16 Feb 2017 05:53:26 +0000
Message-ID: <CALjAwxiZVynB8VtcYtxGy6iTwwh0GLg5DmAunSuhA2H18__3dQ@mail.gmail.com>
Subject: Re: Has anyone run into write_bw_log and write_io_log recording
 segments of low numbers?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Todd Lawall <tlawall@pivot3.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

Something to investigate is the latency at the problem point - I'm
going to guess you see latencies above 1 second in your fio log. Don't
forget you're not using direct=3D1 so you also have your operating
system's write buffering in the mix too.

Imagine I do a run where I lose network connectivity to my iSCSI
target for two seconds. During that point any I/O I was doing will now
take at least two seconds to complete. Let's pretend that the
I/O that happened took exactly two seconds to complete and was for a
256Kbytes block. This means that particular I/O's "I/Os per second" is
0 ((1 IO)/2 seconds gives 0 because we don't have fractional iops) but
its bandwidth is 128Kbytes/s (256Kbytes/2 seconds). This is
simplification because you still have your operating system's write
buffering but if that totally fills up this effect will come in to
play.

On Linux I have a slow device that delay's I/Os for 2000 milliseconds made =
with
dmsetup create zero1g --table '0 2097152 zero'
dmsetup create slow --table '0 2097152 delay /dev/mapper/zero1g 0 2000'

I ran fio against it
fio --name=3Dslowtest --rw=3Dread --filename /dev/mapper/slow --runtime=3D5=
s
--write_bw_log=3Dslowtest --write_iops_log=3Dslowtest
--write_lat_log=3Dslowtest --bs=3D64k --direct=3D1
slowtest: (g=3D0): rw=3Dread,
bs=3D64.0KiB-64.0KiB,64.0KiB-64.0KiB,64.0KiB-64.0KiB, ioengine=3Dpsync,
iodepth=3D1
fio-2.17-48-g93f58-dirty
Starting 1 process
Jobs: 1 (f=3D1): [R(1)][0.0%][r=3D0KiB/s,w=3D0KiB/s][r=3D0,w=3D0 IOPS][eta =
13h:39m:06s]
slowtest: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D21804: Thu Feb 16 05:46:=
49 2017
   read: IOPS=3D0, BW=3D31.1KiB/s (32.8kB/s)(192KiB/6012msec)
    clat (usec): min=3D2003.9k, max=3D2003.1k, avg=3D2003914.67, stdev=3D46=
.20
     lat (usec): min=3D2003.9k, max=3D2003.1k, avg=3D2003916.33, stdev=3D45=
.62
    clat percentiles (msec):
     |  1.00th=3D[ 2008],  5.00th=3D[ 2008], 10.00th=3D[ 2008], 20.00th=3D[=
 2008],
     | 30.00th=3D[ 2008], 40.00th=3D[ 2008], 50.00th=3D[ 2008], 60.00th=3D[=
 2008],
     | 70.00th=3D[ 2008], 80.00th=3D[ 2008], 90.00th=3D[ 2008], 95.00th=3D[=
 2008],
     | 99.00th=3D[ 2008], 99.50th=3D[ 2008], 99.90th=3D[ 2008], 99.95th=3D[=
 2008],
     | 99.99th=3D[ 2008]
   bw (  KiB/s): min=3D   32, max=3D   32, per=3D0.10%, avg=3D32.00, stdev=
=3D 0.00
    lat (msec) : >=3D2000=3D100.00%
  cpu          : usr=3D0.00%, sys=3D0.00%, ctx=3D3, majf=3D0, minf=3D32
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwt: total=3D3,0,0, short=3D0,0,0, dropped=3D0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D31.1KiB/s (32.8kB/s), 31.1KiB/s-31.1KiB/s
(32.8kB/s-32.8kB/s), io=3D192KiB (197kB), run=3D6012-6012msec

Examining the files I see this:
# head slowtest_*
=3D=3D> slowtest_bw.1.log <=3D=3D
2004, 32, 0, 65536
4007, 32, 0, 65536
6011, 32, 0, 65536

=3D=3D> slowtest_clat.1.log <=3D=3D
2003, 2003887, 0, 65536
4007, 2003889, 0, 65536
6011, 2003968, 0, 65536

=3D=3D> slowtest_iops.1.log <=3D=3D
2004, 1, 0, 65536
4007, 1, 0, 65536
6011, 1, 0, 65536

=3D=3D> slowtest_lat.1.log <=3D=3D
2003, 2003889, 0, 65536
4007, 2003891, 0, 65536
6011, 2003969, 0, 65536

On 15 February 2017 at 22:57, Todd Lawall <tlawall@pivot3.com> wrote:
> Sorry, forgot to mention that this is on a windows client, running versio=
n fio-2.16-1-g3ab9.
>
>
> From: fio-owner@vger.kernel.org <fio-owner@vger.kernel.org> on behalf of =
Todd Lawall <tlawall@pivot3.com>
> Subject: Has anyone run into write_bw_log and write_io_log recording segm=
ents of low numbers?
>
> I've been running fio on an iSCSI volume where I can monitor things like =
the network traffic (to ensure that indeed it is flowing) as well as on the=
 machine the volume is hosted on.  I'm seeing a steady state of 300MB/s, bu=
t when I stop  the FIO process and writes the detailed bandwidth and iops l=
ogs, there's segments where iops drop to 0, but bandwidth for the same time=
 point is somewhere around the single digits or teens.
>
> Has anyone else seen this behavior?  Does anyone have an idea why I might=
 be seeing this?  Here is the job file I ran:
>
> [global]
> ioengine=3Dwindowsaio
> do_verify=3D0
> offset=3D0
> write_bw_log=3DC:\\haggis\\manualfio\\stats-running
> write_iops_log=3DC:\\haggis\\manualfio\\stats-running
> write_lat_log=3DC:\\haggis\\manualfio\\stats-running
> verify=3Dcrc32c-intel
> runtime=3D292000
> thread
>
> [fio-0]
> filename=3D\\.\PhysicalDrive1
> iodepth=3D1
> blocksize=3D256k
> readwrite=3Dwrite
>
> [fio-1]
> filename=3D\\.\PhysicalDrive2
> iodepth=3D1
> blocksize=3D256k
> readwrite=3Dwrite

--=20
Sitsofe | http://sucs.org/~sits/
