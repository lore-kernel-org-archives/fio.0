Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28F8132C1A
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712256215; cv=none; b=KpqeyCL5wQTdG0+qbAEJWb2ASBPuku/5wi7AutEmcX5pTEUHacBXpKk1BVPUi7m01O/Z8RwbzDIW5x+0kk2bUyiCMoF59O/UJzYxY+NAZQctm8cIPJ45vLs2QyjK/svlAssySGTBZ/UQ4wcDhoJf7h+PMJReZgYdP+dPOCfVJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712256215; c=relaxed/simple;
	bh=xfONAGfPBaoMUZkMJkilii5Kc5iwr4O92dVaPQCEf5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fnNusNHFW7srYhzpvggGZmDv5WiKfcwdEgnpTkXUkTXgkkRQn0OTdNXbEZQx9uXblqODJYdCHHhjHUD6sH5jRsfFpVG3EvVdfK0uehejekeP1cT7mA2apxM8HiJQyOf4pdXMfH4cGVXzRiIChEUI6SyZjX2p6tjoKUjSw5ycFrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com; spf=none smtp.mailfrom=aeoncomputing.com; dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b=U2SgUcKv; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b="U2SgUcKv"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-61461580403so14947877b3.2
        for <fio@vger.kernel.org>; Thu, 04 Apr 2024 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aeoncomputing-com.20230601.gappssmtp.com; s=20230601; t=1712256212; x=1712861012; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdTg1UFxUBiGdVGW8aGRPcbFGoDNCQdGgvg2MJ6tdtY=;
        b=U2SgUcKvp0ZW36y61nKFRQufZxr4Hqgyh1OZ+FA6fzNczfBLniC7kiNSoTpXUlyF9H
         R177/W+0HD8t4B52fEXgRFDVyoXUbOVpqEM8XdCmphtLra28Z6YRCoLsuWA99xjE6HHV
         kWkzucn0MlK9Y5k50UXMF8XbNYfrBUHC9yH9RCoDAR/6EHpUQnTUVyBSZiB3bWNpmePj
         5AYuttNgugjFiMjquKN6pvwPOj5MIDe0o6/CUDSTUDGFuseJ6Np9A9sM+/ECODaIxlXD
         ThEH4AQvspjGC++gV7SdTt0rmUyhB2N0+OMC9uX1hwcKswUUR8FW7scMmOhtmvnUypaq
         hOnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712256212; x=1712861012;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdTg1UFxUBiGdVGW8aGRPcbFGoDNCQdGgvg2MJ6tdtY=;
        b=EeTOVT/irP8w7M0TIR52Am/WUpokXrpD/47ZZIhnVIrDU9icI4mHptdfTG4RniNznG
         TBC4Mdh7PXzGN6l2OwpI5ZKegxaEZIVAoszkBE4c3nCS0zL1sY/Sm8u6jo04eUdoDy+7
         bRjqfQxGxy/b7ALSoF9DQRZt6pF5i0CoSjc+bCXYhkf8M7cogpmeaoQ7SP+HRw7iHIx6
         iaaJbK42SsoHhAtUgahfNMtqOj/2wNWcp1ZZTSnq6ZWu3Jrx4dbByc0/Pqa6xiWEJA51
         OqabNeimVd9htWWmzEpzztHqu52T9nRvYt4CX2waWolp0XkYCYZRi7iofh9mmPwq0Zu3
         ZWOw==
X-Forwarded-Encrypted: i=1; AJvYcCXdW0hsD0mHwR2IZ+OYEvBekxI4tjkRVIZvCFdiaDVw7/rXVY4+gRMTchZevNlvpIAF8FQXfbEwI+sAao3Rb0ximgb7
X-Gm-Message-State: AOJu0YymPilJyl38Q/pHCCzP+ScegF29GfwicF40kYvOJQRgRerAV34e
	p14+Qe9wyhZwZq1bVLG96X15jeyNQcNePqAT1VXTPIgYdU/GupXbyQlY0R9W9NEtL4ZYZ6Ema52
	UNUU0a3TtYVECPtFHhHYM9QvYLNrGT/zGZQeQCuYsbMtreJ/qy4O8Ew==
X-Google-Smtp-Source: AGHT+IHDj7DYkugaP07M5EFfu6XEpJLjDTWPQKQ7m/GFC5EbXavilmvj+VZUKyRJkdr1KWRg+ziqayEvCEm6gOgc4d8=
X-Received: by 2002:a81:524e:0:b0:615:e8f:2f4f with SMTP id
 g75-20020a81524e000000b006150e8f2f4fmr440862ywb.17.1712256212513; Thu, 04 Apr
 2024 11:43:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org> <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org> <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
