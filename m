Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] add FIO_FILENOHASH ioengine flag
References: <1507581062-27315-1-git-send-email-josef@toxicpanda.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <8624c54e-71cf-7670-b627-82d4e922db8d@kernel.dk>
Date: Mon, 9 Oct 2017 14:32:54 -0600
MIME-Version: 1.0
In-Reply-To: <1507581062-27315-1-git-send-email-josef@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Josef Bacik <josef@toxicpanda.com>, fio@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
List-ID: <fio@vger.kernel.org>

On 10/09/2017 02:31 PM, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> filecreate doesn't use the file hash table, so don't bother doing shared
> memory allocations for the file objects, ye olde malloc will work just
> fine.  This way we can create millions of files without jacking up
> --alloc-size.

Thanks, applied.

-- 
Jens Axboe


