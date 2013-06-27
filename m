Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:58371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3F0OQu (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 27 Jun 2013 10:16:50 -0400
Date: Thu, 27 Jun 2013 16:16:48 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Simulating bursts at different rates at irregular intervals?
Message-ID: <20130627141648.GY25599@kernel.dk>
References: <255129448.30162533.1372322165642.JavaMail.root@framestore.com>
 <803980722.30163228.1372322272381.JavaMail.root@framestore.com>
 <20130627090227.GL25599@kernel.dk>
 <CABFR9T3w9iOFZbjffxam13yKv9xUSNnV5VcwzPiyUnhB_0frfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABFR9T3w9iOFZbjffxam13yKv9xUSNnV5VcwzPiyUnhB_0frfg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <roger_sibert@xyratex.com>
Cc: FIO <fio@vger.kernel.org>

On Thu, Jun 27 2013, Roger Sibert wrote:
> Just a thought that came to mind.
> 
> To work around the problem would the following work?
> Run fio to get you max MB/s
> Write a script to generate you work/jobs file that has randomizes
> length of time for the job to run and % of max for it to run at.

That's a bit of a bother, though, since you have to collect data and
output from each individual run. And not only that, shutdown/startup
will make things less than smooth. It could potentially dirty your
results.

We could have something ala:

rate_sequence={10s:20M},{20s:5M}

or whatever, which runs 10s at 20M/sec, then 20s at 5M/sec. Repeat.
Would be fairly easy to do.

-- 
Jens Axboe

