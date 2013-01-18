Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:44555 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3ARUk7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 18 Jan 2013 15:40:59 -0500
Date: Fri, 18 Jan 2013 21:40:40 +0100
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fio is being killed by the oom-killer after fio verify runs for
 some time ~13 hours
Message-ID: <20130118204040.GT3571@kernel.dk>
References: <CABYizFKetDGfE_fOARgbehmJo_uDTqy32bMTQTDVyny-Nk5riQ@mail.gmail.com>
 <20130111091010.GA32674@kernel.dk>
 <50F12401.8090606@kernel.dk>
 <CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABYizFLj4LSJApybuRfUfCiuqhVNac0T733BcMnpUOAivWhi7A@mail.gmail.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: brian arb <brianjamesarb@gmail.com>
Cc: fio@vger.kernel.org

On Fri, Jan 18 2013, brian arb wrote:
> adding the option --verify_backlog=1024 resolved my issue.
> On a side note how would one determine what the optimum number is for this
> option?

It's easier if you know the internals... The version you are running
will store some metadata for each block written, for verification
purposes. Standard install is 80 bytes per block. So if you have a 2TB
disk and use 4K IO sizes, the memory required runs into the gigabytes.
Quite unfortunate, really, will be fixed up shortly.

In any case, with a backlog of just 1024, you wont use more than 80KB
memory for verifies. So you could easily size it larger. I'd improve the
option documentation, but I think it's better to just improve fio to not
require the stored meta data to be able to verify. It will be in the
2.0.14 release.

-- 
Jens Axboe

