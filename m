Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH v2 1/2] add "invalid block size" to "first direct IO
 errored." message
References: <20170918182355.45590-1-tkusumi@tuxera.com>
 <20170918182355.45590-2-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <bd3c47da-165d-71b4-472b-5a2e79374b54@kernel.dk>
Date: Mon, 18 Sep 2017 12:27:22 -0600
MIME-Version: 1.0
In-Reply-To: <20170918182355.45590-2-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/18/2017 12:23 PM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> It could fail due to bs not multiple of sector size.

Applied, thanks.

-- 
Jens Axboe


