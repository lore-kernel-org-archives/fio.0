Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244DC2036E9
	for <fio@vger.kernel.org>; Sat, 31 Jan 2026 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769867983; cv=none; b=HQR8NJ7mrjO8XmNhlPcCvaaJ92L1DGq+QXsa2Siin0S6W5Xce2Y//cHkwPjttJ5RiQFzLck6RstsRUbwRFtC7XDUTDfymtEZZMcM8mbm8H3WvqZwYRRfzZRx2s6E5UFl/CerDR4EokLiq79wtbgdqRdh7gVu7QZn3LCM/dRdIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769867983; c=relaxed/simple;
	bh=HCs5USBvUcky1v/cIZSzXu1Yfjtv7ITPo+d2PgF6hXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMcwR2wAH7/4e+V5tL8NDBLQ+iF81YbA6IPEf9eH/HetgEiTp+RTGXMemx1oFxOGgq/5QMA8dZWT4OLaHwP1Xp8bDv7JFHKF0nmBEj0ZqSe74V0Q3GweZXOmYc7rSUMfpQxGJ/BNEJN7LdlmVx1nRSncnXP5YX74asXWwBP4m/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Zj2jMc7N; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Zj2jMc7N"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40438380b88so1879773fac.3
        for <fio@vger.kernel.org>; Sat, 31 Jan 2026 05:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769867980; x=1770472780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gFPzwKnvWm4ZsDJe5ReUhT1CAfurOMdzRviehFrpqtU=;
        b=Zj2jMc7Nk3Fwp2WuVX4ak8qWW8/YSjwC6rlJKbUv0tfZOxWnPF+sC1ZGY2FpJ/pSTj
         iBQtPu6zL7CUK9Fa+omphes3lO7X/jbqI9Ti5f6oZ9awmrtH4EBJoT071FHZaj5A8U7y
         KF9kCEvnufukWltHwFpjKZePFUFmHlIff94qG3rVCF5EdyIgAqxje9l7nQAASMvbkEhC
         FzpGd1fVXbkIygQfCR6HMaYGUImzLDNRaujw23cIJs6TfLU6C+cC2k/bNUjRLIfniCQh
         R7dI0MGuOpiXN6uydFLrQRqk8F8q64zSFCkWIXfTxjs0DiKUGKaoinPCKjNS9gL3LG/J
         whUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769867980; x=1770472780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gFPzwKnvWm4ZsDJe5ReUhT1CAfurOMdzRviehFrpqtU=;
        b=bRRTNaYt3vZPuhjE5UH9DUj9j+yA92jaktSiXfxUpWREG9ayoUvM1xEjHaOAyXA/e5
         roalJcxlb9BlmBucFTEJSNDme/a4NkPFemhpYYpMgvIn/Na35ssrWaeqFgpM9ws+Rikh
         6d2+qzhcIjSCqJOiI3lZ8aJpRuurwMFt82ehIBqGCdlLFT9YcvMFn9KcTd4rrxi0N7rQ
         m0VSMEUZJ0EUMWtWZcjzStsb/zWTsYUNc4Q1XOLeoVCxUDFcK7BNy7fsLiKOje9sKvjV
         sR5r7wzMiOwYYFjK1ppFYZQ+1CEOYgB+qlXrMo0Lw14yFm7M1hvHLJjTCL172o2V/cE6
         qrnQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6+7GQJsomYYKPAW64aX9M4hllTwkmJ15lS3YgygOg/AKEl6U4UhKHhkV0dPQIIn5jT8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSytj4031ftEk7b5U9CbSlFMbVs3/jVCiReyuztAe/cN5m/kQD
	vYCUPzE9/pIh9FrZmLGU18nkmuu0fCVj7jwxAzz2JThLgoWDsN8Dl42xIZNuU2PC4Tk=
X-Gm-Gg: AZuq6aJr6pvyXTmGy29vwdP6mY8FpiKI2Lw7Prc2FcvqjwgDVpdnafWejQZZx2vXvn8
	ze5WO7e1/iWdqwwmxeNMSxJmXS2/+Ogz9Tx+1ptToZ6apbGXTTTREoEGqPRLKUvIte0HW8Gm3Lw
	RR45Df9IhA+Jr0F5RGWnWFFEuy3UymmFVpmX8qfDpWM4jWEo8KWBryWVYdleSOGE7+nwwe096O8
	QifGnaJp5M8TI/nbvC1zseJfZG2UapZVdT27QwNJKm8TrfOohldEzmEyHzwIs9Jvh+1NyXRebD6
	vvI9uS2GBBK22nJbdfRP7nw/58j1LWbtY2AfhfxfKpMCBkafD+/oFuQuCmsNy7NBQGOe3IFtmSX
	r1h6qfbUGkTFucHrJNI4A3hv5iv31JN+9I2M1mNG/rB5lE65PticURFKqygA1rln9tJW7KkJt0E
	h3pG8pVAkHh6JdwnHSC3aZpfnzUeYtNSgeRvL6x+WcwkkxrX91j3gXp+Iqe5YPupSYYnN5aw==
X-Received: by 2002:a05:6820:1744:b0:659:9a49:8f34 with SMTP id 006d021491bc7-6630f3a81demr2617278eaf.69.1769867980069;
        Sat, 31 Jan 2026 05:59:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-663143c891bsm2402507eaf.17.2026.01.31.05.59.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Jan 2026 05:59:39 -0800 (PST)
Message-ID: <e1509431-d6a9-4644-b52b-118f10672a0b@kernel.dk>
Date: Sat, 31 Jan 2026 06:59:37 -0700
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/2] Introduce a page_fault ioengine for MM workflows
To: Nico Pache <npache@redhat.com>, fio@vger.kernel.org
Cc: vincentfu@gmail.com, david@kernel.org, willy@infradead.org
References: <20260129184302.34887-1-npache@redhat.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260129184302.34887-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/29/26 11:42 AM, Nico Pache wrote:
> This series introduces a new page_fault ioengine and a follow?up option
> to make khugepaged behavior more deterministic for page fault testing.
> 
> The first patch adds an mmap?backed ioengine that allocates anonymous
> memory and copies data on read/write to intentionally trigger faults.
> This enables using fio?s existing framework and job files for memory
> management style workloads without relying on a filesystem. An example
> job file is included to demonstrate usage.
> 
> The second patch adds a hugepage_delay option to the new engine. It
> initially maps memory with MADV_NOHUGEPAGE, then (after a configurable
> delay) switches to MADV_HUGEPAGE via a helper thread. This makes
> khugepaged candidates reproducible, allows for easier khugepaged testing
> and improves repeatability for page_fault tests.

Looks pretty clean - echo what Vincent added on the option that should
be an engine specific option, but outside of that, the formatting of
the code is all wrong. Please follow the style of the code that's in the
repo already, which means:

1) Placement of braces
2) Tabs are... tabs, not 4 spaces. The code is a mix and match of this.
3) Appropriate empty lines after variable declarations
4) Style of switch case (indentation and braces)

etc. It's a good start to just use the clang format from the kernel,
that should get you basically to where you need to be.

-- 
Jens Axboe
