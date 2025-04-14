Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E97C13D
	for <fio@vger.kernel.org>; Mon, 14 Apr 2025 09:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744622666; cv=none; b=rLRg40zcX1UJ7GCaVGeqHPrQOGiqtKbp7ayiEKCYLxhUmPBO7pZpByk8k7pA51u0qC8RZQIjTzexJsXo9IK1B5MgdPmWT+GKJbom9rkubqm4pRJZC9OPAe7r+btWNT5Yg+KU/L9dZt1AX4L8/dVDOiHMQ+6A0IHN3SG8Ibs5kgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744622666; c=relaxed/simple;
	bh=iu+M3ybL4CTZ1gImv+fFks4TgBANHoYsWlwTZdTDnp0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eDSSDNBdVXejh/+iNolqFozDn98xtgiSikvqB3QLqJDWjyra5i+Fk9cEuPZ3SRIjieRcD3TGK0zGAFMAEdKoxd7VxJpvwzu1plrec/CqvLXRF6mOGekLZ7XRAKzgdj+YVe402SIMhsGGJFXGaIZT19OwtZgJTmpe+tVWda5t2vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJCpbCGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJCpbCGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD04EC4CEE5;
	Mon, 14 Apr 2025 09:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744622666;
	bh=iu+M3ybL4CTZ1gImv+fFks4TgBANHoYsWlwTZdTDnp0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=OJCpbCGWl0TKnOkbYRTuhC5/3E4EMoVP4vs1paOzbOFEp8wNmbffGBLXiv1GhzY58
	 sPQQBAtZ+AfJP4G4KT+W09z7yhnWOZ37bF2IB9YJulLVl6TBcSrBlpPymH9lr51Na6
	 yhB0Xd1Vsu2/psMvRpzRizScz7V50ycgkRDqi1e671r1yUbadGI1XXWeL3s/6Ei16n
	 HNI5V5UH5KiIqIW+2gZ2FXw3dYmGAWwalEOaDURY3T1azO4LniJKPeqOjnrVe753uI
	 IaRHx+2aQAxtsS0SjVJeGEUtQPbYSagW53ruvvu+xIk5h8o0TAliOrGSZQqhycq6hx
	 j+LeWGHc2QPMA==
Message-ID: <faad816b-3683-43e6-a700-65eba76d9a0d@kernel.org>
Date: Mon, 14 Apr 2025 18:23:38 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Performance variation in traditional HDDs?
To: Nick Neumann <nick@pcpartpicker.com>, fio@vger.kernel.org
References: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <CADqNVTpRsQXDsW034A8SWeWEbpsAUcidWiKgpj+Xm74NYNPjQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/10/25 3:41 AM, Nick Neumann wrote:
> We recently benchmarked some identical HDDs (same part number,
> purchase date, and firmware) with fio and were surprised by speed
> differences between them. Intrigued, we bought a few more sets of
> identical drives and benchmarked them. It makes sense that there would
> be some variation - after all, these are rotating platters and
> physical rotation speed may vary a bit.

Very unlikely. You are talking about some very precise control in the drive here.

> All sets of identical drives showed some variation, with some showing
> significantly more than others. Note that when the exact same drive is
> rebenched, it generally shows the same results. So different instances
> of the same drive really do perform differently.
> 
> For example, we benched 6 of the same 2TB 7200 RPM drive and did a
> full drive write with fio. The slowest drive averaged 158MB/s over the
> run. The fastest averaged 174MB/s. And the average of all drives was
> 169MB/s.
> 
> I was wondering if anyone had pointers/thoughts on what kind of
> variation should be expected in performance with HDDs, or
> articles/research about this behavior?

Did you mount all drives exactly the same way ? Do the HDD mounts you use have
proper vibration dampening ?

Generally, HDD performance variations come from different vibration
characteristics, due to external factors, including noise.
E.g. a drive in an enclosure that is close to a fan may not perform as well as
another drive that is mounted further away from the fan.

Given the differences you are showing, I would say that it is likely that you
have HDD mounting problems. Of course, testing with the drive resting on a
table with no mounting is a non-starter...

Another thing: what fio command line did you use ? If you did not use direct
IOs at high queue depth, you can have problems getting the maximum speed.
Generally, something like this is good:

fio --name=test --filename=/dev/sdX --ioengine=libaio --iodepth=32 \
	--rw=read --direct=1 --bs=1M

-- 
Damien Le Moal
Western Digital Research
