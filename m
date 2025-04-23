Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3984C265613
	for <fio@vger.kernel.org>; Wed, 23 Apr 2025 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745442285; cv=none; b=hfMdJVpvDhSoxwFeZh1SIi5UlY5lbzVYULPKgLaEPMZOF0RqbzyikGeJONYeDvaIVNjTNQzlKINgPHKibrU/3VC3W2l+wIAHiSzQw4TEp6DR3sFnoo/YQFDTcLOXR7eig5xu4e/qn1yA030VfWW//vwDPZCasUewZAjKe31SRn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745442285; c=relaxed/simple;
	bh=gVO+GOtJAcYSPnCdBTGkcxm+Re8Bmmq/qk4f/BagVsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=doDwCwqmJSdAYKbc9n4kAGjfFjZMow858XQh+/OrXSyGy9M/AjH5v4xfTLDAJ/ctCnbncpQyjz/G1xi5Z4Ldn0RsQy3p4Se7KVT87vdAndKwTWfIQul5WlkGf86yScertz6B/A03ZCghBzIMeAff+xh+F3VRerTNEOVG3swniTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com; spf=pass smtp.mailfrom=pcpartpicker.com; dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b=c4Wrw6y+; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pcpartpicker.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pcpartpicker.com header.i=@pcpartpicker.com header.b="c4Wrw6y+"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5f623af283fso38171a12.0
        for <fio@vger.kernel.org>; Wed, 23 Apr 2025 14:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google; t=1745442281; x=1746047081; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gVO+GOtJAcYSPnCdBTGkcxm+Re8Bmmq/qk4f/BagVsM=;
        b=c4Wrw6y+Sr2eWUY9ID7nw/LxhV2yMPMgPMdw21ARe+bmxVPId5iELL7tkGExr69kQ3
         OeqpCBhDgHtZ+J4mL4fhjf0cLntYTLZWF9JRKZpIlm63YUSCxTq8xoR2Ln4gxfFFCwwP
         9RJZbfJpGkRINGlRsdFk4HTClpD95H3k/HztejjKKX3o+CxH61hGUCpBrzo1j99mUZpS
         A1A3Y7dhXBOXiK8GlxcQ9KakxCT9N7dpt82gh4ncwgK5fb2jd/5DLIwupGoTqRO35RoD
         o66mFuu1LRybZQiLjWq9RMpWT37oqW8w0sV3/z5PStEItCPbyCOKM+EBtbRyuszycZMd
         tE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745442281; x=1746047081;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gVO+GOtJAcYSPnCdBTGkcxm+Re8Bmmq/qk4f/BagVsM=;
        b=jcn36MZERsonJZpCKniINbgpVVr5guofiVXOiLv86LgkGcm2SMN8Q/gucGY7hyKYC1
         TZ3ea/Uhj6JoXqyVU7Yt4SRbM8D0u5T8ap9jQeVUv7lBI2JqNTrbncvKwhKvo/glV03R
         6r899evLj0OXPngpycOIFJ6UeZIzxCs9L1lWI5VGi9NZ+f2RcSC4ppoGgavRf98pdQqv
         nyvBaRaWiNOJ9XVsYlvndpVbyP1yMKf6bQMDqvhktD/PA6KViAP1b+krogV/8JDdCvZu
         HPUmzGTOAAKloaiCpV3vWCcpXwyMG69WeFOGmvafVGlG2A2qzw1zMYZt1Ff2A22eke2f
         Iv1Q==
X-Gm-Message-State: AOJu0YzkaDdT21RgPNvLnVfhcANn/yB6sYeZLUXSsWK/2ABIuG1FpJ/8
	eEStrZCK8FNYWKJGAuleJAm0yZZO9Zc/6kgzOsRg13dnBRTzQc7s04b1pMs9dJiFArVy6MZ6qPu
	OaeLXILYQi2TLOVQXWRa/lOUAnABVHkziDfZdYsXrlTCerW3kUxo=
X-Gm-Gg: ASbGncuC3Rg403pVoU/qI9uiWN98ifIKfDXAk+tWMbbAAs/UpxAKOJu9F4DgNp0PCxg
	P+Ov3EDqvjge2IUeCdR+KD5aSPrRmQD67ciXfrgUraQPtynesVDAfddiYZ4CrdJxOvFZa46gZ0j
	F07dtslc4Wm7dNcfj+taHaag==
X-Google-Smtp-Source: AGHT+IHVLHWZNtI3FySKdrts9Yobcum0HoDsOQgjUenz5cxbTgwW70FqPcEKsj3xn5Urs78f0pVAufEM2ns1/yMC1gs=
X-Received: by 2002:a17:907:3f12:b0:ac7:3910:17b8 with SMTP id
 a640c23a62f3a-ace57485e5emr7070866b.15.1745442281427; Wed, 23 Apr 2025
 14:04:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
 <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org> <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
In-Reply-To: <CADqNVTrptG5b4Un=Q9Hqe5WPMTdcaCDtbjzR753j9YWorEBnxA@mail.gmail.com>
From: Nick Neumann <nick@pcpartpicker.com>
Date: Wed, 23 Apr 2025 16:04:28 -0500
X-Gm-Features: ATxdqUF3eJFhFXaqhbwUmLEhiaq9nAnrTNAb9CRbklwXhV0HLNoGG9dh_5KOTOE
Message-ID: <CADqNVTqM3se6L=qJUh5U3kwpWCCbuR3GjE+xQ+JCQVRL=t60OA@mail.gmail.com>
Subject: Re: Performance variation in traditional HDDs?
To: Damien Le Moal <dlemoal@kernel.org>
Cc: fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Just a quick update on initial test results. We started with the two
"identical" drives (https://pcpartpicker.com/product/BcQG3C) that
showed the largest difference. Note these are SMR drives so we are
careful to do an "ATA SECURITY ERASE" before running our benchmark.

Previously we had these drives sitting vertically in 3d-printed trays
during our benchmarking. We moved to benchmarking them mounted
horizontally with screws and vibration dampening pads. They were
mounted to a heavy metal "open air" style case. Drive 1 was
benchmarked, then Drive 1 was removed and Drive 2 installed in the
exact same location as Drive 1, and then Drive 2 was benchmarked.

We didn't see any real difference in results when changing to this
traditional mounting. Drive 1 went from an average full-write
throughput of 174.06MB/s to 174.08MB/s. Drive 2's average full write
throughput stayed at exactly 157.88MB/s.

Looking at a graph of throughput over time for the
differently-behaving but identical drives is really interesting:
https://cdna.pcpartpicker.com/static/forever/images/content/13b2fa7e147ddd5359f5638b4efde7af.png

We're working on making sure our HDD mounting is adequate. Do you have
any specific guidance/tips on what should be done? Is the goal of the
mounting to prevent outside vibrations from affecting the drive,
dissipating internal vibrations, or both? We use a number of identical
3U rackmount machines for our SSD benchmarking and would also like to
leverage them for diving into this HDD issue in more depth, but they
do not have traditional HDD mounting locations. So for now we are more
slowly conducting experiments on one of our open-air dev benchmark
machines, which has proper mounting locations.
