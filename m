Return-Path: <axboe@kernel.dk>
Message-ID: <552DB434.2060709@kernel.dk>
Date: Tue, 14 Apr 2015 18:43:32 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] Add new writetrim rw= mode for trims preceding writes
References: <1429052300-9822-1-git-send-email-dehrenberg@chromium.org> <1429052300-9822-3-git-send-email-dehrenberg@chromium.org>
In-Reply-To: <1429052300-9822-3-git-send-email-dehrenberg@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Dan Ehrenberg <dehrenberg@chromium.org>, fio@vger.kernel.org
Cc: gwendal@chromium.org
List-ID: <fio@vger.kernel.org>

On 04/14/2015 04:58 PM, Dan Ehrenberg wrote:
> In this new mode, sequential trims and writes are interspersed by first
> doing a trim at a particular offset, then doing writes starting from
> that offset until the start of the next trim block, then another trim,
> etc. This workload is designed to match the requirements of NAND flash,
> if trims are implemented as erases.

At first I found this a little confusing, but now I get it. It's a bit 
different to what other mixed workloads would be. Perhaps rename it to 
'trimwrite'? Also needs adding to the man page and HOWTO.

-- 
Jens Axboe


