Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E411EB36
	for <fio@vger.kernel.org>; Fri,  5 Apr 2024 18:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712342407; cv=none; b=UMNy4UFfKjmNXw8VC+a83xupMhxfNzmV/wypJDW8j9BIU6lt2+wpqhPMRGWFVSY4DvPNXIBfjcni6LCf+mV6w2ifiMZpZEXbVm8ftoDVazMDUbmrgq6UzGVWkkBxzHSdk4aWSaT+I5Q5UVzjuI2NufUZXTuW5Ex2SiFVQWgKiZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712342407; c=relaxed/simple;
	bh=ikrThZ9POKFOoikrklPaU3Ky6HB0bHFUBc2bzaM0UK0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mShhNZpcvWppBQW9e2yeRDuJshbTZ4IVuhCCqcVo+L+R2cC1pMqqYq+CAYeuCMjKRI0wgv8T06kZbFBpD6/qTL5XPwUTDfqysIaC+eQoFnf0MDOPeXNN9MiI+NxnivwAs01PwJRrMxWPHC4I6b1mpR3u3Cp691OvnoAUrHut3pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com; spf=none smtp.mailfrom=aeoncomputing.com; dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b=Z77Q6Gel; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b="Z77Q6Gel"
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-dcc84ae94c1so2681409276.1
        for <fio@vger.kernel.org>; Fri, 05 Apr 2024 11:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aeoncomputing-com.20230601.gappssmtp.com; s=20230601; t=1712342405; x=1712947205; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RsT9IJgmPoSOT8Ytm4UlGSgNAo2fzFl8Wc0ge/CwOu0=;
        b=Z77Q6GelQ4ncbKXexGTqnb+cqgX80H3i7+10uH3V8UQTG1D5YkceP1lBkBTGOBf2ii
         /NVyqD/oZ2Sc/BKuaxSO8f6O670AP+RQWGj9BD8WTuS++lKf7RSCOjODHYMqzjMwsJzq
         W6GeES5qvQDjoiSVBrxc/vrw0MElNVgSPg7kRF0DZhUFYKRCuwcPAcMuLSXO7CSLJlC8
         t1Vo8C0zjraUS2Yxg+kODqK39cq/ZVbkrm5YjryV8j8M8SSxW43yot3HtmDtveMCFzkA
         4xsRnKyeexFtcFwTISNeHAU0MM+Pz7+S7xzrqveV73IQDSUB1o7T47/PfKr8uegOYBz2
         qwgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712342405; x=1712947205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RsT9IJgmPoSOT8Ytm4UlGSgNAo2fzFl8Wc0ge/CwOu0=;
        b=Zx/MzUwaitsrd43afNGwQ8UNx5XDIdifdht7ryHNfQfQK9JpcrHKWcoe17XUkb0cQs
         QXKwK7cHvu+XZ5g5ZxZyN8jmeF+c+v5KOCHIxgJ6IYTxLJfgv9kVpqs2myA8ZVqmOV4t
         vQRH2YtiwsVwBfK/OnHiQVl9mvPRpsmUHYd3KX/lt3ljNGB3SRPWFzwyO1ipk8T84WoR
         xDmfaHvv39r7YkDA4hvLI28517Di0F2arCzYHJvBVOs1eXjSwayhzxrU7+h1vicAOXQ5
         WfPHoHLZRRSMydGclpXMkxN9NVP1pr5U0v7dtOkt/6q9oQs9h7kYpSEIGBA4hStvTF85
         o10g==
X-Gm-Message-State: AOJu0YyX/LZGXIlSjaAGko2ssWCIVcP2w3dW/KkwliI0J0l6qybZIB5M
	FVqjclu7ESmBWlXBcOVqctUTtjDmkVQt4kAIQ2PYQNf2FnkNpGaZcDSyq2xEblvEeU0RRzrxaTV
	JpL5/Rcs0wrASdmNOeWZAcZgjvTgBeWoTp9yYExAsAgy03K8CJOY=
