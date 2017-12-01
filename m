Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:39589 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdLAS4N (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Dec 2017 13:56:13 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (1.0)
Subject: Re: memcpy test
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
Date: Fri, 1 Dec 2017 11:56:11 -0700
Content-Transfer-Encoding: 8bit
Message-Id: <D2BFED30-2140-4453-9B7A-9D9EBA8C63E8@bluestop.org>
References: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>, Robert Elliott <elliott@hpe.com>


> On Dec 1, 2017, at 11:20 AM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> which is kind of depressing, since the fastest for larger sizes is the
> very dumb and basic implementation that you'll find in any text book
> under the section of "my first memcpy".
> 
> Anyway, for evaluating implementations, we need a way to test them,
> and now we have. I'll be happy to take input/patches on the test
> itself.

Thanks - I meant to reply a few days ago and tell you I will work on a patch for this. 

For the simple case, does the compiler do anything interesting? For example, auto-vectorization should be simple for it to do if it knows the capabilities of the target machine.

— 
Rebecca
