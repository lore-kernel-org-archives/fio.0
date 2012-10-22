Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48746 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2JVIEM (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 04:04:12 -0400
Message-ID: <5084FDD7.6000200@kernel.dk>
Date: Mon, 22 Oct 2012 10:03:35 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] cpuio engine cpuload bug fix
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu> <1350702712-5168-2-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-2-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-20 05:11, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>
> 
> Current cpu ioengine always bruns out 100 percent cpu cycles
> no matter what the cpuload value is. Since no data is transferred
> with cpuio, bytes_done would be ZERO. Consequently, think_time
> is omitted and loops keeps running.
> 
> A cpuio example is added as well.

Applied, thanks!

-- 
Jens Axboe

