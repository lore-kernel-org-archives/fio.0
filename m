Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:55332 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZKEHcN (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 5 Nov 2009 02:32:13 -0500
Date: Thu, 5 Nov 2009 08:32:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091105073217.GT8742@kernel.dk>
References: <20091104073525.GQ8742@kernel.dk> <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com> <20091104172932.GD8742@kernel.dk> <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com> <20091104174123.GG8742@kernel.dk> <20091104192230.GI8742@kernel.dk> <66dfd3fe0911041131qcd032dem89f3cdfada112989@mail.gmail.com> <20091104193622.GJ8742@kernel.dk> <20091104200158.GK8742@kernel.dk> <66dfd3fe0911041450k7935aaa5ia4cf253f6d4d066@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911041450k7935aaa5ia4cf253f6d4d066@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 04 2009, Radha Ramachandran wrote:
> Hi,
> This is the patch to fix the race condition when
> iodepth_batch_complete and verify_async are used. The fix prevents the
> code from waiting for more I/Os than were actually submitted.

Ah thanks. So it wasn't quite a race, just a bug. I will apply it asap.

-- 
Jens Axboe

