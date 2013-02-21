Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44027 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3BUIkR (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 21 Feb 2013 03:40:17 -0500
Date: Thu, 21 Feb 2013 09:38:43 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Random vs Sequential Read in FIO
Message-ID: <20130221083843.GD25617@kernel.dk>
References: <CACTzACVBXK7nKXHCaaOxSE=2YN+WKjaDPtQqZkfgL1jNyVhxLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACTzACVBXK7nKXHCaaOxSE=2YN+WKjaDPtQqZkfgL1jNyVhxLg@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: David N <android.wm.edu@gmail.com>
Cc: fio@vger.kernel.org

On Thu, Feb 21 2013, David N wrote:
> Hi,
> 
> I was using FIO to get response time of random reads and sequential
> reads from phone's flash memory and I got like 9x greater response
> time for random read. Since there is no seek time as in conventional
> rotating storage, I'm wondering where this huge jump of random IO
> response time comes from? How is the total IO delay actually
> calculated in FIO?

One option is that your sequential reads are coalesced and issued as one
command, whereas random flash reads will still trigger a tread and
tstream pause for each one. You need to look at device stats with the
workload to see what the ratio between fio-request:device-request is.

-- 
Jens Axboe