In-Reply-To: <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date: Thu, 4 Apr 2024 11:43:21 -0700
Message-ID: <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
Subject: Re: help understanding the output of fio
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Felix Rubio <felix@kngnt.org>, fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It looks like you are running fio against the local directory within
your zpool. Your performance is really bad but this could be impacted
by zpool parameters as well. It is not a pure test of your SSD, which
you should do to rule out hardware or block device driver issues. You
can run a read only test and your zpool will not be affected. Please
take care to ensure all tests to your NVMe drive are read-only. Also,
one small point, ZFS does not support direct_io *yet*. Running a
direct_io job against a ZFS directory will have terrible and
unpredictable results. You can run direct_io against raw block
devices, XFS and ext4 file systems.

Examples:
[sequential read-only]
fio --name=3Dseqread --numjobs=3D1 --time_based --runtime=3D60s
--ramp_time=3D2s --iodepth=3D8 --ioengine=3Dlibaio --direct=3D1 --verify=3D=
0
--group_reporting=3D1 --bs=3D1M --rw=3Dread --filename=3D/dev/{$my_ssd}

[random read-only]
fio --name=3Drandomread --numjobs=3D1 --time_based --runtime=3D60s
--ramp_time=3D2s --iodepth=3D8 --ioengine=3Dlibaio --direct=3D1 --verify=3D=
0
--group_reporting=3D1 --bs=3D4k --rw=3Drandread --filename=3D/dev/{$my_ssd}

If you do not see sequential read performance or random IOPs within
70% of what the manufacturer's advertised specs for your drive you
should start reviewing dmesg/messages, check drive link states (pcie
width and speed for nvme, SATA link speed for SATA).

--Jeff


On Wed, Apr 3, 2024 at 9:28=E2=80=AFPM Damien Le Moal <dlemoal@kernel.org> =
wrote:
>
> On 4/4/24 04:21, Felix Rubio wrote:
> > Hi Patrick,
> >
> > Thank you for your answer. I am quite lost with the results shown by
> > fio: I do not get to understand them. I have a system with 3 ZFS pools:
> > in 1 I have a single SSD, in another I have 2 stripped SSD, and in the
> > third I have a single HDD. On the first pool I am running this command:
> >
> > fio --numjobs=3D1 --size=3D1024M --time_based --runtime=3D60s --ramp_ti=
me=3D2s
> > --ioengine=3Dlibaio --direct=3D1 --verify=3D0 --group_reporting=3D1 --b=
s=3D1M
> > --rw=3Dwrite
>
> You did not specify --iodepth. If you want to run at QD=3D1, the use
> --ioengine=3Dpsync. For QD > 1, use --ioengine=3Dlibaio --iodepth=3DX (X =
> 1). You can
> use --ioengine=3Dio_uring as well.
>
> Also, there is no filename=3D option here. Are you running this workload =
on the
> ZFS file system writing to a file ? Or ar you running this against the SS=
D block
> device file ?
>
> >
> > And I am getting this result:
> >
> > write_throughput_i: (g=3D0): rw=3Dwrite, bs=3D(R) 1024KiB-1024KiB, (W)
> > 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D1
> > fio-3.33
> > Starting 1 process
> > write_throughput_i: Laying out IO file (1 file / 1024MiB)
> > Jobs: 1 (f=3D1): [W(1)][21.1%][eta 03m:56s]
> > write_throughput_i: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D235368: We=
d Apr  3
> > 21:01:16 2024
> >    write: IOPS=3D3, BW=3D3562KiB/s (3647kB/s)(211MiB/60664msec); 0 zone
> > resets
>
> Your drive does 3 I/Os per second... That is very slow... Did you have a =
look at
> dmesg to see if there is anything going on with the driver ?
>
> You may want to start with testing 4K writes and increasing the block siz=
e from
> there (8k, 16k, 32k, ...) and see if there is a value that triggers the s=
low
> behavior.
>
> But this all look like a HW issue or FS/driver issue. What type of SSD is=
 this ?
