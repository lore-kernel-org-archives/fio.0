Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] zbd: clean up libzbc ioengine and tests
References: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15fbdcf6-d3d4-029b-f1e5-b08285a0ec4b@kernel.dk>
Date: Mon, 25 May 2020 18:22:23 -0600
MIME-Version: 1.0
In-Reply-To: <20200525213256.7476-1-dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Cc: fio@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 5/25/20 3:32 PM, Dmitry Fomichev wrote:
> This series makes a few minor, but IMO useful changes in libzbc
> ioengine and ZBD test script.
> 
> Dmitry Fomichev (4):
>   libzbc: cleanup init code
>   libzbc: fix whitespace errors
>   t/zbd: beautify test script output
>   t/zbd: make the test script easier to terminate
> 
>  engines/libzbc.c       | 33 +++++++++++++++++----------------
>  t/zbd/test-zbd-support | 20 ++++++++++++++++++--
>  2 files changed, 35 insertions(+), 18 deletions(-)

Applied, thanks. BTW, since Damien asked, I'm fine with whitespace
changes as long as they are separate. Don't mix them with functional
changes. Ditto coding style changes.

-- 
Jens Axboe