X-Google-Smtp-Source: AGHT+IHHSeQ3jnpBVu3GzLn4IQ/qS3LF/HQsRmIhC7QrkzWHiB29zno9EDH+bTv0DF5JHtlT7DUYFaIDoxDhDyrDQYc=
X-Received: by 2002:a25:a50a:0:b0:dd1:398b:3f33 with SMTP id
 h10-20020a25a50a000000b00dd1398b3f33mr1991693ybi.16.1712342404609; Fri, 05
 Apr 2024 11:40:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org> <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org> <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com>
 <7c7cb7c19e6f3587864f37888122b58d@kngnt.org> <CAFCYAsfBmYA9hr3MyL91DiPb4+fpavUU_GXERGcjt7ytQQ5WJg@mail.gmail.com>
 <65e4f78e3652754dcfe6ecb356a8226f@kngnt.org>
In-Reply-To: <65e4f78e3652754dcfe6ecb356a8226f@kngnt.org>
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date: Fri, 5 Apr 2024 11:39:53 -0700
Message-ID: <CAFCYAsdXh08yEP5wM1BBQ8dLLVyKSksFFG3eBngbBdWNk=nRhQ@mail.gmail.com>
Subject: Re: help understanding the output of fio
To: Felix Rubio <felix@kngnt.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Felix,

You're using the psync ioengine with a queue depth of 1. This will
slow zfs down a lot. Use libaio and a queue depth of 8-16.

To temporarily disable ZFS arc caching on your volume, say your
benchmark volume is mypool/myvol mounted at /myvol you can do:
zfs get all mypool/myvol > ~/myvol-settings-save.txt
zfs set primarycache=3Doff mypool/myvol
zfs set secondarycache=3Doff mypool/myvol

then run your fio tests. After you are done benchmarking your ZFS
refer to the settings saved in ~/myvol-settings-save.txt to set
primarycache and secondarycache back to original.

--Jeff


On Thu, Apr 4, 2024 at 10:41=E2=80=AFPM Felix Rubio <felix@kngnt.org> wrote=
:
>
> Hi Jeff,
>
> I have done the test you suggested, and this is what came up:
>
> read_throughput_rpool: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W)
> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dpsync, iodepth=3D1
> fio-3.33
> Starting 1 process
> read_throughput_rpool: Laying out IO file (1 file / 1024MiB)
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D904MiB/s][r=3D903 IOPS][eta 00m:00s]
> read_throughput_rpool: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3284411: =
Fri Apr
>   5 07:31:18 2024
>    read: IOPS=3D1092, BW=3D1092MiB/s (1145MB/s)(64.0GiB/60001msec)
>      clat (usec): min=3D733, max=3D6031, avg=3D903.71, stdev=3D166.68
>       lat (usec): min=3D734, max=3D6032, avg=3D904.88, stdev=3D166.84
>      clat percentiles (usec):
>       |  1.00th=3D[  742],  5.00th=3D[  750], 10.00th=3D[  750], 20.00th=
=3D[
> 758],
>       | 30.00th=3D[  766], 40.00th=3D[  791], 50.00th=3D[  824], 60.00th=
=3D[
> 873],
>       | 70.00th=3D[ 1037], 80.00th=3D[ 1106], 90.00th=3D[ 1139], 95.00th=
=3D[
> 1188],
>       | 99.00th=3D[ 1254], 99.50th=3D[ 1287], 99.90th=3D[ 1401], 99.95th=
=3D[
> 1500],
>       | 99.99th=3D[ 2474]
>     bw (  MiB/s): min=3D  871, max=3D 1270, per=3D100.00%, avg=3D1092.97,
> stdev=3D166.88, samples=3D120
>     iops        : min=3D  871, max=3D 1270, avg=3D1092.78, stdev=3D166.95=
,
> samples=3D120
>    lat (usec)   : 750=3D6.17%, 1000=3D60.30%
>    lat (msec)   : 2=3D33.51%, 4=3D0.02%, 10=3D0.01%
>    cpu          : usr=3D2.04%, sys=3D97.52%, ctx=3D2457, majf=3D0, minf=
=3D37
>    IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%,
>  >=3D64=3D0.0%
>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       issued rwts: total=3D65543,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
>     READ: bw=3D1092MiB/s (1145MB/s), 1092MiB/s-1092MiB/s
> (1145MB/s-1145MB/s), io=3D64.0GiB (68.7GB), run=3D60001-60001msec
>
> I take that the file was being cached (because the 1145 MBps on a single
> SSD disk is hard to believe)? For the write test, these are the results:
>
> write_throughput_rpool: (g=3D0): rw=3Dwrite, bs=3D(R) 1024KiB-1024KiB, (W=
)
> 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=3Dpsync, iodepth=3D1
> fio-3.33
> Starting 1 process
> write_throughput_rpool: Laying out IO file (1 file / 1024MiB)
> Jobs: 1 (f=3D1): [W(1)][100.0%][w=3D4100KiB/s][w=3D4 IOPS][eta 00m:00s]
> write_throughput_rpool: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D3292023:=
 Fri
