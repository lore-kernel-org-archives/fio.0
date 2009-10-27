Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:52767 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037AbZJ0HzM (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Oct 2009 03:55:12 -0400
Date: Tue, 27 Oct 2009 08:55:16 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Patch to write patterns > 4 bytes
Message-ID: <20091027075516.GR10727@kernel.dk>
References: <66dfd3fe0910261710n62740f75y6946ebd00b2f9ab6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0910261710n62740f75y6946ebd00b2f9ab6@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Mon, Oct 26 2009, Radha Ramachandran wrote:
> Hi,
> This is the patch I have to write/read/verify hex patterns of size > 4 bytes.
> I have tested these on hard drives and did not see any performance
> change. Iam assuming the performance drop if any might show up in the
> read phase for probably solid state drives and maybe it can be worked
> around using the asynchronous verify flag.

Unfortunately, this patch is white space damaged so doesn't apply.
Perhaps send it as an attachment instead? And for extra brownie points,
updating the fio.1 man page as well would be good :-)

-- 
Jens Axboe

