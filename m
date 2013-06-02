Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20130527082147.GC29680@kernel.dk>
References: <CAF+0mvnU7GMsKrbArcECaD5Z0YtLxA6GtghQjOJtOxZHb=cxjQ@mail.gmail.com>
	<20130527082147.GC29680@kernel.dk>
Date: Sat, 1 Jun 2013 19:11:20 -0700
Message-ID: <CAF+0mv=Lw7GF6PyYBw9LGAf5LGmM85WZVrWv3Ba=6O2bQ6zU3Q@mail.gmail.com>
Subject: Re: Question on --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thank you for your explanation.  I have another question in regards to
buffer_compress_percentage if you don't mind.

If I were to call fio with "--refill_buffers
--buffer_compress_percentage=0", would this be the same as setting
only "--refill_buffers"?

Also, if I were to call fio with "--refill_buffers
--buffer_compress_percentage=100", would this be the same as setting
"--zero_buffers"?

Thanks again for your help!

On Mon, May 27, 2013 at 1:21 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On Fri, May 24 2013, Matthew Eaton wrote:
>> Hello fio group,
>>
>> Can anyone tell me if --buffer_compress_percentage fills the buffer
>> with random data and reuses that data or if it refills with random
>> data for each submit?  If you want the latter behavior should you
>> combine with --refill_buffers?
>
> That is actually explained in the man page / HOWTO:
>
> buffer_compress_percentage=int  If this is set, then fio will attempt to
>                 provide IO buffer content (on WRITEs) that compress to
>                 the specified level. Fio does this by providing a mix of
>                 random data and zeroes. Note that this is per block size
>                 unit, for file/disk wide compression level that matches
>                 this setting, you'll also want to set refill_buffers.
>
> So the answer to your question is yes. Fio will reuse IO buffers, unless
> --refill_buffers is set. If you do not set refill_buffers with
> buffer_compress_percentage, then you will have identically compressible
> blocks written. And that would only give you the per-block compression
> ratio specified, on a broader scale it would compress more.
>
> --
> Jens Axboe
>

