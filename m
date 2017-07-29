Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Add option to keep memory-mapped files
References: <1501297391-1880-1-git-send-email-sbates@raithlin.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <84a61eec-ee6a-ce75-2ca5-75297d2b2517@kernel.dk>
Date: Sat, 29 Jul 2017 15:34:51 -0600
MIME-Version: 1.0
In-Reply-To: <1501297391-1880-1-git-send-email-sbates@raithlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: sbates@raithlin.com, fio@vger.kernel.org
Cc: logang@deltatee.com
List-ID: <fio@vger.kernel.org>

On 07/28/2017 09:03 PM, sbates@raithlin.com wrote:
> From: Stephen Bates <sbates@raithlin.com>
> 
> By default file backed memory mappings are unlink()'ed after use. This
> flag allows us to optionally keep them around.
> 
> Discovered this when doing p2pmem testing and fio kept deleting the
> /dev/p2pmem0 files...

Instead of adding an option, why not only delete the file if fio
created it? That would make it work like people expect, without
requiring an option to do so.

-- 
Jens Axboe