> NVMe ? ATA ?
>
> >      slat (msec): min=3D16, max=3D1777, avg=3D287.56, stdev=3D282.15
> >      clat (nsec): min=3D10930, max=3D31449, avg=3D12804.00, stdev=3D328=
9.32
> >       lat (msec): min=3D16, max=3D1777, avg=3D288.86, stdev=3D282.20
> >      clat percentiles (nsec):
> >       |  1.00th=3D[11072],  5.00th=3D[11328], 10.00th=3D[11456],
> > 20.00th=3D[11584],
> >       | 30.00th=3D[11840], 40.00th=3D[11840], 50.00th=3D[12096],
> > 60.00th=3D[12224],
> >       | 70.00th=3D[12352], 80.00th=3D[12736], 90.00th=3D[13248],
> > 95.00th=3D[13760],
> >       | 99.00th=3D[29568], 99.50th=3D[30848], 99.90th=3D[31360],
> > 99.95th=3D[31360],
> >       | 99.99th=3D[31360]
> >     bw (  KiB/s): min=3D 2048, max=3D51302, per=3D100.00%, avg=3D4347.0=
5,
> > stdev=3D6195.46, samples=3D99
> >     iops        : min=3D    2, max=3D   50, avg=3D 4.24, stdev=3D 6.04,
> > samples=3D99
> >    lat (usec)   : 20=3D96.19%, 50=3D3.81%
> >    cpu          : usr=3D0.10%, sys=3D0.32%, ctx=3D1748, majf=3D0, minf=
=3D37
> >    IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%,
> >  >=3D64=3D0.0%
> >       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
> >  >=3D64=3D0.0%
> >       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
> >  >=3D64=3D0.0%
> >       issued rwts: total=3D0,210,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
> >       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D1
> >
> > Run status group 0 (all jobs):
> >    WRITE: bw=3D3562KiB/s (3647kB/s), 3562KiB/s-3562KiB/s
> > (3647kB/s-3647kB/s), io=3D211MiB (221MB), run=3D60664-60664msec
> >
> > For a read test, running the same parameters (changing rw=3Dwrite by
> > rw=3Dread), I get:
> >
> > read_throughput_i: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W)
> > 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D1
> > fio-3.33
> > Starting 1 process
> > read_throughput_i: Laying out IO file (1 file / 1024MiB)
> > Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D1229MiB/s][r=3D1229 IOPS][eta 00m:0=
0s]
> > read_throughput_i: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D245501: Wed=
 Apr  3
