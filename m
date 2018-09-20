Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/4] add option to interleave blktraces
References: <20180920180810.70608-1-dennis@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <ff2f39e8-404b-c6fa-cecb-19fe42a4d4b5@kernel.dk>
Date: Thu, 20 Sep 2018 13:08:50 -0600
MIME-Version: 1.0
In-Reply-To: <20180920180810.70608-1-dennis@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Andy Newell <newella@fb.com>, fio@vger.kernel.org, kernel-team@fb.com
List-ID: <fio@vger.kernel.org>

On 9/20/18 12:08 PM, Dennis Zhou wrote:
> Hi everyone,
> 
> Updates with v2:
>  - Added documentation for all patches in fio.1 and HOWTO
>  - Added to thread_options_pack and cconv.c
>  - Bumped the FIO_SERVER_VER number accordingly

I think this looks fine to merge - one small plea, can you
add a sample job file showing how to use the various options?
Sometimes that's easier for folks to grok than reading
scattered documentation.

I'll apply these 4, thanks Dennis.

-- 
Jens Axboe


