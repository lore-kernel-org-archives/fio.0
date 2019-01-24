Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] rate-submit: call ioengine post_init when starting
 workers
References: <20190124192642.18727-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <2e2b4fcc-fbdd-6ef5-2115-925d4a8b59dd@kernel.dk>
Date: Thu, 24 Jan 2019 13:57:51 -0700
MIME-Version: 1.0
In-Reply-To: <20190124192642.18727-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 1/24/19 12:26 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> ioengines with post_init steps were not fully fully initialized by
> offload worker threads because the post_init function was never called.
> 
> Without this patch all libaio operations submitted in offload mode fail
> because the ioengine was not fully initialized.

Thanks Vincent, applied.

-- 
Jens Axboe


