Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48700 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab3E2Iq4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 29 May 2013 04:46:56 -0400
Date: Wed, 29 May 2013 10:46:23 +0200
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: FIO 2.1 iops logging problem
Message-ID: <20130529084623.GO22724@kernel.dk>
References: <C8CA972100601A41AE302914E9CE194680367B7E@NTXBOIMBX03.micron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8CA972100601A41AE302914E9CE194680367B7E@NTXBOIMBX03.micron.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "Jeffrey McVay (jmcvay)" <jmcvay@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On Tue, May 28 2013, Jeffrey McVay (jmcvay) wrote:
> Hi Jens,
> 
> I cannot seem to get the write_iops_log working with FIO 2.1.
> 
> I found that write_bw_log now requires write_bw_log=<text> to work.
> However that does not seem to work on the iops logging. Any idea what
> I am doing wrong?

Looks like a merge error between fio and gfio, I have fixed it up now. I
will be doing a 2.1.1 shortly, since it's not the only one that has
cropped up.

This is the patch:

http://git.kernel.dk/?p=fio.git;a=commit;h=577c83bd488cf3e92d4ccffd39659248bce8ccd3

It has been committed.

-- 
Jens Axboe

