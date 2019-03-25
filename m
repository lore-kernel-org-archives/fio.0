Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/2] client and stat patches
References: <20190325142028.32550-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <c1b55fe7-a405-4156-92fd-1684cdcf3075@kernel.dk>
Date: Mon, 25 Mar 2019 08:23:35 -0600
MIME-Version: 1.0
In-Reply-To: <20190325142028.32550-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 3/25/19 8:20 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider these two patches that address an output issue
> when fio runs jobs on servers and a style issue with the patch from last
> week.

Looks good, the all clients buffered and at the end makes sense.

-- 
Jens Axboe


