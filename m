Return-Path: <axboe@kernel.dk>
Message-ID: <554810E1.2020301@kernel.dk>
Date: Mon, 04 May 2015 18:37:53 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>	<5547D99E.4080103@kernel.dk>	<CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>	<5547EC73.5030001@kernel.dk>	<5547EDD7.9000903@kernel.dk> <CANff2=NEJF6YJ-yzf5BcFjpLp_P83S3mRvk3baZdRj02mgqkMQ@mail.gmail.com>
In-Reply-To: <CANff2=NEJF6YJ-yzf5BcFjpLp_P83S3mRvk3baZdRj02mgqkMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Brian Fulton <bfulton@google.com>
Cc: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 05/04/2015 05:17 PM, Brian Fulton wrote:
> Hi Jens,
>
> Akash and I both discovered this bug and work together.  He is
> currently on holiday for the next two weeks or so.  I am currently
> using the same tests that originally discovered the bug to verify it
> is fixed.

Ah perfect, I didn't realize that!

> Out of curiosity, why is the comma required after the zero in order to
> initialize all elements to zero?  I used this initializer instead of
> memset just as it was used here:
> https://github.com/axboe/fio/blob/master/cgroup.c#L26.  Are there
> certain compilers that require the comma?  I also checked the C99 spec
> http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf, Section
> 6.7.8, page 125, sections 1 and 21.  I just want to make sure I'm not
> loosing my mind.

Actually I might be mistaken, it's just an array. For structs you need 
the comma to ensure it zero fills the rest of the members, for arrays I 
believe your approach was actually fine.

-- 
Jens Axboe


