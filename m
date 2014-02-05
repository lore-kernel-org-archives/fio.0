Return-Path: <axboe@kernel.dk>
Date: Wed, 5 Feb 2014 10:11:15 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] init: option parsing fixes
Message-ID: <20140205171115.GE27534@kernel.dk>
References: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391520431-21732-1-git-send-email-stefanha@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Tue, Feb 04 2014, Stefan Hajnoczi wrote:
> Patch 1 changes --minimal from optional_argument to no_argument.  There seems
> to be no reason why optional_argument was used (the option doesn't use optarg).
> 
> Patch 2 fixes a segfault when --output-format is used without an argument.
> 
> Stefan Hajnoczi (2):
>   init: --minimal does not take an optional argument
>   init: log error on missing --output-format argument
> 
>  init.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Thanks, applied both!

-- 
Jens Axboe


