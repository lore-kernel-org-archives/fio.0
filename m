Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A1F12D201
	for <fio@vger.kernel.org>; Thu,  4 Apr 2024 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712257655; cv=none; b=ccPj1vhOFQSdI4ynSsx9YTeBaS+3kfj/0oGy685oybzR+zzC7biIuOjk2p4xtUnLTQHNL6EihpmIz/qOmm3WWu6ONb4DyxjmWDud7tBFCD3PdptO/4t3RKFprBAxyZaIHpbXUuqpTNVpUcgDg1Z1a+VaTCpJ5Azt0Ni/rzhtGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712257655; c=relaxed/simple;
	bh=PFn6opNnVitku4M+LzpnWoxqtuuS0PF8uZVWya0BhuM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vA7SJzZ69FA1ESX1O6U7LDP/crc6xCgYdGJeNKHIBPy4HYdrsDHb47EOkvwIqfLx1J7afZifdSVdPqknU50Su44hwieBNZ9scPSAWO4rm/9Me1VgYsqoQVHW/ZjJVBoGvEiQnWdOjLND6HtiEPwQ69butWnsSLR8CcFIYTFC86U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com; spf=none smtp.mailfrom=aeoncomputing.com; dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b=CFe0m3st; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=aeoncomputing.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aeoncomputing-com.20230601.gappssmtp.com header.i=@aeoncomputing-com.20230601.gappssmtp.com header.b="CFe0m3st"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-6098a20ab22so13261287b3.2
        for <fio@vger.kernel.org>; Thu, 04 Apr 2024 12:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=aeoncomputing-com.20230601.gappssmtp.com; s=20230601; t=1712257653; x=1712862453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJUDeYUgQLigYiUblW1+MMetRhk7FNYzM5YPmKJ1UqM=;
        b=CFe0m3st0goJUYjaZqlciY7TOj6LLYOOeJ8+ecVuJD6nH3LjvLt8A35g9ykda2m5Wj
         l9O4uStHicCXwRX2MpEkFZxdlNFH6mRwDUhLJeql4ZEYIiK8nHPoRnyfiSWezR208dre
         OeyavcLSVlXvjHIE6xuKz2AomlQu7TDvB6VfScOhYo2fwicZxOp7BzzxuRou5fzyVRsa
         mX7CgydAYgL5nCq5eLZw5LsU6LT5FMct/eBjwzw5rzSMJhSpJySsNniOASZJdzHly3hw
         nYSusvNeqpu6lghyFLK3ecQWetdOkfmwbE5zmdQEIfwo0qZYWjf3ZjJnQNLwipkjvuWZ
         V2zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712257653; x=1712862453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJUDeYUgQLigYiUblW1+MMetRhk7FNYzM5YPmKJ1UqM=;
        b=XFObC2UwP8zV2atbE9KCCt4umfuPESbBMW85S3OowDvOzd/ONaia+8fEotXA6pji5d
         n7ArknDnIvnGpOdIXPUFmPD+vvAwogs8UhfI/5hzreNaikAhMpOFv3u1VFa2L/a4Gl6h
         qvwxV8I2WG3R38kJSteSmWaCBni7coPTLLyQqcXk1qQ+6eSWFtz+p8bTJiNNH6O2uceD
         42dcuCXAiVEpmeGmgy0eheQCUkm1QzmB1PBYzHKnjv1wgJHDif3M0H8ITbMV9Q2KzrTc
         9CVM9MGYDqXcnUpjpJX9F6UZNQj4t20aucEsEhSjDS0l4yloFGVHQeJan+Hc2Wa20I/C
         EBQA==
X-Gm-Message-State: AOJu0YzBGtqMIo5ZZocUbEQoQxO6k56wxAqfUcQi7/0yhMcjT6jDNRy/
	n/WrhDTDvqMH/a6+RcDoALKHl703bBO+uXawRMYXi5ysjku8l5kviQvcNzDAzR/GRbJD3Snp6iA
	y5f31QLmbYQXLOgE3U0lUV0SIl2xvNDStfUTP8Ox+UJXYsxpM8Cg=
X-Google-Smtp-Source: AGHT+IHpW3nqbgtG/cdmVEB8ONSzMBXSd/vXN8x87Y134QDhGvZY4kBKEDM27dFv78fbUF8Cyxscs0JjZGIiIbS6vpI=
X-Received: by 2002:a0d:d852:0:b0:615:18fa:6a8e with SMTP id
 a79-20020a0dd852000000b0061518fa6a8emr3437347ywe.14.1712257652959; Thu, 04
 Apr 2024 12:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <90e42eaab7569a03239ad05dfd1ebb1d@kngnt.org> <2494cb75-e0ff-41fe-ad4c-73f383a0c704@cs.utexas.edu>
 <a3415a4de55f178b06c3451fdbe43e08@kngnt.org> <cfbf631e-5783-40a1-b577-9716c3cdc955@kernel.org>
 <CAFCYAscWYUASXzLYk1d1M1d2zcZDtPaz3PdwV_hZmxPw_tRxPA@mail.gmail.com> <7c7cb7c19e6f3587864f37888122b58d@kngnt.org>
