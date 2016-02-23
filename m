Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH]: Let I/O engine provide methods to allocate/free I/O
 memory.
References: <CANvN+e=-VtHTeaRftjvPJUjhgVY9nD85gn=6D4+TyQeLrEE_cw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <56CCD5D1.3020508@kernel.dk>
Date: Tue, 23 Feb 2016 14:57:37 -0700
MIME-Version: 1.0
In-Reply-To: <CANvN+e=-VtHTeaRftjvPJUjhgVY9nD85gn=6D4+TyQeLrEE_cw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 02/23/2016 02:16 PM, Andrey Kuzmin wrote:
> I/O engine may have special needs as to how the I/O memory should be
> allocated. The below patch adds respective methods to the I/O engine
> interface.

What kind of special needs? It's not that I mind adding an IO engine 
alloc hook, the only issue is that it potentially voids the various job 
file settings for memory backing etc without the user knowing it. So I 
think we need some decent justification here, other than "special needs" :-)



-- 
Jens Axboe


