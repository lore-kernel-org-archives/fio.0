Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:51362 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbZD0GD5 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 27 Apr 2009 02:03:57 -0400
Date: Mon, 27 Apr 2009 08:03:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: What's the right way to measure latency?
Message-ID: <20090427060356.GV4593@kernel.dk>
References: <f3177b9e0904260644v578c4eb9m35c64ccf7b883479@mail.gmail.com> <530FE590-63A6-4EEE-81EF-1BE87EC6A707@omner.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530FE590-63A6-4EEE-81EF-1BE87EC6A707@omner.org>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Joshua Aune <luken@omner.org>
Cc: Chris Worley <worleys@gmail.com>, fio@vger.kernel.org

On Sun, Apr 26 2009, Joshua Aune wrote:
>
> On Apr 26, 2009, at 7:44 AM, Chris Worley wrote:
>
>> The results show two latency numbers: clat and slat... what are these?
>
> slat is not there for the sync engines but exists for libaio, submit  
> latency.  clat sounds like completion latency.

It's in the HOWTO :-)

Basically slat is the time it too to enter the kernel and submit the IO
(submission latency) and clat is the time it took from submission to the
IO completed (completion latency). With the sync engines you cannot
separate the two, since when the submission syscall completes the IO has
also completed. Hence they have only clat numbers, where the async
engine has the ability to measure both.

-- 
Jens Axboe

