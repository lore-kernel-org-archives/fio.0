Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:33259 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbZKDRlS (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2009 12:41:18 -0500
Date: Wed, 4 Nov 2009 18:41:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091104174123.GG8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com> <20091104073525.GQ8742@kernel.dk> <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com> <20091104172932.GD8742@kernel.dk> <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 04 2009, Radha Ramachandran wrote:
> I would rather document it than add it by default in case it starts
> hitting memory constraints because its allocating more memory buffers.

Yes I agree, I usually don't like having one option implying changes for
another either.

> Also Iam having difficulty running verify_async/libaio engine/iodepth
> and iodepth_batch_complete options together, I will look into it to
> see whats causing the issue.

OK, I saw some issues on what appears to be races on io_u->flags today,
but I haven't investigated that yet.

-- 
Jens Axboe

