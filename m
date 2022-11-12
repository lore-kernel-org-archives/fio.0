Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01D4C4332F
	for <fio@archiver.kernel.org>; Sat, 12 Nov 2022 06:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiKLGeC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 12 Nov 2022 01:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234051AbiKLGeB (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 12 Nov 2022 01:34:01 -0500
Received: from mail-yw1-x1142.google.com (mail-yw1-x1142.google.com [IPv6:2607:f8b0:4864:20::1142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2851313F77
        for <fio@vger.kernel.org>; Fri, 11 Nov 2022 22:34:00 -0800 (PST)
Received: by mail-yw1-x1142.google.com with SMTP id 00721157ae682-367cd2807f2so61853877b3.1
        for <fio@vger.kernel.org>; Fri, 11 Nov 2022 22:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=potVhPdtFGBopK+qUNZr8/fPXwOP8Fy0Mmj/eF12lNw=;
        b=i5+gP4t29iFuQdGH9jVyCgcewc7T30Y1MfpeNGL+GI26Zc3y3uIBM/w8WyDDvq+wMr
         kNoU4ejZCKSRaD747QruzuZzxyde3aJySAu4xe59eTbf+ULb68RFYDsyRdsyFUvJvT0p
         k/TpLsGOxPt0YjhpCxcrm4l8XHYTk4VsWbkU4Z8pZRzxVmcbIK9TOpFVcO4JCwC3y3Ez
         wMtV8E9bpMOsYV8KVyeHuYLi+dMVcGmTJM+f8iy7f2rFFH2aMQFuhcv4nvmUhvbasamF
         nJb3h5HO7txqiAbvfEoaWuLkznFkEUf7/z6AGWOgwp9NuuhCMq540pB3KtMPAFmFOWKy
         8MHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=potVhPdtFGBopK+qUNZr8/fPXwOP8Fy0Mmj/eF12lNw=;
        b=NIWb0h+XIUcb+9o+tO6gINH9p3bg9/XjwopmBlDcchB5kZ2umP9wPBjMlnf2sXlvhq
         GQB9I2YL0YYwwk9ve4c2B0t6YiWzM4goH1FsFCf8xWy/FZgkiNmwJ0uoD6M9cgF3xnoV
         t4CnavBfq37HHgnRZZz2DYgTJpfeDuo+1BqeTF833G/3bzIb7it/hETQFAgbXeEYDL+2
         d0LA7G2oTO5wqpEiaWfUGqAXMH6HSWAlcOdxlQ2xyvbC8BupfXv4lsLEzOFRS9DXzdia
         9exX6fQ47eVeg+yEZ8UENOzgjWunQgGYrfKz+91eMpQnnWSohjEqDn/uplvgZgs6OeS/
         U0YQ==
X-Gm-Message-State: ANoB5pkHAB/0PI0lnvU8FjFdYJHN3SBarydyn+AzE/MEOF00sGTHzpzG
        RDUS0b/pbkcGiD2iAPe/8z5sXWtjGYh/1RfnyOwF0WS6no24Z9DPZUM=
X-Google-Smtp-Source: AA0mqf4b1kHpFlKmOCYcA2gUf5Q3mPLWxJQkPeEay2XC3ZzG8NMCuHgUDoo/Z7tCoBK2qapkV6KMy7lbpJHGV7uqro0=
X-Received: by 2002:a0d:d741:0:b0:367:7b00:359d with SMTP id
 z62-20020a0dd741000000b003677b00359dmr5190215ywd.217.1668234839199; Fri, 11
 Nov 2022 22:33:59 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:8d81:b0:313:5abd:c626 with HTTP; Fri, 11 Nov 2022
 22:33:58 -0800 (PST)
From:   =?UTF-8?B?5piO56m65oG2?= <artlers@gmail.com>
Date:   Sat, 12 Nov 2022 14:33:58 +0800
Message-ID: <CAHDEAQNY9H5YZeQTBL+kU87qTtBxeEW2A15NdRvVNch9sDK7Jg@mail.gmail.com>
Subject: Bssplit verify problem
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I use fio 3.19 to test NvmeSSD=EF=BC=8Ccmd string is=EF=BC=9A
---------------------------------------------------------------------------=
-----
fio --filename=3D/dev/nvme0n1 --rw=3Drandwrite --offset=3D0 --size=3D10%
--bs=3D128k --iodepth=3D64 --numjobs=3D1 --ioengine=3Dlibaio
--name=3Drandwrite_data --allow_file_create=3D0 --thread --direct=3D1
--group_reporting=3D1 --verify_dump=3D1 --verify_backlog=3D1 --randrepeat=
=3D0
--do_verify=3D1 --verify=3Dpattern --verify_pattern=3D0x51d4b0e0
--bssplit=3D512:4k:16k:32k:64k:128k:1024k
---------------------------------------------------------------------------=
-----

Then a verify error occurs,
---------------------------------------------------------------------------=
-----
randwrite_data: (g=3D0): rw=3Drandwrite, bs=3D(R) 512B-1024KiB, (W)
512B-1024KiB, (T) 512B-1024KiB, ioengine=3Dlibaio, iodepth=3D64
fio-3.19
Starting 1 thread
fio: got pattern '00', wanted '51'. Bad bits 3
fio: bad pattern block offset 384
pattern: verify failed at file /dev/nvme0n1 offset 70523721971, length
3769685073 (requested block: offset=3D68822685696, length=3D1048576)
       received data dumped as nvme0n1.69899573248.received
       expected data dumped as nvme0n1.69899573248.expected
fio: verify type mismatch (57520 media, 18 given)

randwrite_data: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2990: Thu Sep  1 1=
4:10:23 2022
  read: IOPS=3D167M, BW=3D8943GiB/s (9602GB/s)(89.4GiB/10msec)
    slat (nsec): min=3D559, max=3D21279, avg=3D1135.63, stdev=3D853.10
    clat (usec): min=3D13, max=3D51046, avg=3D3229.89, stdev=3D3195.51
     lat (usec): min=3D14, max=3D51053, avg=3D3231.04, stdev=3D3196.01
    clat percentiles (usec):
     |  1.00th=3D[  217],  5.00th=3D[  545], 10.00th=3D[  857], 20.00th=3D[=
 1369],
     | 30.00th=3D[ 1795], 40.00th=3D[ 2147], 50.00th=3D[ 2474], 60.00th=3D[=
 2802],
     | 70.00th=3D[ 3228], 80.00th=3D[ 4080], 90.00th=3D[ 6128], 95.00th=3D[=
 8848],
     | 99.00th=3D[17171], 99.50th=3D[21627], 99.90th=3D[30278], 99.95th=3D[=
33162],
     | 99.99th=3D[38536]
  write: IOPS=3D12.7k, BW=3D698MiB/s (732MB/s)(89.4GiB/131206msec); 0 zone =
resets
    slat (nsec): min=3D639, max=3D36626, avg=3D1299.14, stdev=3D901.82
    clat (usec): min=3D8, max=3D31311, avg=3D1797.57, stdev=3D1917.38
     lat (usec): min=3D9, max=3D31312, avg=3D1798.89, stdev=3D1917.58
    clat percentiles (usec):
     |  1.00th=3D[   16],  5.00th=3D[   27], 10.00th=3D[   42], 20.00th=3D[=
  108],
     | 30.00th=3D[  334], 40.00th=3D[  824], 50.00th=3D[ 1369], 60.00th=3D[=
 1909],
     | 70.00th=3D[ 2409], 80.00th=3D[ 3064], 90.00th=3D[ 4146], 95.00th=3D[=
 5276],
     | 99.00th=3D[ 8586], 99.50th=3D[10159], 99.90th=3D[13960], 99.95th=3D[=
15533],
     | 99.99th=3D[18744]
   bw (  KiB/s): min=3D497348, max=3D1063791, per=3D100.00%, avg=3D715944.1=
1,
stdev=3D115634.92, samples=3D261
   iops        : min=3D 4238, max=3D18726, avg=3D12722.05, stdev=3D4574.05,=
 samples=3D261
  lat (usec)   : 10=3D0.01%, 20=3D1.23%, 50=3D4.85%, 100=3D3.68%, 250=3D4.7=
0%
  lat (usec)   : 500=3D4.63%, 750=3D4.35%, 1000=3D4.44%
  lat (msec)   : 2=3D20.84%, 4=3D35.50%, 10=3D13.53%, 20=3D1.91%, 50=3D0.32=
%
  lat (msec)   : 100=3D0.01%
  cpu          : usr=3D5.62%, sys=3D3.29%, ctx=3D2799800, majf=3D0, minf=3D=
266
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%, 32=3D0.=
1%, >=3D64=3D100.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.1%, >=3D64=3D0.0%
     issued rwts: total=3D1668079,1668079,0,0 short=3D0,0,0,0 dropped=3D0,0=
,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D64

Run status group 0 (all jobs):
   READ: bw=3D8943GiB/s (9602GB/s), 8943GiB/s-8943GiB/s
(9602GB/s-9602GB/s), io=3D89.4GiB (96.0GB), run=3D10-10msec
  WRITE: bw=3D698MiB/s (732MB/s), 698MiB/s-698MiB/s (732MB/s-732MB/s),
io=3D89.4GiB (96.0GB), run=3D131206-131206msec

Disk stats (read/write):
  nvme0n1: ios=3D1772035/1772257, merge=3D0/0, ticks=3D6269444/3172530,
in_queue=3D9441974, util=3D100.00%
---------------------------------------------------------------------------=
-----


fio: got pattern '00', wanted '51'. Bad bits 3
fio: bad pattern block offset 384
pattern: verify failed at file /dev/nvme0n1 offset 70523721971, length
3769685073 (requested block: offset=3D68822685696, length=3D1048576)
       received data dumped as nvme0n1.69899573248.received
       expected data dumped as nvme0n1.69899573248.expected
fio: verify type mismatch (57520 media, 18 given)


"offset 384", "offset 70523721971, length 3769685073",
"offset=3D68822685696, length=3D1048576", "nvme0n1.69899573248.received"

These number has no any relation, like equal or sum equl. Maybe this
is an error or mistake??
