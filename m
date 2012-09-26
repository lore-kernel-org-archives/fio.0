Return-Path: <roger.pau@citrix.com>
Message-ID: <5062DDB2.4010605@citrix.com>
Date: Wed, 26 Sep 2012 11:49:22 +0100
From: Roger Pau Monne <roger.pau@citrix.com>
MIME-Version: 1.0
Subject: Re: [PATCH] netbsd: fix gettid
References: <1348650803-92011-1-git-send-email-roger.pau@citrix.com> <5062DC48.2000704@kernel.dk>
In-Reply-To: <5062DC48.2000704@kernel.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens Axboe wrote:
> On 09/26/2012 11:13 AM, Roger Pau Monne wrote:
>> Signed-off-by: Roger Pau Monne <roger.pau@citrix.com>
> 
> Thanks Roger. I'm assuming you are using fio on NetBSD so I can consider
> this tested? It's applied.

Yes, at least it compiles now, and it works to some degree, but I will
probably send more patches to fix remaining bits.

Thanks.


