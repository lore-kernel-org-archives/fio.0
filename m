Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6D274400
	for <fio@vger.kernel.org>; Mon, 29 Apr 2024 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714406837; cv=none; b=TQKda/AT0qFrxcaxnBB3BdvbXW+0HUsqvf/xb0vuKx4x/O1XUVRv/3yphPtf+nfxVV671zckKvMR41Zefiuehz+g/DaOFSxdtHWEdwN4Kt8dhmtX/qPd+wrrQokaxzVS/PfqInK9RVeu7Sh1KCtOtTzSKDjj3TvJHUO/Nn2OxU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714406837; c=relaxed/simple;
	bh=hx4TuJLGPMi30dxtOluuHCFAnU3Z3qHhSF5h8kxuxfs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=e9m+u2OCZeNA5/yAZlara8fRM/hgGb5OBk1IqPerKPdHqiB2ypqSVIiGtk1fCE/Vydh64nZ3791MqOL5izs2J+sbV6ioD8Pq+hbrhIStazdidx8/jaDhtknAty5nximTFbFcIzNEyKcPytNiADaKrOrDPX2bXygoCI//9kvqbkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJnr2B+K; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJnr2B+K"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2db6f5977e1so54676721fa.2
        for <fio@vger.kernel.org>; Mon, 29 Apr 2024 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714406833; x=1715011633; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6kQRRydI/uozpUt2H+vR4ia2gVp9Jr1IlafB1XBapqM=;
        b=dJnr2B+KLIEmN5nCOhHJVojP7jruprqtEmfKtym9NS2+jZtvpFvpPdxCeTfQNgIXMt
         rsE+818Ser7L66S4G+BoSoW5B36AuaZn64hHkRMiqWusTgGAolG12+8Hdyxafg0ajRD6
         QznbPrZ05Uuv2G5KYtaN4Fu2v+Oz18Ph1dAy+qaEISgzbqSao8wsceEjPfPJqboU5Kqq
         x/Jc7bgikBWtL8JEXxrJnGpcPi7nJRKRYNP+Zxr5iUKKCPWRWmfTdSMrWDYxMifJuNOR
         SUX1ImF1F8Z7HkXoOSuogfYucf7hSYn/8bPuNZmCT4XK4/yoopWkpQNQjDNGFULe71Rn
         ZsvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714406833; x=1715011633;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6kQRRydI/uozpUt2H+vR4ia2gVp9Jr1IlafB1XBapqM=;
        b=aP08u5D88d1FyOGeCXAnw07OWf0DkMhpOqD/GBtn4ZuSp5KXOgO6GPAaG4LB3ENbK/
         ebtPzwFE5R6NB3lwACKFnqSH6DFRq0rtXS0Gw4pWV1HGQLdu2uc5Lob2+4UHbdwxo+ei
         mCn1qIvZsqxzputX7NR0EBiwvhjPa29a6dP3JS07S570L+BGrJbaUR08b6fjcFNm0HJR
         KHTCyVZhVkBPk04trZlCCbpRRRSAt0lvz6xAR0Fv6haxixM7Sz+riVYBJM9jkbhv/730
         PK+H6g7wDukxn6vwWCe8PIyv6dIOOLSNige5xmUZ38YXddogHhUzv3JUyg4750MuR4EO
         26Tw==
X-Gm-Message-State: AOJu0YzdmA5wV0R/GRGXzRBuXm6vGb0V4xNs9DiCSEMu1rpMvamuajZZ
	AmpXvKOu+D9s8H1yLpR3XEQs5a7UvT+MlStP6CymgQV6udgg71qR8uw4OnDp6uRM/a87zpVLUGF
	+K8ez7RWU8nTgp4jlVxXMKAGcQDKrplVW
X-Google-Smtp-Source: AGHT+IFLSq7oPqnDjx7hxo61E9JjhfiAKMvTiXtf1ToQBw7YmuLtlwrT6tZeBUGndSX0uH9y0jssOdB+zN6q8sIv/KI=
X-Received: by 2002:a2e:8689:0:b0:2d4:54f2:c409 with SMTP id
 l9-20020a2e8689000000b002d454f2c409mr85551lji.38.1714406832811; Mon, 29 Apr
 2024 09:07:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Mon, 29 Apr 2024 17:07:02 +0100
Message-ID: <CANvN+ensCLCiNoy-9nmT6hEXw7g0or7PwgzPhftKpg29wJkrDg@mail.gmail.com>
Subject: io_uring initialization fails on Alma 9
To: fio <fio@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi guys,

I'm seeing io_uring queue initialization failing on Alma 9 (see below
for the details). Any hints/suggestions/workarounds?

Regards,
Andrey

[akuzmin@boots ~]$ uname -a

Linux uboots 5.14.0-362.24.2.el9_3.x86_64 #1 SMP PREEMPT_DYNAMIC Sat
Mar 30 14:11:54 EDT 2024 x86_64 x86_64 x86_64 GNU/Linux

[akuzmin@boots ~]$ fio --version

fio-3.35

[akuzmin@boots ~]$ sudo grep io_uring_setup /proc/kallsyms

ffffffffb8fd4ec0 t __pfx_io_uring_setup

ffffffffb8fd4ed0 t io_uring_setup

ffffffffb8fd4f60 T __pfx___ia32_sys_io_uring_setup

ffffffffb8fd4f70 T __ia32_sys_io_uring_setup

ffffffffb8fd4ff0 T __pfx___x64_sys_io_uring_setup

ffffffffb8fd5000 T __x64_sys_io_uring_setup

ffffffffb961d5d8 t io_uring_setup.cold

ffffffffbaab0180 d event_exit__io_uring_setup

ffffffffbaab0220 d event_enter__io_uring_setup

ffffffffbaab02c0 d __syscall_meta__io_uring_setup

ffffffffbaab0300 d args__io_uring_setup

ffffffffbaab0310 d types__io_uring_setup

ffffffffbb2bda48 d __event_exit__io_uring_setup

ffffffffbb2bda50 d __event_enter__io_uring_setup

ffffffffbb2bfb18 d __p_syscall_meta__io_uring_setup

ffffffffbb2c3ab0 d _eil_addr___ia32_sys_io_uring_setup

ffffffffbb2c3ac0 d _eil_addr___x64_sys_io_uring_setup

[akuzmin@boots ~]$ sudo fio --name=randwrite --rw=randwrite
--bsrange=4k-64k --runtime=10 --time_based --group_reporting
--direct=1 --iodepth=64 --numjobs=1 --ioengine=io_uring
--registerfiles=1 --percentage_random=50 --filename=/tmp/file.dat

randwrite: (g=0): rw=randwrite, bs=(R) 4096B-64.0KiB, (W)
4096B-64.0KiB, (T) 4096B-64.0KiB, ioengine=io_uring, iodepth=64

fio-3.35

Starting 1 process

fio: pid=3051, err=1/file:engines/io_uring.c:1047, func=io_queue_init,
error=Operation not permitted

Run status group 0 (all jobs):



Disk stats (read/write):

    dm-0: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%,
aggrios=0/0, aggrmerge=0/0, aggrticks=0/0, aggrin_queue=0,
aggrutil=0.00%

  sda: ios=0/0, merge=0/0, ticks=0/0, in_queue=0, util=0.00%