In-Reply-To: <7c7cb7c19e6f3587864f37888122b58d@kngnt.org>
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Date: Thu, 4 Apr 2024 12:07:22 -0700
Message-ID: <CAFCYAsfBmYA9hr3MyL91DiPb4+fpavUU_GXERGcjt7ytQQ5WJg@mail.gmail.com>
Subject: Re: help understanding the output of fio
To: Felix Rubio <felix@kngnt.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Felix,

Based on your previous emails about the drive it would appear that the
hardware (ssd, cables, port) are fine and the drive performs.

Go back and run your original ZFS test on your mounted ZFS volume
directory and remove the "--direct=3D1" from your command as ZFS does
not yet support direct_io and disabling buffered io to the zfs
directory will have very negative impacts. This is a ZFS thing, not
your kernel or hardware.

--Jeff

On Thu, Apr 4, 2024 at 12:00=E2=80=AFPM Felix Rubio <felix@kngnt.org> wrote=
:
>
> hey Jeff,
>
> Good catch! I have run the following command:
>
> fio --name=3Dseqread --numjobs=3D1 --time_based --runtime=3D60s --ramp_ti=
me=3D2s
> --iodepth=3D8 --ioengine=3Dlibaio --direct=3D1 --verify=3D0 --group_repor=
ting=3D1
> --bs=3D1M --rw=3Dread --size=3D1G --filename=3D/dev/sda
>
> (/sda and /sdd are the drives I have on one of the pools), and this is
> what I get:
>
> seqread: (g=3D0): rw=3Dread, bs=3D(R) 1024KiB-1024KiB, (W) 1024KiB-1024Ki=
B,
> (T) 1024KiB-1024KiB, ioengine=3Dlibaio, iodepth=3D8
> fio-3.33
> Starting 1 process
> Jobs: 1 (f=3D1): [R(1)][100.0%][r=3D388MiB/s][r=3D388 IOPS][eta 00m:00s]
> seqread: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D2368687: Thu Apr  4 20:=
56:06
> 2024
>    read: IOPS=3D382, BW=3D383MiB/s (401MB/s)(22.4GiB/60020msec)
>      slat (usec): min=3D17, max=3D3098, avg=3D68.94, stdev=3D46.04
>      clat (msec): min=3D14, max=3D367, avg=3D20.84, stdev=3D 6.61
>       lat (msec): min=3D15, max=3D367, avg=3D20.91, stdev=3D 6.61
>      clat percentiles (msec):
>       |  1.00th=3D[   21],  5.00th=3D[   21], 10.00th=3D[   21], 20.00th=
=3D[
> 21],
>       | 30.00th=3D[   21], 40.00th=3D[   21], 50.00th=3D[   21], 60.00th=
=3D[
> 21],
>       | 70.00th=3D[   21], 80.00th=3D[   21], 90.00th=3D[   21], 95.00th=
=3D[
> 21],
>       | 99.00th=3D[   25], 99.50th=3D[   31], 99.90th=3D[   48], 99.95th=
=3D[
> 50],
>       | 99.99th=3D[  368]
>     bw (  KiB/s): min=3D215040, max=3D399360, per=3D100.00%, avg=3D392047=
.06,
> stdev=3D19902.89, samples=3D120
>     iops        : min=3D  210, max=3D  390, avg=3D382.55, stdev=3D19.43,
> samples=3D120
>    lat (msec)   : 20=3D0.19%, 50=3D99.80%, 100=3D0.01%, 500=3D0.03%
>    cpu          : usr=3D0.39%, sys=3D1.93%, ctx=3D45947, majf=3D0, minf=
=3D37
>    IO depths    : 1=3D0.0%, 2=3D0.0%, 4=3D0.0%, 8=3D100.0%, 16=3D0.0%, 32=
=3D0.0%,
>  >=3D64=3D0.0%
>       submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.1%, 16=3D0.0%, 32=3D0.0%, 6=
4=3D0.0%,
>  >=3D64=3D0.0%
>       issued rwts: total=3D22954,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
>       latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D8
>
> Run status group 0 (all jobs):
>     READ: bw=3D383MiB/s (401MB/s), 383MiB/s-383MiB/s (401MB/s-401MB/s),
> io=3D22.4GiB (24.1GB), run=3D60020-60020msec
>
> Disk stats (read/write):
>    sda: ios=3D23817/315, merge=3D0/0, ticks=3D549704/132687, in_queue=3D6=
83613,
> util=3D99.93%
>
> 400 MBps!!! This is a number I have never experienced. I understand this
> means I need to go back to the openzfs chat/forum?
>
> ---
> Felix Rubio
> "Don't believe what you're told. Double check."
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
