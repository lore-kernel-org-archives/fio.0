Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab3CJTRC (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 10 Mar 2013 15:17:02 -0400
Date: Sun, 10 Mar 2013 20:16:34 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] Fix spin related bug
Message-ID: <20130310191634.GI14525@kernel.dk>
References: <1362834043-6735-1-git-send-email-apyrgio@grnet.gr>
 <1362834043-6735-2-git-send-email-apyrgio@grnet.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362834043-6735-2-git-send-email-apyrgio@grnet.gr>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: fio@vger.kernel.org

On Sat, Mar 09 2013, Alex Pyrgiotis wrote:
> On the previous patch on cycle detection, we would incremet spin value
> when:
> 
>     num_vals % cycle_length == 0
> 
> which would evaluate always to true for the first iteration since we
> start with num_vals = 0. Only one corner-case is affected by this bug
> and this patch should fix it.

Thanks Alex, applied.

-- 
Jens Axboe

