Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:33331 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab2CQMTc (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 17 Mar 2012 08:19:32 -0400
Message-ID: <4F648150.7000705@kernel.dk>
Date: Sat, 17 Mar 2012 13:19:28 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Parsing FIO output
References: <4F63BA21.1090600@gmail.com>
In-Reply-To: <4F63BA21.1090600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hoppetauet <hoppetauet@gmail.com>
Cc: fio@vger.kernel.org

On 2012-03-16 23:09, Hoppetauet wrote:
> Hello!
> 
> I'm in the process of benchmarking a cloud, and have written scripts 
> that capture FIO output from X runs (using the --minimal option).
> 
> I run 4 different tests, for seq read/write and random read/write. I've 
> found that the write output is in field $25 and the read output is in 
> $6, but I'm struggling with min, max and stddev of the latency (clat). 
> Also, I've read that it changes from usec to msec where it's convenient. 
> Any tips as to getting out the values in msec always?

The format is actually described. See the HOWTO included with fio,
section 7.0, terse output. The minimal format output _always_ includes
latencies in both msec and usec ranges. So if you just want the msec
ranges, you only look at those fields.

But I'd recommend looking at the HOWTO. The actual output is from
stat.c:show_thread_status_terse_v3(), so you can verify by looking at
the actual output code as well.

-- 
Jens Axboe

