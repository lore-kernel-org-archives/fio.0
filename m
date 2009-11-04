Return-Path: <fio-owner@vger.kernel.org>
Received: from [95.166.99.235] ([95.166.99.235]:47121 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757979AbZKDTWZ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 4 Nov 2009 14:22:25 -0500
Date: Wed, 4 Nov 2009 20:22:30 +0100
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Add extra_buff_count flag
Message-ID: <20091104192230.GI8742@kernel.dk>
References: <66dfd3fe0911031633s5bef0621g99b4164c2dd174d9@mail.gmail.com> <20091104073525.GQ8742@kernel.dk> <66dfd3fe0911040912s377b8b0eqb81fa3cad3db2d2f@mail.gmail.com> <20091104172932.GD8742@kernel.dk> <66dfd3fe0911040939w7629a514l393e3a6360430b54@mail.gmail.com> <20091104174123.GG8742@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104174123.GG8742@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Radha Ramachandran <radha@google.com>
Cc: fio@vger.kernel.org

On Wed, Nov 04 2009, Jens Axboe wrote:
> On Wed, Nov 04 2009, Radha Ramachandran wrote:
> > I would rather document it than add it by default in case it starts
> > hitting memory constraints because its allocating more memory buffers.
> 
> Yes I agree, I usually don't like having one option implying changes for
> another either.

So the problem with documentation is that usually nobody reads it. This
is what the HOWTO/man page currently has:

verify_async=int        Fio will normally verify IO inline from the submitting
                thread. This option takes an integer describing how many
                async offload threads to create for IO verification instead,
                causing fio to offload the duty of verifying IO contents
                to one or more separate threads. If using this offload
                option, even sync IO engines can benefit from using an
                iodepth setting higher than 1, as it allows them to have
                IO in flight while verifies are running.

It's already documented...

-- 
Jens Axboe

