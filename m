Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1234BC43334
	for <fio@archiver.kernel.org>; Tue, 12 Jul 2022 19:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiGLTYY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 12 Jul 2022 15:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235910AbiGLTXv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 12 Jul 2022 15:23:51 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82526F32F0
        for <fio@vger.kernel.org>; Tue, 12 Jul 2022 12:01:02 -0700 (PDT)
Date:   Tue, 12 Jul 2022 18:58:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail3; t=1657652458; x=1657911658;
        bh=M/w9vemtpwoXyl4GTqSq+1oNa67S1WrlLrXojqSfLHs=;
        h=Date:To:From:Reply-To:Subject:Message-ID:Feedback-ID:From:To:Cc:
         Date:Subject:Reply-To:Feedback-ID:Message-ID;
        b=eqHOlIznny/w7ZVshTSRFKQ4EzmvPHYq06b4MC/4YJHpV/9O6prSNSRTh9koA/VE9
         d8cbTX7wwbqrpxloOET4LpJEePzAx7c1jR5gZYpsFAWJEfy5bAv3UHAzkQvLqmDhyB
         B9HRah9fcE1rvMWXpkBdW8kgA3zjbOG2/l7xXwXqKdofYHEzSUx13icb62Oz3kz1ij
         FE6/a8vhNwA6DYzx0h6MeriZgpV+JhlyiGYtBMWhcKW9nVBVma99qi+jH/yoczgAn+
         NP2EChMcdvQVLz0I5hITtR85ebecLwoxnKfkAhMPrP4E8F5PFVWlxNQHtjtCbg/alP
         M0qaRAkjJZ5Xw==
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
From:   Alex Matyushin <airgunster@protonmail.ch>
Reply-To: Alex Matyushin <airgunster@protonmail.ch>
Subject: fdatasync latency percentiles
Message-ID: <GPtNqTLWCihrYY29Il_OLQ7-mXfGc9dx3moSMPF_HD4u2_UeMKE8gUmOZsQ9rWQINRf2AGAWtAo5cHjyn4x_lSDhyXdwOeYsyTum5J09Gco=@protonmail.ch>
Feedback-ID: 123709:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi there,

I'm trying to understand difference in latency reported by fdatasync latenc=
y percentiles (_sync percentiles_) on `--ioengine=3Dpsync --fdatasync=3D1` =
vs. _clat percentiles_ on `--ioengine=3Dlibaio --direct=3D1` and I'd really=
 appreciate your help.

I thought that they should should not have such a big difference between ea=
ch other. I've assumed (am I wrong here?) that fdatasync latency percentile=
s (_sync percentiles_) will report on I/O completion for `fdatasync()` sysc=
all, so that I could compare it with _clat percentiles_ on `--ioengine=3Dli=
baio --direct=3D1`.

Can someone please help to explain how fdatasync latency percentiles (_sync=
 percentiles_) on `--ioengine=3Dpsync --fdatasync=3D1` are calculated exact=
ly?

My goal is to reproduce application pattern where for each of its `pwrite64=
()` calls it executes `fdatasync()` + I want to measure `fdatasync()` compl=
etion latency.

Test A:
$ sudo fio --rw=3Dwrite --ioengine=3Dpsync --fdatasync=3D1 --iodepth=3D1 --=
bs=3D512 --numjobs=3D1 --rate_iops=3D1 --directory=3Dtest-data --size=3D100=
mb --runtime=3D1m --name=3Dazure-westeurope-disk-test
azure-westeurope-disk-test: (g=3D0): rw=3Dwrite, bs=3D(R) 512B-512B, (W) 51=
2B-512B, (T) 512B-512B, ioengine=3Dpsync, iodepth=3D1
fio-3.7
Starting 1 process
azure-westeurope-disk-test: Laying out IO file (1 file / 100MiB)
Jobs: 1 (f=3D1), 0-1 IOPS: [W(1)][100.0%][r=3D0KiB/s,w=3D0KiB/s][r=3D0,w=3D=
1 IOPS][eta 00m:00s]
azure-westeurope-disk-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D12184:=
 Tue Jul 12 18:35:15 2022
  write: IOPS=3D1, BW=3D520B/s (520B/s)(30.5KiB/60001msec)
    clat (nsec): min=3D9400, max=3D44200, avg=3D29336.07, stdev=3D6777.19
     lat (nsec): min=3D10300, max=3D48300, avg=3D31836.07, stdev=3D7118.83
    clat percentiles (nsec):
     |  1.00th=3D[ 9408],  5.00th=3D[15808], 10.00th=3D[25728], 20.00th=3D[=
26496],
     | 30.00th=3D[27008], 40.00th=3D[27776], 50.00th=3D[28288], 60.00th=3D[=
29312],
     | 70.00th=3D[32640], 80.00th=3D[33536], 90.00th=3D[35584], 95.00th=3D[=
42240],
     | 99.00th=3D[44288], 99.50th=3D[44288], 99.90th=3D[44288], 99.95th=3D[=
44288],
     | 99.99th=3D[44288]
   bw (  KiB/s): min=3D    0, max=3D    2, per=3D100.00%, avg=3D 1.00, stde=
