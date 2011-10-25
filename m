Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.104.106.3]:56879 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1JYUjX (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 25 Oct 2011 16:39:23 -0400
Message-ID: <4EA71E75.40108@kernel.dk>
Date: Tue, 25 Oct 2011 22:39:17 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Add code for verify_dump option
References: <CAAUT-yPmmiUVeKDXLCKzUxL8uyYHgAT_8buF3Oor_rpy7QqBaw@mail.gmail.com>
In-Reply-To: <CAAUT-yPmmiUVeKDXLCKzUxL8uyYHgAT_8buF3Oor_rpy7QqBaw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Steven Lang <tirea@google.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 2011-10-25 22:33, Steven Lang wrote:
> The verify_dump option is defined and documented, but does nothing.
> This one-liner enables the option.
> 
> One thing I wanted to open a small discussion on is the default
> behavior.  When the verify dump behavior was added, it was something
> new, so it seems more sensible to disable it by default to keep the
> old behavior; and had it been in for less time I might have been
> tempted to include that in the patch.  However, even ignoring the
> change in behavior, it seems odd and possibly surprising/unexpected to
> someone who does not have experience with fio to have it suddenly spit
> out extra files; all the other options to write files
> (write_iolog/write_bw_log/write_lat_log) only write anything if
> requested.  Is there a good argument to why this option would be
> enabled by default?

Thanks, applied. You are right, it probably should have been off by
default, and in fact probably should be even now.

-- 
Jens Axboe

