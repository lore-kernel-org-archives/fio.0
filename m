Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408C21386DA
	for <fio@vger.kernel.org>; Thu, 24 Apr 2025 05:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745473212; cv=none; b=EY9p4QZjh2ryz9kN5fd/4ECaHyYJy0Xq4ET5b28/K5CsiO5AXHs2WkMcOQibIeOA43aeQaqEc9hiN0xe6C8AldoMTqJv60Y5OA7sQv3B2Mge124CyZ9keHR+cB+CVBp2nzAQygmvCNuFJdEfL2Qy7WRXCH0+w2csOCFX7TnRVFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745473212; c=relaxed/simple;
	bh=hx6JUeq3i7MQz7jjSBcY3loYykvWU91PqTx04DUZWnM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NQm+78bnBq4wcTzzQMSeTN0p0du24HSrNla1s93L8O+eFkU7JFrFEIGECg7PYyyrAt3GIBStxVR34XcwQJXIV4X4k5iDi7Jl3A3JQ//H3td1+js55/spXa90A1qcbPlH6VdkwvFAgBcXW38uyxrqfJDZHV8cuuAXZTym7CIL2lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VIl2kV49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VIl2kV49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DEAC4CEE3;
	Thu, 24 Apr 2025 05:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745473211;
	bh=hx6JUeq3i7MQz7jjSBcY3loYykvWU91PqTx04DUZWnM=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=VIl2kV49dg7jiLDdh2BOSV4Ni8gVM6cszRZUxdiyMIY4SGuado0Sn5FnrFeB0G7GC
	 m27GpBwFOnlhGC7vDmcTJVwho/z6YfvcKCqn5hrxTObBQL+Fz/aUPYRGnI3ozIwz9j
	 nABD4kloYjKhMtp9Grd+aUC5ox2SrY23uRKCZWv6tur1XTNAaWildwsgWKD5cS4xkN
	 L4tQuz/Zuxw67NwcXCpjhHZmQ6tqQLWoFOC4BNuwNeB1TNlo+0YZFyE1ONiZDwmEbD
	 BydueWJmaDkM0trb/xINLlZ8PMdwnc0vYfGIjp13nFeQ/LxO+6TK4Zt8rbKC0hqJB8
	 Y46fs6/zZQZJg==
Message-ID: <9483165f-c834-4272-9949-59e93659551b@kernel.org>
Date: Thu, 24 Apr 2025 14:40:10 +0900
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] active zones exceeded error with max_open_zones
To: Sean Anderson <seanga2@gmail.com>,
 Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
References: <2b55d2f4-a093-d944-3d36-6efb5fb271ef@gmail.com>
 <2a232db8-280a-4a76-aade-916499fd524d@kernel.org>
 <949cb711-b20b-6bb5-6663-e12ca7d71cf2@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <949cb711-b20b-6bb5-6663-e12ca7d71cf2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/24/25 14:27, Sean Anderson wrote:
> On 4/23/25 23:10, Damien Le Moal wrote:
>> On 4/24/25 02:11, Sean Anderson wrote:
>>> Hi,
>>>
>>> I'm getting an "active zones exceeded" error when running fio with
>>> --rw=randwrite mode:
>>>
>>> # fio --bs=4k --rw=randwrite --norandommap --fsync=1 --number_ios=16384 --name=flushes --direct=1 --zonemode=zbd --max_open_zones=1978 --filename=/dev/my_zone_dev
>>
>> --max_open_zones=1978 is an extremely large value that likely exceeds the drive
>> capabilities, which is what fio is telling you.
>> What are your drive maximum open and active zones limits ?
>>
>> cat /sys/block/my_zone_dev/queue/max_open_zones
>> cat /sys/block/my_zone_dev/queue/max_active_zones
> 
> This is correct for the drive.

I am sure it is. My point is that you cannot use --max_open_zone fio option with
a value larger than what these sysfs attribute values are.

>> fio will use the min_not_zero of these 2 values as the maximum number of zones
>> that can be written simultaneously. Especially if your drive has an active zone
>> limit, you *cannot* write to more zones than that limit at the same time.
>> fio will default to max_open_zones=min_not_zero(drive max open, drive max
>> active) and for a random write workload, it will:
>> - pick zones randomly up to max_open_zones
>> - direct write IOs to a randomly chosen zone in the current set of open zones
>> and when an open zone becomes full, randomly pick another zone to replace it.
> 
> Well the issue is that it appears to just pick random zones, not random open zones.

The drive may be completely empty, all zones empty, so no open zones to chose
from. So fio picks a random zone and adds it to the set of open zones it tracks.
It will repeat that until the set of open zones reaches the limit, at which
point, fio has no choice but to keep writting these open zones until they are full.

If the drive already has open zone in the fio workload range, these zones will
be added to the set of open zones on fio start.

>> For your workload, if you want to measure the maximum "random" write performance
>> of your disk, simply do NOT specify --max_open_zones=. fio will pick the best
>> possible number for you.
> 
> Same issue.

Are you specifying an offset+size range ? If yes, how many zones are open in
that range and outside of it ?

What drive is it ? Looking at the blkzone report you sent, the zones look
ridiculously small (32 sectors...)... Is this a null_blk device ?
If that is the case, try creating the drive with larger zones. You may be
hitting a bug with such tiny zones. Since such drive do not exist in the field,
we never really tested such extreme configuration.

-- 
Damien Le Moal
Western Digital Research
