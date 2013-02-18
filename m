Return-Path: <fio-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60067
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751677Ab3BRIJz (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 18 Feb 2013 03:09:55 -0500
Date: Mon, 18 Feb 2013 09:08:29 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: How to get IOPS when using terse output
Message-ID: <20130218080829.GC6003@kernel.dk>
References: <511B6E9C.3000903@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511B6E9C.3000903@gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Peter Xu <xzpeter@gmail.com>
Cc: fio@vger.kernel.org

On Wed, Feb 13 2013, Peter Xu wrote:
> Hi, all,
> 
> I failed to find IOPS results for read/write under terse mode (with
> --minimal param when invoking fio program), while IOPS does exist in normal
> output without --minimal param.
> 
> It seems that I even cannot calculate it out only with the tersed output
> (since I don't know the total number of IO). Then, how should I get IOPS
> results when using terse output?

As Carl mentions, the IOPS are there. But let me make a suggestion to
move over to the json format instead. It's easy to parse by computers
and humans, and new performance metrics can be added without causing
breakage in existing setups. The minimal/csv format is somewhat fragile
for that.

That said, IOPS is there in the minimal output :-)

-- 
Jens Axboe

