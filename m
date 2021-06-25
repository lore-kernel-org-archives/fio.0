Return-Path: <axboe@kernel.dk>
Subject: Re: random buffer_compress_percentage instead of static
References: <CAP6uPsW0SF-0BuLkx8aC8X9xuqju4C-+9wknxMP3JiOqB6_QRg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <e2f3a5c9-88a5-fa17-610e-a107589ef3a6@kernel.dk>
Date: Thu, 24 Jun 2021 18:55:10 -0600
MIME-Version: 1.0
In-Reply-To: <CAP6uPsW0SF-0BuLkx8aC8X9xuqju4C-+9wknxMP3JiOqB6_QRg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: Sunil Vettukalppurathu <sunilvm@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 6/24/21 12:38 PM, Sunil Vettukalppurathu wrote:
> Hi,
> 
> Currently we can’t vary % of compressible data from block to block (as
> far as I know). The value provided  for buffer_compress_percentage is
> used for all blocks.
> 
> """
> buffer_compress_percentage=int
> If this is set, then fio will attempt to provide I/O buffer content
> (on WRITEs) that compresses to the specified
> level. Fio does this by providing a mix of random data followed by
> fixed pattern data. """
> 
> As we have a requirement to test with random compression %, we
> modified the code to accept a range of values for
> buffer_compress_percentage instead of one number so that the
> percentage changes from block to block – random value between min and
> max.
> 
> Not sure if  it’s useful for others; if so, will send the patch for review.

Please do, sounds like a useful feature. How is it managed in terms of
options?

-- 
Jens Axboe


