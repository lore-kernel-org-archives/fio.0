Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C586C433EF
	for <fio@archiver.kernel.org>; Wed, 18 May 2022 19:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242086AbiERTyK (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 18 May 2022 15:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiERTyJ (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 May 2022 15:54:09 -0400
X-Greylist: delayed 567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 12:54:06 PDT
Received: from submit-01.torproject.org (submit-01.torproject.org [116.202.120.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 909F2227068
        for <fio@vger.kernel.org>; Wed, 18 May 2022 12:54:06 -0700 (PDT)
Received: from localhost (localhost [::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: anarcat)
        by submit-01.torproject.org (Postfix) with ESMTPSA id EF56180124
        for <fio@vger.kernel.org>; Wed, 18 May 2022 19:44:34 +0000 (UTC)
Received: by curie.anarc.at (Postfix, from userid 1000)
        id 49A9312041C; Wed, 18 May 2022 15:44:33 -0400 (EDT)
From:   =?utf-8?Q?Antoine_Beaupr=C3=A9?= <anarcat@torproject.org>
To:     fio@vger.kernel.org
Subject: running jobs serially
Organization: Tor
Date:   Wed, 18 May 2022 15:44:31 -0400
Message-ID: <87pmkaeicg.fsf@curie.anarc.at>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

One of the things I've been struggling for with fio for a while is how
to run batches of jobs with it.

I know I can call fio multiple times with different job files or
parameters, that's easy. But what I'd like to do is have a *single* job
file (or even multiple, actually) that would describe *multiple*
workloads that would need to be tested.

In particular, I'm looking for a way to reproduce the benchmarks
suggested here:

https://arstechnica.com/gadgets/2020/02/how-fast-are-your-disks-find-out-th=
e-open-source-way-with-fio/

... without having to write all the glue the author had to make here:

https://github.com/jimsalterjrs/fio-test-scaffolding/

... which is quite a bit of goo.

I was hoping a simple thing like this would just do it:

[global]
# cargo-culting Salter
fallocate=3Dnone
ioengine=3Dposixaio
runtime=3D60
time_based=3D1
end_fsync=3D1
stonewall=3D1
group_reporting=3D1

# Single 4KiB random read/write process
[randread-4k-4g-1x]
stonewall=3D1
rw=3Drandread
bs=3D4k
size=3D4g
numjobs=3D1
iodepth=3D1

[randwrite-4k-4g-1x]
stonewall=3D1
rw=3Drandwrite
bs=3D4k
size=3D4g
numjobs=3D1
iodepth=3D1

... but looking at the "normal" --output-format, it *looks* like the
jobs are all started at the same time. The files certainly seem to be
allocated all at once:

root@curie:/home# fio ars.fio=20
randread-4k-4g-1x: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-=
4096B, (T) 4096B-4096B, ioengine=3Dposixaio, iodepth=3D1
randwrite-4k-4g-1x: (g=3D1): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096=
B-4096B, (T) 4096B-4096B, ioengine=3Dposixaio, iodepth=3D1
fio-3.25
Starting 2 processes
Jobs: 1 (f=3D1): [r(1),P(1)][0.0%][r=3D16.5MiB/s][r=3D4228 IOPS][eta 49710d=
:06h:28m:14s]
randread-4k-4g-1x: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1033470: Wed Ma=
y 18 15:41:04 2022
  read: IOPS=3D4754, BW=3D18.6MiB/s (19.5MB/s)(18.6MiB/1001msec)
    slat (nsec): min=3D1429, max=3D391678, avg=3D3239.76, stdev=3D6013.78
    clat (usec): min=3D163, max=3D6917, avg=3D205.05, stdev=3D108.47
     lat (usec): min=3D166, max=3D7308, avg=3D208.29, stdev=3D114.12
    clat percentiles (usec):
     |  1.00th=3D[  169],  5.00th=3D[  174], 10.00th=3D[  174], 20.00th=3D[=
  178],
     | 30.00th=3D[  182], 40.00th=3D[  184], 50.00th=3D[  196], 60.00th=3D[=
  200],
     | 70.00th=3D[  204], 80.00th=3D[  215], 90.00th=3D[  239], 95.00th=3D[=
  269],
     | 99.00th=3D[  412], 99.50th=3D[  478], 99.90th=3D[  635], 99.95th=3D[=
 1045],
     | 99.99th=3D[ 6915]
   bw (  KiB/s): min=3D19248, max=3D19248, per=3D100.00%, avg=3D19248.00, s=
tdev=3D 0.00, samples=3D1
   iops        : min=3D 4812, max=3D 4812, avg=3D4812.00, stdev=3D 0.00, sa=
mples=3D1
  lat (usec)   : 250=3D92.79%, 500=3D6.81%, 750=3D0.34%
  lat (msec)   : 2=3D0.04%, 10=3D0.02%
  cpu          : usr=3D2.90%, sys=3D2.90%, ctx=3D4767, majf=3D0, minf=3D44
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D4759,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
randwrite-4k-4g-1x: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D1033477: Wed M=
ay 18 15:41:04 2022
  write: IOPS=3D32.3k, BW=3D126MiB/s (132MB/s)(174MiB/1378msec); 0 zone res=
ets
    slat (nsec): min=3D955, max=3D326042, avg=3D2726.11, stdev=3D2538.38
    clat (nsec): min=3D343, max=3D6896.5k, avg=3D18139.12, stdev=3D69899.75
     lat (usec): min=3D10, max=3D6899, avg=3D20.87, stdev=3D70.02
    clat percentiles (usec):
     |  1.00th=3D[   11],  5.00th=3D[   11], 10.00th=3D[   12], 20.00th=3D[=
   12],
     | 30.00th=3D[   13], 40.00th=3D[   13], 50.00th=3D[   14], 60.00th=3D[=
   15],
     | 70.00th=3D[   16], 80.00th=3D[   18], 90.00th=3D[   26], 95.00th=3D[=
   34],
     | 99.00th=3D[   62], 99.50th=3D[   91], 99.90th=3D[  231], 99.95th=3D[=
  326],
     | 99.99th=3D[ 4047]
   bw (  KiB/s): min=3D196064, max=3D196064, per=3D100.00%, avg=3D196064.00=
, stdev=3D 0.00, samples=3D1
   iops        : min=3D49016, max=3D49016, avg=3D49016.00, stdev=3D 0.00, s=
amples=3D1
  lat (nsec)   : 500=3D0.01%, 750=3D0.01%
  lat (usec)   : 2=3D0.01%, 4=3D0.01%, 10=3D0.21%, 20=3D83.60%, 50=3D14.51%
  lat (usec)   : 100=3D1.22%, 250=3D0.37%, 500=3D0.03%, 1000=3D0.01%
  lat (msec)   : 2=3D0.01%, 4=3D0.01%, 10=3D0.01%
  cpu          : usr=3D11.84%, sys=3D18.01%, ctx=3D46292, majf=3D0, minf=3D=
46
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,44457,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
   READ: bw=3D18.6MiB/s (19.5MB/s), 18.6MiB/s-18.6MiB/s (19.5MB/s-19.5MB/s)=
, io=3D18.6MiB (19.5MB), run=3D1001-1001msec

Run status group 1 (all jobs):
  WRITE: bw=3D126MiB/s (132MB/s), 126MiB/s-126MiB/s (132MB/s-132MB/s), io=
=3D174MiB (182MB), run=3D1378-1378msec

Disk stats (read/write):
    dm-2: ios=3D4759/43132, merge=3D0/0, ticks=3D864/7281132, in_queue=3D72=
81996, util=3D67.32%, aggrios=3D4759/43181, aggrmerge=3D0/0, aggrticks=3D86=
4/7378584, aggrin_queue=3D7379448, aggrutil=3D67.17%
    dm-0: ios=3D4759/43181, merge=3D0/0, ticks=3D864/7378584, in_queue=3D73=
79448, util=3D67.17%, aggrios=3D4759/43124, aggrmerge=3D0/57, aggrticks=3D7=
78/8680, aggrin_queue=3D9487, aggrutil=3D67.02%
  sda: ios=3D4759/43124, merge=3D0/57, ticks=3D778/8680, in_queue=3D9487, u=
til=3D67.02%


Those timestamps, specifically, should not be the same:

randwrite-4k-4g-1x: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D1033477: Wed M=
ay 18 15:41:04 2022
randread-4k-4g-1x: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D1033470: Wed Ma=
y 18 15:41:04 2022

Am I missing something? Or are job files just *not* designed to run
things serially?

I looked in the archives for this, and only found this (unfulfilled,
AFAICT) request:

https://lore.kernel.org/fio/CANvN+emA01TZfbBx4aU+gg5CKfy+AEX_gZW7Jz4HMHvwkd=
BNoQ@mail.gmail.com/

and:

https://lore.kernel.org/fio/MWHPR04MB0320ED986E73B1E9994929B38F470@MWHPR04M=
B0320.namprd04.prod.outlook.com/

... but that talks about serialize_overlap which seems to be specific to
handling requests sent in parallel, not serializing jobs themselves.

For now, it feels like i need to revert to shell scripts and that's kind
of a little annoying: it would be really nice to be able to carry a full
workfload in a single job file.

Thanks, and sorry if that's a dumb question. :)

=2D-=20
Antoine Beaupr=C3=A9
torproject.org system administration

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEexZCBNCWcjsBljWrPqHd3bJh2XsFAmKFTKAACgkQPqHd3bJh
2Xu/fgf+KY4NGLIC+fZQjuUgD8OPKFQ8uUmhWUv/6K7FasMpn6C7FXU+GPzr0JiW
MGi7kBqGly9BZjnJ1L1l6QQgE9SG8IvgjB1ODebqRSL2EJgZpKHIb0Eqadf+ry/A
UxTjQW4ah2GAcO+c4oqqSTDY/QE9KuMrw2rHnS71aIPAQid29u+FvkIUSLO0opPX
wv+23wYnmxHAaR0kRRiZH1CZALwI3A/ulfTzEneqaScSX82oYOef6c2dxhGK6uS0
L2SgFf81WzWyXW82hM2jGpiinQs3sJxeHJVgSRyPmwCZHXRkZrPO23svKXgnV2UA
f8jKA+/lEYAfh/hVvJ/IxSv1JUndiQ==
=yjX0
-----END PGP SIGNATURE-----
--=-=-=--
