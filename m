Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2IZKvc (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 26 Sep 2012 06:51:32 -0400
Message-ID: <5062DE13.2060407@kernel.dk>
Date: Wed, 26 Sep 2012 12:50:59 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] netbsd: fix gettid
References: <1348650803-92011-1-git-send-email-roger.pau@citrix.com> <5062DC48.2000704@kernel.dk> <5062DDB2.4010605@citrix.com>
In-Reply-To: <5062DDB2.4010605@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Roger Pau Monne <roger.pau@citrix.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 09/26/2012 12:49 PM, Roger Pau Monne wrote:
> Jens Axboe wrote:
>> On 09/26/2012 11:13 AM, Roger Pau Monne wrote:
>>> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
>>
>> Thanks Roger. I'm assuming you are using fio on NetBSD so I can consider
>> this tested? It's applied.
> 
> Yes, at least it compiles now, and it works to some degree, but I will
> probably send more patches to fix remaining bits.

Thanks, that would be great. It's hard for me to get good testing on the
more esoteric platforms, so any help there is greatly appreciated.

-- 
Jens Axboe