> > 21:14:27 2024
> >    read: IOPS=3D1283, BW=3D1284MiB/s (1346MB/s)(75.2GiB/60001msec)
> >      slat (usec): min=3D371, max=3D27065, avg=3D757.71, stdev=3D185.43
> >      clat (usec): min=3D9, max=3D358, avg=3D12.44, stdev=3D 3.93
> >       lat (usec): min=3D383, max=3D27078, avg=3D770.15, stdev=3D185.66
> >      clat percentiles (usec):
> >       |  1.00th=3D[   11],  5.00th=3D[   12], 10.00th=3D[   12], 20.00t=
h=3D[
> > 12],
> >       | 30.00th=3D[   12], 40.00th=3D[   12], 50.00th=3D[   13], 60.00t=
h=3D[
> > 13],
> >       | 70.00th=3D[   13], 80.00th=3D[   13], 90.00th=3D[   13], 95.00t=
h=3D[
> > 14],
> >       | 99.00th=3D[   24], 99.50th=3D[   29], 99.90th=3D[   81], 99.95t=
h=3D[
> > 93],
> >       | 99.99th=3D[  105]
> >     bw (  MiB/s): min=3D 1148, max=3D 1444, per=3D100.00%, avg=3D1285.1=
2,
> > stdev=3D86.12, samples=3D119
> >     iops        : min=3D 1148, max=3D 1444, avg=3D1284.97, stdev=3D86.0=
5,
> > samples=3D119
> >    lat (usec)   : 10=3D0.09%, 20=3D98.90%, 50=3D0.73%, 100=3D0.26%, 250=
=3D0.02%
> >    lat (usec)   : 500=3D0.01%
> >    cpu          : usr=3D3.14%, sys=3D95.75%, ctx=3D6274, majf=3D0, minf=
=3D37
> >    IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%,
> >  >=3D64=3D0.0%
> >       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
> >  >=3D64=3D0.0%
> >       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D0.0%,
> >  >=3D64=3D0.0%
> >       issued rwts: total=3D77036,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,=
0
> >       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D1
> >
> > Run status group 0 (all jobs):
> >     READ: bw=3D1284MiB/s (1346MB/s), 1284MiB/s-1284MiB/s
> > (1346MB/s-1346MB/s), io=3D75.2GiB (80.8GB), run=3D60001-60001msec
> >
> >
> > If I understand properly these results, I am getting ~4 MBps of write
> > bandwidth to disk,caused by a submission latency problem , but when
> > reading sequentially I am getting 1.3 GBps (also very weird) (previousl=
y
> > I shared another test with different parameters, multiple jobs, etc.,
> > but with the same result). I am trying to find out if this analysis is
> > correct and whether is a software or a hardware error.
> > ---
> > Felix Rubio
> > "Don't believe what you're told. Double check."
> >
> > On 2024-04-03 17:45, Patrick Goetz wrote:
> >> Hi Felix -
> >>
> >> It might be helpful to share your job file or fio command line. Not
> >> sure, I'm a neophyte as well with many questions such as what happens
> >> when the number of jobs is less than the iodepth.
> >>
> >> On 4/3/24 00:35, Felix Rubio wrote:
> >>> Hi everybody,
> >>>
> >>> I have started recently to use fio, and I am getting the following
> >>> output for sequential writes:
> >>>
> >>> write_throughput_i: (groupid=3D0, jobs=3D16): err=3D 0: pid=3D2301660=
: Tue Apr
> >>> 2 21:03:41 2024
> >>>    write: IOPS=3D2, BW=3D5613KiB/s (5748kB/s)(2048MiB/373607msec); 0 =
zone
> >>> resets
> >>>      slat (msec): min=3D41549, max=3D373605, avg=3D260175.71, stdev=
=3D76630.63
> >>>      clat (nsec): min=3D17445, max=3D31004, avg=3D20350.31, stdev=3D3=
744.64
> >>>       lat (msec): min=3D235566, max=3D373605, avg=3D318209.63,
> >>> stdev=3D32743.17
> >>>      clat percentiles (nsec):
> >>>       |  1.00th=3D[17536],  5.00th=3D[17536], 10.00th=3D[17792],
> >>> 20.00th=3D[17792],
> >>>       | 30.00th=3D[18048], 40.00th=3D[18304], 50.00th=3D[18304],
> >>> 60.00th=3D[18816],
> >>>       | 70.00th=3D[21632], 80.00th=3D[22144], 90.00th=3D[27008],
> >>> 95.00th=3D[31104],
> >>>       | 99.00th=3D[31104], 99.50th=3D[31104], 99.90th=3D[31104],
> >>> 99.95th=3D[31104],
> >>>       | 99.99th=3D[31104]
> >>>     bw (  MiB/s): min=3D 2051, max=3D 2051, per=3D100.00%, avg=3D2051=
.84,
> >>> stdev=3D 0.00, samples=3D16
> >>>     iops        : min=3D 2048, max=3D 2048, avg=3D2048.00, stdev=3D 0=
.00,
> >>> samples=3D16
> >>>    lat (usec)   : 20=3D68.75%, 50=3D31.25%
> >>>    cpu          : usr=3D0.00%, sys=3D0.02%, ctx=3D8350, majf=3D13, mi=
nf=3D633
> >>>    IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, =
32=3D0.0%,
> >>>> =3D64=3D100.0%
> >>>       submit    : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D100.0%,
> >>>  >=3D64=3D0.0%
> >>>       complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%,=
 64=3D100.0%,
> >>>  >=3D64=3D0.0%
> >>>       issued rwts: total=3D0,1024,0,0 short=3D0,0,0,0 dropped=3D0,0,0=
,0
> >>>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D64
> >>>
> >>> Run status group 0 (all jobs):
> >>>    WRITE: bw=3D5613KiB/s (5748kB/s), 5613KiB/s-5613KiB/s
> >>> (5748kB/s-5748kB/s), io=3D2048MiB (2147MB), run=3D373607-373607msec
> >>>
> >>> Should I understand this correctly, the submission latency (slat) is
> >>> at minimum 41.5 seconds? I am experiencing problems with my SSD disk
> >>> (the performance is pretty low, which this seems to confirm), but now
> >>> I am wondering if this could be a problem with my OS and not my disk,
> >>> being the slat the submission latency?
> >>>
> >>> Thank you
> >
>
> --
> Damien Le Moal
> Western Digital Research
>
>


--=20
------------------------------
Jeff Johnson
Co-Founder
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x1001   f: 858-412-3845
m: 619-204-9061

4170 Morena Boulevard, Suite C - San Diego, CA 92117

High-Performance Computing / Lustre Filesystems / Scale-out Storage
