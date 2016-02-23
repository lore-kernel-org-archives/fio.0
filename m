Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH]: Let I/O engine provide methods to allocate/free I/O
 memory.
References: <CANvN+e=-VtHTeaRftjvPJUjhgVY9nD85gn=6D4+TyQeLrEE_cw@mail.gmail.com>
 <56CCD5D1.3020508@kernel.dk>
 <CANvN+e=DNFrp6j4+nAtm84BWZn7u-eWqbFWM0fFMLFd-B+Lx3g@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56CCD778.9070701@kernel.dk>
Date: Tue, 23 Feb 2016 15:04:40 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=DNFrp6j4+nAtm84BWZn7u-eWqbFWM0fFMLFd-B+Lx3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 02/23/2016 03:02 PM, Andrey Kuzmin wrote:
>
> On Feb 24, 2016 00:57, "Jens Axboe" <axboe@kernel.dk
> <mailto:axboe@kernel.dk>> wrote:
>  >
>  > On 02/23/2016 02:16 PM, Andrey Kuzmin wrote:
>  >>
>  >> I/O engine may have special needs as to how the I/O memory should be
>  >> allocated. The below patch adds respective methods to the I/O engine
>  >> interface.
>  >
>  >
>  > What kind of special needs? It's not that I mind adding an IO engine
> alloc hook, the only issue is that it potentially voids the various job
> file settings for memory backing etc without the user knowing it. So I
> think we need some decent justification here, other than "special needs" :-)
>  >
>
> My engine talks directly to the hardware, and has to comply with the
> hardware requirements re the io memory. Is that enough justification ;)?

Maybe :-)

What are those requirements? Is it just alignment?

-- 
Jens Axboe


