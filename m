Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:50995
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab2LWUtj (ORCPT
	<rfc822;fio@vger.kernel.org>); Sun, 23 Dec 2012 15:49:39 -0500
Message-ID: <50D76E61.1040608@kernel.dk>
Date: Sun, 23 Dec 2012 21:49:37 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] gettime: minimize integer division
References: <50D26157.5020802@micron.com> <50D2C8FD.2070901@kernel.dk> <50D3487E.7000402@micron.com> <50D352D7.2090901@kernel.dk> <50D365AA.9080202@micron.com> <50D48139.30601@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A93003BD3F@NTXBOIMBX02.micron.com> <50D4D4F9.5070606@kernel.dk> <80B89753B40C5141A3E2D53FE7A2A8A93003BE0D@NTXBOIMBX02.micron.com>
In-Reply-To: <80B89753B40C5141A3E2D53FE7A2A8A93003BE0D@NTXBOIMBX02.micron.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2012-12-21 22:53, Sam Bradshaw (sbradshaw) wrote:
> 
>>> IOPs look the same in my synthetic test but I'm not sure that's relevant;
>>> (it probably just needs some more tweaking).
>>
>> It'd probably need 3-4M IOPS from a single thread to have a big impact.
>> But reduced CPU is leftover CPU for doing actual IO, so always a good
>> thing.
>>
>> And just as important, did the timing look correct?
> 
> Yes, no spikes, latency average and std. dev. as expected.

Excellent, now committed...

-- 
Jens Axboe

