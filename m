Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([74.50.51.35]:36677 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdLAU5c (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Dec 2017 15:57:32 -0500
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0 (1.0)
Subject: Re: memcpy test
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <aba29420-0049-5537-7efe-c6f5f7093b4f@kernel.dk>
Date: Fri, 1 Dec 2017 13:57:30 -0700
Content-Transfer-Encoding: 8bit
Message-Id: <5020B706-1B8E-4617-93C7-4B424BADA35C@bluestop.org>
References: <0aa59e33-54d4-cd80-350a-0f13bfa74a98@kernel.dk> <AT5PR8401MB038721B93CF3CF3DE4361A7AAB390@AT5PR8401MB0387.NAMPRD84.PROD.OUTLOOK.COM> <aba29420-0049-5537-7efe-c6f5f7093b4f@kernel.dk>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Robert Elliott (Persistent Memory)" <elliott@hpe.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>, Sitsofe Wheeler <sitsofe@gmail.com>


> On Dec 1, 2017, at 1:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> 
> My goal would be to find if there's something simple we can do to provide
> a fairly optimized version we can use for larger copies, which is
> essentially just for mmap and libpmem/dev-dax and friends. 

Would you be looking for code that makes the decision at runtime (using cpuid to see which of SSE, AVX, AVX512F it supports) or having it be a compile-time thing?

— 
Rebecca
