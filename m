Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fio: cap io_size=N% at 100%, update man page
References: <20200903165402.GA78826@localhost.localdomain>
 <CALjAwxhqaRPUGjyUapVM=cOqGTQSBb_wvSNQKe=k+eNGW6dL3w@mail.gmail.com>
 <20200907175923.GA86772@localhost.localdomain>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a4f10400-4095-6000-3bcd-c8bfcd4ac4c9@kernel.dk>
Date: Mon, 7 Sep 2020 13:39:51 -0600
MIME-Version: 1.0
In-Reply-To: <20200907175923.GA86772@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: fio@vger.kernel.org, sitsofe@gmail.com
List-ID: <fio@vger.kernel.org>

On 9/7/20 11:59 AM, Alexey Dobriyan wrote:
> Passing io_size > 100% results in semi-infinite loop, anyway.

Applied, thanks.

-- 
Jens Axboe


