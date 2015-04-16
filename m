Return-Path: <axboe@kernel.dk>
Message-ID: <5530395C.5090504@kernel.dk>
Date: Thu, 16 Apr 2015 16:36:12 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Fix mtd valgrind warning
References: <1429221039-31612-1-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429221039-31612-1-git-send-email-dehrenberg@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Dan Ehrenberg <dehrenberg@chromium.org>, fio@vger.kernel.org
Cc: gwendal@chromium.org
List-ID: <fio@vger.kernel.org>

On 04/16/2015 03:50 PM, Dan Ehrenberg wrote:
> strlen seems to operate in 32-bit chunks, but libmtd sometimes allocates
> strings without that much padding. This patch adds something extra to
> a string allocation so that the mtd ioengine is clean with respect
> to valgrind memory access checks.

Thanks, pretty nasty, but after all a small price to pay to get valgrind 
to shut up...

-- 
Jens Axboe


