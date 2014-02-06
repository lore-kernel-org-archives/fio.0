Return-Path: <axboe@kernel.dk>
Date: Thu, 6 Feb 2014 12:17:06 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Rip out verify_backlog support?
Message-ID: <20140206191706.GA3950@kernel.dk>
References: <CANEJEGuqYiSQnyw2bVNFa3CKqmZK6+-3y5dDT4h3iccU-n0cAA@mail.gmail.com>
 <20140205193214.GI27534@kernel.dk>
 <CANEJEGs-KdsMC3fE3SvOUkkbJESXXvUHwRVq5OjWTfKyf-ooEA@mail.gmail.com>
 <20140205195317.GK27534@kernel.dk>
 <CANEJEGsqwKQssFqZPEycWR-ccqcVjWGQA=EtLtDsdxg5D1-c_g@mail.gmail.com>
 <20140205212812.GC20626@kernel.dk>
 <CANEJEGt5neHeCc-wnDDyFWY7S_AyxzKjaOj09DXR08oRjF+Dow@mail.gmail.com>
 <20140205223052.GF20626@kernel.dk>
 <20140206033437.GA25141@kernel.dk>
 <CANCcNXfkC3pTVTKp3irQDovASV1rwC7oeakboGre7ZmMV9MtxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANCcNXfkC3pTVTKp3irQDovASV1rwC7oeakboGre7ZmMV9MtxQ@mail.gmail.com>
To: Puthikorn Voravootivat <puthik@google.com>
Cc: Grant Grundler <grundler@chromium.org>, FIO_list <fio@vger.kernel.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

On Thu, Feb 06 2014, Puthikorn Voravootivat wrote:
> That fix runs fine with my test script (attached), but I think you
> might want to remove or reword this comment.

I already did in my local one, you just got the first cut yesterday.
Reads like this now:

/*
 * Always log IO before it's issued, so we know the specific
 * order of it. The logged unit will track when the IO has
 * completed
 */

Thanks for testing it, will go in now...

-- 
Jens Axboe


