Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] stat: fix accumulation of latency buckets
References: <20190321164513.6475-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <03fcfb73-1392-1ad3-62bb-047a2a218c0a@kernel.dk>
Date: Thu, 21 Mar 2019 10:54:14 -0600
MIME-Version: 1.0
In-Reply-To: <20190321164513.6475-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 3/21/19 10:45 AM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> The numbers of buckets for nsec, usec, and msec latencies may differ
> from each other. So we need to iterate separately over the three types
> of buckets.

Good catch! Thanks Vincent, applied.

-- 
Jens Axboe


