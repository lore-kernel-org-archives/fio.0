Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] configure: fix check_min_lib_version() eval
References: <20210506162331.1026601-1-stefanha@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <84fb7ec8-0cab-f88e-eb6a-0615210756fe@kernel.dk>
Date: Thu, 6 May 2021 10:25:09 -0600
MIME-Version: 1.0
In-Reply-To: <20210506162331.1026601-1-stefanha@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Stefan Hajnoczi <stefanha@redhat.com>, fio@vger.kernel.org
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/6/21 10:23 AM, Stefan Hajnoczi wrote:
> The following shell statement:
> 
>   if eval "echo \$$_feature" = "yes" ; then
> 
> executes:
> 
>   echo $... = "yes"
> 
> It does not actually compare the variable named by $_feature to the
> string "yes".
> 
> Add the missing "test" call so the comparison happens as intended and
> wrap the eval so it doesn't include the = "yes".

Applied, thanks.

-- 
Jens Axboe


