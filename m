Return-Path: <axboe@kernel.dk>
Date: Tue, 19 Jul 2016 15:47:26 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/7] Fix wrong cpuio option name in documentation
Message-ID: <20160719214726.GA27019@kernel.dk>
References: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468946027-22580-1-git-send-email-kusumi.tomohiro@gmail.com>
To: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Wed, Jul 20 2016, Tomohiro Kusumi wrote:
> The name of an option for cpuio engine is "cpuchunks",
> though the code internally uses "cpucycle" for variables.
> 
> (If the option name "cpuchunks" is the incorrect one,
> I'll resubmit a patch that corrects the option name)

Thanks, applied all 7 patches.

-- 
Jens Axboe


