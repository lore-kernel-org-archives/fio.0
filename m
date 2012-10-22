Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48787 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JVIHY (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 04:07:24 -0400
Message-ID: <5084FEB9.7060805@kernel.dk>
Date: Mon, 22 Oct 2012 10:07:21 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] Fine-grained job level numa control
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu> <1350702712-5168-5-git-send-email-yufei.ren@stonybrook.edu>
In-Reply-To: <1350702712-5168-5-git-send-email-yufei.ren@stonybrook.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org, Yufei Ren <renyufei83@gmail.com>

On 2012-10-20 05:11, Yufei Ren wrote:
> From: Yufei Ren <renyufei83@gmail.com>
> 
> Two new options, numa_cpu_nodes and numa_mem_policy, are created
> for a fine-grained job level numa control. Please refer HOWTO and
> README for detailed description.
> A example job, examples/numa, is added as well.

Good addition, added! It provides separate control of the job and memory
allocation policies.

-- 
Jens Axboe

