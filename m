Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:44998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DKUDj (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 11 Apr 2012 16:03:39 -0400
Message-ID: <4F85E399.3030603@kernel.dk>
Date: Wed, 11 Apr 2012 22:03:37 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: query on verify_dump option
References: <CAN8qX8YZoZ2TtcqU0QOTEguHoqsYQRuMoFvRsT3JTJc9Uba19w@mail.gmail.com> <4F7E35F2.5010701@kernel.dk> <CAN8qX8ZnCCZz3cBbhocdTwXgBqsL=JV=QYFD_OSj4nmEFVUZMQ@mail.gmail.com>
In-Reply-To: <CAN8qX8ZnCCZz3cBbhocdTwXgBqsL=JV=QYFD_OSj4nmEFVUZMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 2012-04-06 02:28, Suresh Dhanarajan wrote:
> Hi,
> 
> I am looking for this files in the same location where my fio is and i
> dont see the two files that you refereed.

Hmm, you really should, if you have verify_dump=1 set. The pattern
verify is the odd one out, all the other checksum verifiers use shared
code for this. I'll take a look at this and see if I can reproduce it.

> We have option to give pattern during verify only.
> What i mentioned is during Write and reads there is no option to
> provide the patterns.

Ahh, good point. You could just set do_verify=0 for a write workload,
where you define verify_pattern and verify=meta. That should write with
just that pattern. Does that help?

Not sure what you mean for the reads...

-- 
Jens Axboe

