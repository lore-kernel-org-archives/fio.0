Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2JVRLY (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 22 Oct 2012 13:11:24 -0400
Message-ID: <50857E1C.9090009@kernel.dk>
Date: Mon, 22 Oct 2012 19:10:52 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] thread cpu resource statistics bug fix
References: <1350702712-5168-1-git-send-email-yufei.ren@stonybrook.edu> <1350702712-5168-3-git-send-email-yufei.ren@stonybrook.edu> <5084FDFE.20208@kernel.dk> <CAG5pYQdz1TxMDVTaBmL0iOhztRdQL9Y4jQMNinXGwqXqh_6_dQ@mail.gmail.com>
In-Reply-To: <CAG5pYQdz1TxMDVTaBmL0iOhztRdQL9Y4jQMNinXGwqXqh_6_dQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Yufei Ren <yufei.ren@stonybrook.edu>
Cc: fio@vger.kernel.org

On 2012-10-22 18:33, Yufei Ren wrote:
> Hi Jens,
> 
>>
>> I applied this, but I wonder if we should not just make this dependent
>> on
>>
>> #ifdef RUSAGE_THREAD
>> ...
>> #endif
>>
>> instead?
>>
> 
> Yes, that would more clear. Should I send you another patch instead of this?

Since it's already applied, please send one off the current -git tree
(so incremental to the previous).

-- 
Jens Axboe

