Return-Path: <axboe@kernel.dk>
Message-ID: <5535A4CF.1040501@kernel.dk>
Date: Mon, 20 Apr 2015 19:15:59 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH] Don't export state variable
References: <1429572030-6287-1-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429572030-6287-1-git-send-email-dehrenberg@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Dan Ehrenberg <dehrenberg@chromium.org>, fio@vger.kernel.org
Cc: gwendal@chromium.org
List-ID: <fio@vger.kernel.org>

On 04/20/2015 05:20 PM, Dan Ehrenberg wrote:
> There was no reason to export this extra variable. It was just a typo
> and it is never used.

Thanks, applied.

-- 
Jens Axboe


