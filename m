Return-Path: <radha@google.com>
MIME-Version: 1.0
In-Reply-To: <20090422062132.GV4593@kernel.dk>
References: <66dfd3fe0904101557g99d6b63r5a24a84cfe01ffbf@mail.gmail.com>
	 <20090418175308.GE4593@kernel.dk>
	 <66dfd3fe0904211631q2d5b7045o5664a3bdda100c19@mail.gmail.com>
	 <20090422060528.GU4593@kernel.dk> <20090422062132.GV4593@kernel.dk>
Date: Tue, 21 Apr 2009 23:22:06 -0700
Message-ID: <66dfd3fe0904212322p4aab3f2fp5fca17eeeb588608@mail.gmail.com>
Subject: Re: Issue running random reads with verify on a raw device
From: Radha Ramachandran <radha@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jens Axboe <jens.axboe@oracle.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Awesome.
Thanks
-radha

On Tue, Apr 21, 2009 at 11:21 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Apr 22 2009, Jens Axboe wrote:
>> On Tue, Apr 21 2009, Radha Ramachandran wrote:
>> > Hi Jens,
>> > Ah right, I missed the offset.
>> > My interpretation of the options was that the check needs to be that
>> > the (new random block + offset) needs to be < both the real_file_size
>> > and io_size.
>> >
>> > Iam not sure i understand what you said very well, so the fix that I have is:
>>
>> I read up on the code, and I think your previous patch was correct. The
>> offset isn't added until later in the process, so we should indeed not
>> check the offset in this location.
>>
>> I'll test your previous patch and add it, sorry for the noise!
>
> Everything appears to be in working order, I have added your fix.
> Thanks!
>
> --
> Jens Axboe
>
>

