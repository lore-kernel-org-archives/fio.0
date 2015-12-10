Return-Path: <axboe@kernel.dk>
Subject: Re: Exit all jobs on error
References: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <5669B23C.1020001@kernel.dk>
Date: Thu, 10 Dec 2015 10:11:24 -0700
MIME-Version: 1.0
In-Reply-To: <CALjAwxhfyQ3ppw-MXoRwAkhk4+-LSJSTkZQa32ymKizKU0Ox-A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Sitsofe Wheeler <sitsofe@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/10/2015 12:01 AM, Sitsofe Wheeler wrote:
> Hi,
>
> Is there an option to exit all jobs but only on error? If I have a job like this
>
> [global]
> stonewall=1
> verify=crc32
> rw=write
> [pass1]
> bs=4k
> [pass2]
> bs=8k
>
> I want fio to stop if pass1 fails verification and for pass2 not to be
> performed at all. I'm aware of "exitall" but using that will make fio
> quit even if pass1 is successful.

That doesn't exist, but we could add a exitall_on_error to have that 
behavior. Should be pretty easy to add.

-- 
Jens Axboe