> Apr  5 07:36:11 2024
>    write: IOPS=3D5, BW=3D5394KiB/s (5524kB/s)(317MiB/60174msec); 0 zone
> resets
>      clat (msec): min=3D16, max=3D1063, avg=3D189.59, stdev=3D137.19
>       lat (msec): min=3D16, max=3D1063, avg=3D189.81, stdev=3D137.19
>      clat percentiles (msec):
>       |  1.00th=3D[   18],  5.00th=3D[   22], 10.00th=3D[   41], 20.00th=
=3D[
> 62],
>       | 30.00th=3D[  129], 40.00th=3D[  144], 50.00th=3D[  163], 60.00th=
=3D[
> 190],
>       | 70.00th=3D[  228], 80.00th=3D[  268], 90.00th=3D[  363], 95.00th=
=3D[
> 489],
>       | 99.00th=3D[  567], 99.50th=3D[  592], 99.90th=3D[ 1062], 99.95th=
=3D[
> 1062],
>       | 99.99th=3D[ 1062]
>     bw (  KiB/s): min=3D 2048, max=3D41042, per=3D100.00%, avg=3D5534.14,
> stdev=3D5269.61, samples=3D117
>     iops        : min=3D    2, max=3D   40, avg=3D 5.40, stdev=3D 5.14,
> samples=3D117
>    lat (msec)   : 20=3D3.47%, 50=3D11.99%, 100=3D8.83%, 250=3D51.42%, 500=
=3D20.19%
>    lat (msec)   : 750=3D3.79%, 2000=3D0.32%
>    cpu          : usr=3D0.11%, sys=3D0.52%, ctx=3D2673, majf=3D0, minf=3D=
38
>    IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=
=3D0.0%,
>  >=3D64=3D0.0%
>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       issued rwts: total=3D0,317,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>
> Run status group 0 (all jobs):
>    WRITE: bw=3D5394KiB/s (5524kB/s), 5394KiB/s-5394KiB/s
> (5524kB/s-5524kB/s), io=3D317MiB (332MB), run=3D60174-60174msec
>
> Still at 6 MBps. Should move this discussion to the openzfs team, or is
> there anything else still worth testing?
>
> Thank you very much!
>
> ---
> Felix Rubio
> "Don't believe what you're told. Double check."
>
> On 2024-04-04 21:07, Jeff Johnson wrote:
> > Felix,
> >
> > Based on your previous emails about the drive it would appear that the
> > hardware (ssd, cables, port) are fine and the drive performs.
> >
> > Go back and run your original ZFS test on your mounted ZFS volume
> > directory and remove the "--direct=3D1" from your command as ZFS does
> > not yet support direct_io and disabling buffered io to the zfs
> > directory will have very negative impacts. This is a ZFS thing, not
> > your kernel or hardware.
> >
> > --Jeff
> >
> > On Thu, Apr 4, 2024 at 12:00=E2=80=AFPM Felix Rubio <felix@kngnt.org> w=
rote:
> >>
> >> hey Jeff,
> >>
> >> Good catch! I have run the following command:
> >>
> >> fio --name=3Dseqread --numjobs=3D1 --time_based --runtime=3D60s
> >> --ramp_time=3D2s
> >> --iodepth=3D8 --ioengine=3Dlibaio --direct=3D1 --verify=3D0
> >> --group_reporting=3D1
> >> --bs=3D1M --rw=3Dread --size=3D1G --filename=3D/dev/sda
> >>
> >> (/sda and /sdd are the drives I have on one of the pools), and this is
> >> what I get:
> >>
> >> seqread: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-102=
4KiB,
> >> (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D8
> >> fio-3.33
> >> Starting 1 process
> >> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D388MiB/s][r=3D388 IOPS][eta 00m:00=
s]
> >> seqread: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2368687: Thu Apr  4 =
20:56:06
> >> 2024
> >>    read: IOPS=3D382, BW=3D383MiB/s (401MB/s)(22.4GiB/60020msec)
> >>      slat (usec): min=3D17, max=3D3098, avg=3D68.94, stdev=3D46.04
> >>      clat (msec): min=3D14, max=3D367, avg=3D20.84, stdev=3D 6.61
> >>       lat (msec): min=3D15, max=3D367, avg=3D20.91, stdev=3D 6.61
> >>      clat percentiles (msec):
> >>       |  1.00th=3D[   21],  5.00th=3D[   21], 10.00th=3D[   21], 20.00=
th=3D[
> >> 21],
> >>       | 30.00th=3D[   21], 40.00th=3D[   21], 50.00th=3D[   21], 60.00=
th=3D[
> >> 21],
> >>       | 70.00th=3D[   21], 80.00th=3D[   21], 90.00th=3D[   21], 95.00=
th=3D[
> >> 21],
> >>       | 99.00th=3D[   25], 99.50th=3D[   31], 99.90th=3D[   48], 99.95=
th=3D[
> >> 50],
> >>       | 99.99th=3D[  368]
> >>     bw (  KiB/s): min=3D215040, max=3D399360, per=3D100.00%, avg=3D392=
047.06,
> >> stdev=3D19902.89, samples=3D120
> >>     iops        : min=3D  210, max=3D  390, avg=3D382.55, stdev=3D19.4=
3,
> >> samples=3D120
> >>    lat (msec)   : 20=3D0.19%, 50=3D99.80%, 100=3D0.01%, 500=3D0.03%
> >>    cpu          : usr=3D0.39%, sys=3D1.93%, ctx=3D45947, majf=3D0, min=
f=3D37
> >>    IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D100.0%, 16=3D0.0%,=
 32=3D0.0%,
