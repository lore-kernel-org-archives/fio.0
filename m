Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] set td->io_ops to NULL before dlclose()
References: <4d573b708a4f4aeda365a2947db3e09b@bowex17a.micron.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9cc3150e-9eb0-bd16-f946-9ee0c59f3574@kernel.dk>
Date: Tue, 10 Oct 2017 11:56:09 -0600
MIME-Version: 1.0
In-Reply-To: <4d573b708a4f4aeda365a2947db3e09b@bowex17a.micron.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: "Justin Eno (jeno)" <jeno@micron.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/10/2017 11:28 AM, Justin Eno (jeno) wrote:
> Hi Jens,
> 
> I'm top-posting here to catch your attention.  If it wasn't clear, the
> patch I sent is generally applicable and not intended just for the
> original reporter, i.e., it's a candidate for integration.

Looks good to me, that should close the race. Applied, thanks.

-- 
Jens Axboe


