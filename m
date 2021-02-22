Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] parse: simplify parse_is_percent()
References: <YDOvg+OKTZhSoDce@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4c012bb6-5100-6262-20a1-ba6992786c25@kernel.dk>
Date: Mon, 22 Feb 2021 07:36:42 -0700
MIME-Version: 1.0
In-Reply-To: <YDOvg+OKTZhSoDce@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org, dmitry.fomichev@wdc.com
List-ID: <fio@vger.kernel.org>

On 2/22/21 6:20 AM, Alexey Dobriyan wrote:
> Check "unsigned long long val <= -1ULL" is tautologically true
> because of how value conversions work.

Thanks, applied this and the other 3 patches. Note for future
patch series you should use git send-email and provide a small cover
letter for the series. Also avoids typos like 2/5 for patch 2, and
it gives the reviewer a sense of the whole series.

-- 
Jens Axboe


