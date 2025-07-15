Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C726FA69
	for <fio@vger.kernel.org>; Tue, 15 Jul 2025 20:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752612299; cv=none; b=WRPpmT1k4fIbN7Zk0MSPUUeq5PlcVRaObBOi3bvUMM6KsNayLwYKuHr8bYbjUcfdCQ5VnlEjjnQJOsJdnMJNeJqDOMQG8HnmlmsJdShmb4zbIH3xXiktO5Dz1DP9PAqL7JJ/ErXMeyE575AWY1on7PKlOIyveakNBBSqgHtFp0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752612299; c=relaxed/simple;
	bh=bh0e4MgyfsY8YDjy3U0B1g0tb6AXzSdGt27GWBYWIMk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tJvutyQCXpyZvYqhngKSyWEgSnIpu4g/XKYQW/xCN6q3vkzhzhAwQ9YqYomVpdxJtp06/H8CD2OSFhe5xJUq2e2Wm/z2tSBYjEfEEUd4bhrdNviXZstpPBmazIQZiwrmKUpnNyWDYwzeX8c87+mWQYK99onGJtz298SrotAh0qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ltNT0mmU; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ltNT0mmU"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso5048392a12.2
        for <fio@vger.kernel.org>; Tue, 15 Jul 2025 13:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752612295; x=1753217095; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=982meLr5xWTKlUM7JwWVM9lrC0A5lN8TFca55IGgEkI=;
        b=ltNT0mmUOjIaTXxyCdX4Yh8aE8+h+6ZfHW3+r1tjbLs/YwiTzOUg3hcuY2X9MRM+Qy
         AKAU0+mI1wesVyI/jo12+thdAOv9f3onhE0+ZR1vAYfrc5weTUPq0oCEU09Zmz59acTY
         6pcXu3QQmBZNkxqSGJG3lnbp3r6t7RQeorRtZ8aVWKX8Myre0XsJf1BK01ILymxtWyOo
         /cHGqiC2WdDbxx5OaIoZaT7SV58RfgjUPi6cE39ZosD6yNKe1ugPKCvClck9EeTZd+8f
         15vtSUG716ElLZJPajrpebsydu1xZoG203h0tmHQAd3MIOD9zHoch2cmy2YFvuJI8sjn
         JitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752612295; x=1753217095;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=982meLr5xWTKlUM7JwWVM9lrC0A5lN8TFca55IGgEkI=;
        b=j/EIrOUbekGZMiRNwq+41NkH29M/RI+4Knr8EiKdC76RQOuTpFYacbjh6T3wyWBuSO
         F9Kerw96cWdzGSZM7DWYMV0kwOQkoRotAgH3yIcZSWAtktbSBIPxgwYdZbEr4SIy0WKe
         VTcsyaIxuLkP+NlswdkZocwrPUUNbXpVrLYoK3A0JCuHpHH8zZLGELbrEi2z7TkDdX9d
         8Lj2p3CUV7B4jJCDPIGEqcPp6sdzDh6GSHVTuXkxhCe60aj3Ulik++yzwo3BrXpOESjn
         aQ3trJys/fRcHDAYM5Nrft9lYVJhKTSB83VZo4ZBp4ZPeoOs0zEebppTu6176Yp8RPx5
         MoMw==
X-Gm-Message-State: AOJu0YzgK8A9diBzY14UBgchfuAN4bCCw/NJk/6woDz447LyYpubqQWO
	+vWNdDOjYsKdKkMcj12jLhC4jiM3d8AH8wJrg9Axzp2PWtPcUh+kkRPBTXiib2LOlZRKLQ3Qzqz
	dTOqSQR3OzRCimoTkEY2VN0QlY0oW4DMYyPQV
X-Gm-Gg: ASbGncuJrihyT7Z+haqfxO0rFAdzuCZMyC7vHCZRZDkzQ5vid2Dlxd/kLQyPEoP17Px
	hwgk/+w7dYgy4K5lvohPleNNn4Hx8FE1Nxsi1/TI49NDkX89wWjwVOQwN5amWtSQqs8xaNOWazb
	CCP6boZ+/LKNzegsBCsMln9n/wLGXlT1S4eCHbzERcufJkg3du9kNFy4zu6IWz7vthEPiZGMBkd
	mGAEdMuuVc190RBhXSK36GDms/dznC9ILVq8Z5v
X-Google-Smtp-Source: AGHT+IEivBFUYdzGELPOtQBGc0Z9sW/wqgX/pR7oZPxHrE2Rc8C9x9IsALa2/w8j2tNAyOTggYRIoeq0omHXdiXKNmQ=
X-Received: by 2002:a17:90b:1f81:b0:31c:36f5:d95 with SMTP id
 98e67ed59e1d1-31c9f3c3429mr123303a91.2.1752612294643; Tue, 15 Jul 2025
 13:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aHXkeSsuqlIj2R64@glanzmann.de>
