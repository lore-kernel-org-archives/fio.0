Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH] fix regression by 8c43ba62('filesetup: align layout
 buffer')
References: <20170901122423.94484-1-tkusumi@tuxera.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <39b3b195-31ea-ffb9-0473-1e75b4501e64@kernel.dk>
Date: Fri, 1 Sep 2017 08:24:40 -0600
MIME-Version: 1.0
In-Reply-To: <20170901122423.94484-1-tkusumi@tuxera.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: kusumi.tomohiro@gmail.com, fio@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>
List-ID: <fio@vger.kernel.org>

On 09/01/2017 06:24 AM, kusumi.tomohiro@gmail.com wrote:
> From: Tomohiro Kusumi <tkusumi@tuxera.com>
> 
> 8c43ba62('filesetup: align layout buffer') needs to use the same size
> for fio_memalign() and fio_memfree().
> 
> If the size `bs' gets decreased while in the write(2) loop, the size
> for freeing is smaller than it should be, and results in segfault
> by dereferencing ->offset of the footer via irrelevant address somewhere
> in user data.

Good catch, should have been reviewed more carefully. Applied.

-- 
Jens Axboe