> >>  >=3D64=3D0.0%
> >>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%,
> >>  >=3D64=3D0.0%
> >>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.1%, 16=3D0.0%, 32=3D0.0%=
, 64=3D0.0%,
> >>  >=3D64=3D0.0%
> >>       issued rwts: total=3D22954,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0=
,0
> >>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=
=3D8
> >>
> >> Run status group 0 (all jobs):
> >>     READ: bw=3D383MiB/s (401MB/s), 383MiB/s-383MiB/s (401MB/s-401MB/s)=
,
> >> io=3D22.4GiB (24.1GB), run=3D60020-60020msec
> >>
> >> Disk stats (read/write):
> >>    sda: ios=3D23817/315, merge=3D0/0, ticks=3D549704/132687,
> >> in_queue=3D683613,
> >> util=3D99.93%
> >>
> >> 400 MBps!!! This is a number I have never experienced. I understand
> >> this
> >> means I need to go back to the openzfs chat/forum?
> >>
> >> ---
> >> Felix Rubio
> >> "Don't believe what you're told. Double check."
> >>
> >
> >
> > --
> > ------------------------------
> > Jeff Johnson
> > Co-Founder
> > Aeon Computing
> >
> > jeff.johnson@aeoncomputing.com
> > www.aeoncomputing.com
> > t: 858-412-3810 x1001   f: 858-412-3845
> > m: 619-204-9061
> >
> > 4170 Morena Boulevard, Suite C - San Diego, CA 92117
> >
> > High-Performance Computing / Lustre Filesystems / Scale-out Storage
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
