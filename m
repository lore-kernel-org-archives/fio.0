Return-Path: <axboe@kernel.dk>
Subject: Re: fio and zone support
References: <1fc030d5ba842b0324bd2fd4333edc31d2eae652.camel@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <15e215bc-76ea-b65e-c79b-116758bea445@kernel.dk>
Date: Tue, 10 Jul 2018 09:36:31 -0600
MIME-Version: 1.0
In-Reply-To: <1fc030d5ba842b0324bd2fd4333edc31d2eae652.camel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, "gv.kovai@gmail.com" <gv.kovai@gmail.com>
List-ID: <fio@vger.kernel.org>

On 7/10/18 9:32 AM, Bart Van Assche wrote:
> Hello Jens,
> 
> In __fill_io_u_zone() I found the following code (see also commit 224b3093cc21
> ("Fix zoning issue with seq-io and randommap issue")):
> 
> 		/*
> 		 * Wrap from the beginning, if we exceed the file size
> 		 */
> 		if (f->file_offset >= f->real_file_size)
> 			f->file_offset = f->real_file_size - f->file_offset;
> 
> If f->file_offset > f->real_file_size then f->real_file_size - f->file_offset
> will be negative and hence the above assignment will store a negative number
> in f->file_offset. Is that what the above code is intended to do?

No, that looks wrong. But looking at the commit, it basically just moved
that code, so the issue predates that particular change.

-- 
Jens Axboe


