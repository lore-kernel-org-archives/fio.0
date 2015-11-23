Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56533BE5.3010606@kernel.dk>
References: <CAF+0mvmGOrVdpaobMa-ChSz2qPJqhE1s+qUbJpdHPpEo+UKcww@mail.gmail.com>
	<56533A11.4050706@kernel.dk>
	<56533BE5.3010606@kernel.dk>
Date: Mon, 23 Nov 2015 14:15:31 -0800
Message-ID: <CAF+0mv=KWZ-_VGEFLhDzh70E2ztr7esdjOpQR-wdLJ-eQ-mRng@mail.gmail.com>
Subject: Re: Bug with --buffer_compress_percentage
From: Matthew Eaton <m.eaton82@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> I think this is an artifact of how gzip compression works, it doesn't
>> have an unlimited size window. It's 32k, iirc. Fio should fill so that
>> it ideally would compress to the given size with an ideal compression
>> algorithm.
>>
>> You'd probably want to use buffer_compress_chunk=x to always force fio
>> to operate in sizes of that for compression, if you want to ensure that
>> gzip would be able to compress to the specified ratio. I do think we
>> have a loop missing though for that to do what you need, let me test
>> that and report back.
>
>
> I think things should work for all sizes, if you add this patch and then add
> buffer_compress_chunk=32k or similar to your job file. You can do that for
> smaller block sizes as well, fio will use the minimum of that chunk size or
> the write block size.
>
> --
> Jens Axboe
>

Applied the patch and added buffer_compress_chunk=32k and now it's
working for all block sizes. Thank you for the info and the patch!