v=3D 0.19, samples=3D59
   iops        : min=3D    1, max=3D    4, avg=3D 2.02, stdev=3D 0.29, samp=
les=3D59
  lat (usec)   : 10=3D1.64%, 20=3D6.56%, 50=3D91.80%
  fsync/fdatasync/sync_file_range:
    sync (usec): min=3D1112, max=3D8494, avg=3D1999.62, stdev=3D1242.89
    sync percentiles (usec):
     |  1.00th=3D[ 1106],  5.00th=3D[ 1172], 10.00th=3D[ 1205], 20.00th=3D[=
 1287],
     | 30.00th=3D[ 1369], 40.00th=3D[ 1434], 50.00th=3D[ 1516], 60.00th=3D[=
 1631],
     | 70.00th=3D[ 1860], 80.00th=3D[ 2507], 90.00th=3D[ 3326], 95.00th=3D[=
 4293],
     | 99.00th=3D[ 8455], 99.50th=3D[ 8455], 99.90th=3D[ 8455], 99.95th=3D[=
 8455],
     | 99.99th=3D[ 8455]
  cpu          : usr=3D0.01%, sys=3D0.01%, ctx=3D136, majf=3D0, minf=3D34
  IO depths    : 1=3D198.4%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,61,0,0 short=3D60,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D520B/s (520B/s), 520B/s-520B/s (520B/s-520B/s), io=3D30.5KiB =
(31.2kB), run=3D60001-60001msec

Disk stats (read/write):
  sdb: ios=3D0/282, merge=3D0/22, ticks=3D0/482, in_queue=3D482, util=3D0.5=
6%



Test B:
$ sudo fio --rw=3Dwrite --ioengine=3Dlibaio --direct=3D1 --iodepth=3D1 --bs=
=3D512 --numjobs=3D1 --rate_iops=3D1 --directory=3Dtest-data --size=3D100mb=
 --runtime=3D1m --name=3Dazure-westeurope-disk-test
azure-westeurope-disk-test: (g=3D0): rw=3Dwrite, bs=3D(R) 512B-512B, (W) 51=
2B-512B, (T) 512B-512B, ioengine=3Dlibaio, iodepth=3D1
fio-3.7
Starting 1 process
Jobs: 1 (f=3D1), 0-1 IOPS: [W(1)][100.0%][r=3D0KiB/s,w=3D0KiB/s][r=3D0,w=3D=
1 IOPS][eta 00m:00s]
azure-westeurope-disk-test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D12291:=
 Tue Jul 12 18:36:35 2022
  write: IOPS=3D1, BW=3D520B/s (520B/s)(30.5KiB/60002msec)
    slat (usec): min=3D1140, max=3D4786, avg=3D1654.72, stdev=3D693.43
    clat (nsec): min=3D3300, max=3D12200, avg=3D5070.49, stdev=3D1429.96
     lat (usec): min=3D1148, max=3D4794, avg=3D1662.44, stdev=3D693.39
    clat percentiles (nsec):
     |  1.00th=3D[ 3312],  5.00th=3D[ 4320], 10.00th=3D[ 4320], 20.00th=3D[=
 4384],
     | 30.00th=3D[ 4576], 40.00th=3D[ 4704], 50.00th=3D[ 4704], 60.00th=3D[=
 4832],
     | 70.00th=3D[ 4832], 80.00th=3D[ 5088], 90.00th=3D[ 5472], 95.00th=3D[=
 9152],
     | 99.00th=3D[12224], 99.50th=3D[12224], 99.90th=3D[12224], 99.95th=3D[=
12224],
     | 99.99th=3D[12224]
   bw (  KiB/s): min=3D    0, max=3D    2, per=3D100.00%, avg=3D 1.00, stde=
v=3D 0.19, samples=3D59
   iops        : min=3D    1, max=3D    4, avg=3D 2.02, stdev=3D 0.29, samp=
les=3D59
  lat (usec)   : 4=3D1.64%, 10=3D96.72%, 20=3D1.64%
  cpu          : usr=3D0.00%, sys=3D0.01%, ctx=3D122, majf=3D0, minf=3D32
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,61,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D520B/s (520B/s), 520B/s-520B/s (520B/s-520B/s), io=3D30.5KiB =
(31.2kB), run=3D60002-60002msec

Disk stats (read/write):
  sdb: ios=3D0/301, merge=3D0/18, ticks=3D0/432, in_queue=3D432, util=3D0.6=
2%


Thanks a lot in advance!
Alex
