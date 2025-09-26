Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BE923C51D
	for <fio@vger.kernel.org>; Fri, 26 Sep 2025 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758922986; cv=none; b=Hb+u88NJ7d5AfbgZ44eeaAksLkzrcgkxpX1LMPFu8brIMrFA3AClRwXLrq/xhSq6okxDT1+CJ/BR9BRTzP6gXW8/z5U2XQudfRLFRBK5qVpKb5qwXAV9XMJDkhd6LS0EqYnJuix0yYM+To4xEhRYQ4ydGC0d6K95oB+ird/fLB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758922986; c=relaxed/simple;
	bh=RtJpfdW1DBdsJ4EGN60Q1xzhg/pxn25sXor+x4iAVfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:Cc:From:
	 In-Reply-To:Content-Type; b=en+xOV8sNwb18Ft1+7BDbalQrfEw8B7jAl5sFr756B2xGu653yesOjN2NHMqvoKi9Jnq1CYCC/42//X/LRR6dkkQJk2HyzMsZ0H/9FHQNs1I5jbhRoMJvviLmQlM/1dSguhM4lcFfQeDaf0QwGMjYaecbCEEl25LSeLCrW2VCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YXcTxPRN; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YXcTxPRN"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-854fcb187b2so293452985a.2
        for <fio@vger.kernel.org>; Fri, 26 Sep 2025 14:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758922983; x=1759527783; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ahijqo+X3W2mSX+C9u0hosbBI8MhvcFM77+PLbqsoEo=;
        b=YXcTxPRNOmeE8+2DswHxbQcEg76iArCkv/8GvOWrENYuXBHu+TC4nKvIgyqa14m2u1
         0uM29peh7wlIkKO1/km/PuLFT1X20UTkQMjqx7Dwtbg//uQ/sj8UOyhQDp8EDqIjZ9yO
         yjacyfEgpr2RqB9fv+aOyAh1OYOAw4uHwgkq6DtqJ1Vd61FDluhTC3Easqtq4N6WcGvj
         YN6jVzq360nR6z4q3heLF9kOmUWvpk4Xgpik4dzCkDnXBZ3C/7STxOf1hJTKAjDyaSMm
         dpouJZbk5GvUwxb81BFpgKn9JYZdD/VpfxLcOcNFxIrfpRlkgPrkSo61kQhndJSvEZk+
         JyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758922983; x=1759527783;
        h=content-transfer-encoding:in-reply-to:from:cc:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ahijqo+X3W2mSX+C9u0hosbBI8MhvcFM77+PLbqsoEo=;
        b=fVddarQ+e9LLA9wyLNg/t7hu5Q4+RH60gELWMEWmc4wsWl/RAOBYritdHwMbZOmBrC
         QYoT84+N0KuIGVk1Ue6zQsJO7gNStIrHDLN2VQuNI9kMTnzfoSKYbfHnSR9xctFB85RV
         zZcjVMvvWzQj57vxH7N0O+DB0W838aQhaLpiuNfsFuPvdJm9QdV77zfSvCE6o73bDSKd
         spIcQt91EV+wwm0GzM83ag/hU4n7uQZMQFv9lS9f208Y8ci6T+gIPDVCKBPH50wKqhO7
         vBwkzlcawJvMfaXiSXAYlEVIC7WbP3P3KxILlKaePu0xEE//RyEc/OhJ+y1Syfz9EENb
         hYIw==
X-Forwarded-Encrypted: i=1; AJvYcCWXU9/+XyP9We7SldyoSxR2r/8Kh1JteqnVffjEOKjaSuxpPvJ4Lv3PAMEe2CE+Jg+RmXg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUpsdY1+OikLaDkmN2gcpCIDrEE/qAAG/yHBn7R/jnM2V7OmU2
	42bg58zDt7d0otUka1O2D2AXx3dCN+xvmQUyw6ml8vY4yU00aVTJ2zgZoN5c+SSf+I8=
X-Gm-Gg: ASbGnctuoLWsl0zRakHewabNMU51QMmH1HCmiV66fHZTKUYwWzE52TMVt7kpAUDro3+
	i+tDN7BRzKtJ4U3kGD04IKuUu3qr/X+BqGch9uDnbUeoAZwK9zK7GrZO39x5078MNkHkMEd4/X/
	shm6R/XPxymkL+xP21z07meIZyEvCXzrs2f7xPdgwC7NaHU7mnMSBG4I4aVpBqyjF2IRazMBGzs
	oZ66485vvuUomSpuoz3ZGVGOdiRhk/47luUDKgvpqncgA3LXnfMWz3G7CXD0T+5IsiXZPMOeNgr
	RRw6pmGHKFEb23rIf2x5r6KzOaL+Rf2q2HZvUgBTbqXMJnoS36YYaHkHHzdCn+slZh6EdTUbBMI
	a/BD1s00rxWjwO1yZD9Gn4Pz+u9W0f9J+yGc=
X-Google-Smtp-Source: AGHT+IHAK9+uXDWazOkRmiJXKa0I29LIdxG1cgI5ldIUFiHB3bASn3xyl0i61DIdGti8nJcG5Ek0dw==
X-Received: by 2002:a05:620a:29c7:b0:859:be3b:b5ae with SMTP id af79cd13be357-85adeb4db37mr1160319485a.11.1758922982941;
        Fri, 26 Sep 2025 14:43:02 -0700 (PDT)
Received: from [10.27.121.144] ([104.129.158.226])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c28a8a7e0sm349404985a.22.2025.09.26.14.42.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 14:43:02 -0700 (PDT)
Message-ID: <1394af5d-ca1c-453f-8a66-f0f3a53702cf@kernel.dk>
Date: Fri, 26 Sep 2025 15:42:29 -0600
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fwd: fio: ruh info failed
To: Shivashekar Murali Shankar <ssdtshiva@gmail.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <CAERsGfiZ9YVeXMGk=dL+orN3o2HXJ0Oy9EQhVwK43MMDUSA-WQ@mail.gmail.com>
 <CAERsGfgCA7iFwLQ2L+=QyEg0=KuwK4hq62QcYpnY5R4h9abZMg@mail.gmail.com>
 <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
Content-Language: en-US
Cc: Ankit Kumar <ankit.kumar@samsung.com>, Vincent Fu <vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAERsGfg8tHjtYQvDY5=rufh+PMGBNGCFxiYsNwMGn94o0e0VDA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/26/25 1:30 PM, Shivashekar Murali Shankar wrote:
> Hi,
> 
> I am currently testing fio with io_uring on an FDP-capable drive, but
> I see failures such as “fio: ruh info failed” when trying to run FDP
> job files. This is run on an XFS file system on a mounted drive. Do we
> have support for this?
> 
> Below is my fio job file:
> 
> [global]
> ioengine=io_uring
> direct=1
> bs=4k
> iodepth=32
> rw=write
> numjobs=1
> group_reporting
> fdp=1
> 
> [largedata]
> filename=/mnt/nvme/largedata
> size=30G
> fdp_pli=1

It's generally a good idea to CC the folks that worked on this, and
probably use the fio list rather than the io_uring list...

Adding them.

-- 
Jens Axboe