In-Reply-To: <aHXkeSsuqlIj2R64@glanzmann.de>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Tue, 15 Jul 2025 21:44:27 +0100
X-Gm-Features: Ac12FXxgAFP8feYE6_gBM4ZzGzY4EYAb6XP8EAUxaWzs0hlWfLtMIOkWivmpzvI
Message-ID: <CALjAwxiPOrgYLj2oyOeupgtk2mr7L3xMVdZYLjyRavsPqj==Qg@mail.gmail.com>
Subject: Re: Evenly distribute jobs and iodepth over a 1 TiB device so that
 every byte is written to in parallel
To: Thomas Glanzmann <thomas@glanzmann.de>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello Thomas,

On Tue, 15 Jul 2025 at 06:18, Thomas Glanzmann <thomas@glanzmann.de> wrote:
>
> I have a 1 TiB NVMe namespace from a NetApp connected via two distinct
> direct links to a Linux system over NVMe/TCP. I would like to generate
> read and write I/O using multiple jobs/iodepth so that every byte of the
> device is being written to in parallel with the maximum number of
> available parallel inflight I/Os. The NetApp does deduplication
> and compression by default so I want to generate random data. Because I
> think if I don't do refill_buffers, the NetApp gets that the same data
> is used over and over again and dedups it. I tried:

It depends on just how clever it is. By default fio uses
scramble_buffers
(https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-scramble_buffers
) which may be enough but you would have to check. The trick would be
to see what happens with a single stream as that's easier to reason
about.

> fio --ioengine=libaio --refill_buffers --filesize=25G --ramp_time=2s \
> --runtime=1m --numjobs=40 --direct=1 --verify=0 --randrepeat=0 \
> --group_reporting --filename=/dev/nvme0n1 --name=1mhqd --blocksize=1m \
> --iodepth=1638 --readwrite=write

If I'm reading this correctly you have 40 jobs all sequentially
writing the same 25G of the device at the same time. This is
problematic because if you send two or more write I/Os for the same
area to storage at the same time then something in your data path
could legitimately just throw all but one of them away and say "I'm
done" (because one I/O overwrites the others) - you're essentially
saying "I don't care about the data" and in certain setups such
behaviour is undefined. One change you could make is to have each of
the 40 jobs write to a different region to the others e.g. by using
offset_increment
https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-offset_increment
and size https://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-size
.

<snip>

> So, I ran:
>
> (live) [~] pv < /dev/urandom > /dev/nvme0n1
> 1.00TiB 0:59:14 [ 294MiB/s] [======================>] 100%
>
> And afterwards more physical space was used:
>
> na2501::*> aggr show -fields physical-used
> aggregate      physical-used
> -------------- -------------
> dataFA_4_p0_i1 1.15TB

Do you get similar results in terms of space used with a single fio
stream? Start small and then work your way up!

> So, what is the best way to use fio to write random data to every byte of this
> 1 TiB device in parallel?
>
>         - Is there a command line parameter?
>         - Or should I create 40 25.6 GiB (1024/40) partitions and give them as
>           colon separated list to fio?

See above.

> I also would like to determine the number of queues and queue depth? Is there a
> command available. When I run:

fio does report statistics about what queue depth each job internally
reached but these may be different to what your device sees for a
variety of reasons (e.g. splitting a coalescing done by the block
layer). See IO depths/IO submit/IO complete over on
https://fio.readthedocs.io/en/latest/fio_doc.html#interpreting-the-output
. But perhaps you're thinking of device queue depths?

> fio --ioengine=libaio --refill_buffers --filesize=8G --ramp_time=2s \
> --runtime=1m --numjobs=40 --direct=1 --verify=0 --randrepeat=0 \
> --group_reporting --filename=/dev/nvme0n1 --name=4khqd --blocksize=4k \
> --iodepth=1638 --readwrite=randwrite

Given you're running 40 jobs I'd be surprised if you can hit a depth
of over 1000 per job (that would be over 65000 I/Os in total) without
some serious tuning. You may want to look at
/sys/block/[disk]/queue/nr_requests (see
https://www.kernel.org/doc/Documentation/block/queue-sysfs.rst ) and
/sys/block/[disk]/device/queue_depth but you may also find you run
into libaio limits...

> And also watch 'iostat -xm 2' I can see aqu-sz is 194.87 per path and
> 391.96 for the multipathed device nvme0n1. So I kind of know it but
> would like to have a command on Linux that shows me the available queues
> and queue depths.

I'm fairly sure iostat is the right way to go (unless you wanted to
write some BPF tracing).

-- 
Sitsofe
