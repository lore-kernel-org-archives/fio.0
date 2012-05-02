Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:50760 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2EBMAd (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 May 2012 08:00:33 -0400
Message-ID: <4FA121C5.8090002@kernel.dk>
Date: Wed, 02 May 2012 14:00:05 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: rwmixcycle - deprecated?
References: <0FEAAA2D70C89D49A62173478A6C4A5D02DED1C8@XYUS-EX22.xyus.xyratex.com>
In-Reply-To: <0FEAAA2D70C89D49A62173478A6C4A5D02DED1C8@XYUS-EX22.xyus.xyratex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Sibert <Roger_Sibert@xyratex.com>
Cc: fio@vger.kernel.org

On 05/01/2012 04:42 PM, Roger Sibert wrote:
> Hello Everyone,
> 
> Just a sanity check with a twist of question, snippet from log file.
> 
> Option rwmixcycle is deprecated
> test-1: (g=0): rw=randrw, bs=1M-1M/1M-1M, ioengine=libaio, iodepth=32
> 2.0.7
> Starting 1 process
> 
> Just how deprecated is rwmixcycle and if it's truly gone do we need to
> update the man page to reflect that fact?
> 
> The question with if its deprecated what is the value it's using, I'm
> guessing the default that's listed.

Yes, it's totally deprecated, it has no effect. I've killed it from the
man page, thanks for letting me know.

-- 
Jens Axboe

