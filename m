Return-Path: <mwilck@suse.com>
Message-ID: <e77432c52e52eb57fddb5259ab5acdb00b93a21d.camel@suse.com>
Subject: Re: Assertion `t->bytes' failed in blktrace replay
From: Martin Wilck <mwilck@suse.com>
Date: Thu, 05 Jul 2018 22:10:00 +0200
In-Reply-To: <d4fe481d-8c6e-b618-2cff-bc01af265a4d@kernel.dk>
References: <c799b578ed44ed560c36ec7ef1a93b8076e6cc64.camel@suse.com>
	 <d4fe481d-8c6e-b618-2cff-bc01af265a4d@kernel.dk>
Content-Type: text/plain; charset="utf-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, 2018-07-04 at 15:00 -0600, Jens Axboe wrote:
> 
> Should not, I do wonder what that those zero byte traces are? I've
> committed a fix that just logs a warning (once) for them, so -git
> should work fine for you.
> 
I'll try.

> Can you share the trace?

https://www.dropbox.com/s/nrdg5xxiq9o9gl0/trace.tar.xz?dl=0

(click on the "download" button)

Regards,
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)


