Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] t/zbd: Avoid magic number of test case count
References: <20190926010044.21020-1-shinichiro.kawasaki@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <a43073c3-08c3-0273-e2e5-a3537cd238ca@kernel.dk>
Date: Thu, 26 Sep 2019 08:47:25 +0200
MIME-Version: 1.0
In-Reply-To: <20190926010044.21020-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, fio@vger.kernel.org
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 9/26/19 3:00 AM, Shin'ichiro Kawasaki wrote:
> In the test script t/zbd/test-zbd-support, the number of test cases is
> defined as a raw constant. Every time a new test case is added, need to
> update the constant but this chore tends to be overlooked. When test
> case 47 was added recently, the number was not incremented from 46. Then
> the test script does not run the test case 47.
> 
> To avoid the constant increment chore, automate the test case number
> counting. List bash functions which implement test cases and convert the
> list to test case numbers.

Applied, thanks.

-- 
Jens Axboe


