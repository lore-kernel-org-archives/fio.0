Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] Declare debug_levels[] const
References: <20180310004602.5733-1-bart.vanassche@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d924a05b-0500-b3ea-ce90-299b4e0715f6@kernel.dk>
Date: Fri, 9 Mar 2018 21:33:54 -0700
MIME-Version: 1.0
In-Reply-To: <20180310004602.5733-1-bart.vanassche@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 3/9/18 5:46 PM, Bart Van Assche wrote:
> Since debug_levels[] is not modified by any code, declare it const.

Applied, thanks.

-- 
Jens Axboe


