Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 0/4] Improve fio max open zones handling
References: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <20951f72-3301-f4ac-3a2d-9cc14805b5d6@kernel.dk>
Date: Fri, 14 May 2021 08:57:50 -0600
MIME-Version: 1.0
In-Reply-To: <20210514125233.10508-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Niklas Cassel <Niklas.Cassel@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/14/21 6:52 AM, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Improve max open zones handling by introducing a new IO engine operation,
> which can be implemented by ioengines.
> 
> Also provide a default implementation for Linux, which parses sysfs for
> the max open zones value.
> 
> Update libzbc ioengine to utilize the new callback.
> 
> Having this callback has the two following advantages:
> 
> 1) If the user forgets to specify a --max_open_zones value, we will
> automatically use the maximum the drive supports.
> (Instead of getting errors because fio tries to open too many zones.)
> 
> 2) If the user specifies a --max_open_zones value that is too big,
> we will return an error and fio will exit with a proper error message.
> (Instead of getting errors because fio tries to open too many zones.)

Applied, thanks.

-- 
Jens Axboe


