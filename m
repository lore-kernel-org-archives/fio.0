Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:46250 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750826AbZKDHfV (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2009 02:35:21 -0500
Date: Wed, 4 Nov 2009 08:35:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091104073525.GQ8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Tue, Nov 03 2009, Radha Ramachandran wrote:
> Hi,
> I was trying to use the async_verify option. Looks like if we use this
> option for synchronous I/O, then it really doesnt do anything as after
> every I/O is completed, we still need the asynchronous verify thread
> to complete the verification and release the io_u so the main thread
> can allocate this io_u for the next I/O. So to remove this bottle neck
> I added a new option extra_buff_count. This takes an integer and the
> code will allocate that many more extra io_us. This way when the main
> thread has completed the I/O it will have extra io_u and buffers to
> issue more I/Os while the asynchronous verify threads do their job.
> This can be used with both synchronous and libaio contexts.

Does iodepth=x not work for that? If not, I suggest we fix that instead
of adding a new parameter for it.

-- 
Jens Axboe

