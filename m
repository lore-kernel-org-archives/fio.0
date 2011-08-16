Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:45863 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab1HPGif (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Aug 2011 02:38:35 -0400
Message-ID: <4E4A1069.606@kernel.dk>
Date: Tue, 16 Aug 2011 08:38:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] stats: fix io_u_plat out-of-bound accesses (round 2)
References: <1313450590-22069-1-git-send-email-egouriou@google.com>
In-Reply-To: <1313450590-22069-1-git-send-email-egouriou@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Eric Gouriou <egouriou@google.com>
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, Yu-Ju Hong <yuju.hong@gmail.com>, fio@vger.kernel.org, Nauman Rafique <nauman@google.com>

On 2011-08-16 01:23, Eric Gouriou wrote:
> Commit 833491908a1afd67 introduced the ability to report completion
> latency percentiles. It also caused a memory corruption when running
> with multiple threads due to out of bound accesses in show_run_stats().
> The major index of the io_u_plat two-dimensional array is meant
> to be DDIR_ value in {DDIR_READ, DDIR_WRITE} (i.e., {0, 1}). The
> code in show_run_stats() incorrectly wrote into the array using
> a major index with values {0, 1, 2}. Commit 0a0b49007cbce8d1 fixed
> the out of bound accesses by increasing the size of the major
> dimension of the io_u_plat array from 2 to 3.
> 
> This patch reverts the size change from 0a0b49007cbce8d1 in favor
> of avoiding the out-of-bound accesses in show_run_stats().

This makes more sense, I didn't look carefully enough at this, the 3rd
index is usually for trim.

> Jens, Zhu,
> 
> Yu-Ju is unlikely to be checking fio email traffic this week,
> hence my follow-up. The error was introduced while porting
> the patch between different versions of fio. The internal version
> was tested appropriately but not the upstream version.
> 
> Apologies for the trouble.

No worries, thanks for following up on this so quickly. My group replies
bounced on Yu-Ju's email.

-- 
Jens Axboe

