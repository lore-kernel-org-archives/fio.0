Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/5] terse client/server output
References: <20190515200503.23000-1-vincentfu@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <852c76f6-e392-0f9b-a4f6-99b4128f9a0d@kernel.dk>
Date: Thu, 16 May 2019 08:43:04 -0600
MIME-Version: 1.0
In-Reply-To: <20190515200503.23000-1-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: vincentfu@gmail.com, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/15/19 2:04 PM, vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Jens, please consider these patches.
> 
> I have a user trying to use a single script to consume terse output from
> stand-alone fio runs and client/server fio runs. The patches address
> some issues with client/server terse output that we found.
> 
> Vincent
> 
> Vincent Fu (5):
>   client: do not print disk utilization for terse v2
>   client: handle disk util for all output formats
>   client: add a newline after terse disk util
>   docs: improve terse output format documentation
>   stat: remove terse v2 blank lines with description not set
> 
>  HOWTO    | 12 +++++++++++-
>  client.c |  9 ++++++---
>  fio.1    | 11 ++++++++++-
>  stat.c   |  7 ++++---
>  4 files changed, 31 insertions(+), 8 deletions(-)

Applied, thanks Vincent.

-- 
Jens Axboe


