Return-Path: <bfulton@google.com>
MIME-Version: 1.0
In-Reply-To: <CANff2=PN3sMxFK_KuY7qh0zLJ-jYOe7nrBOHuMiGKOdDgHLZtQ@mail.gmail.com>
References: <CAFFT=UmoooCznxAkUREsC5rGN-hxD++PYbL94s-m11jdycDM0w@mail.gmail.com>
	<5547D99E.4080103@kernel.dk>
	<CANff2=M1nm3GhJ-3RWVyzMHx9WE-SdO=eUUdwOKmC39HT9HQ-A@mail.gmail.com>
	<5547EC73.5030001@kernel.dk>
	<5547EDD7.9000903@kernel.dk>
	<CANff2=NEJF6YJ-yzf5BcFjpLp_P83S3mRvk3baZdRj02mgqkMQ@mail.gmail.com>
	<554810E1.2020301@kernel.dk>
	<CANff2=PN3sMxFK_KuY7qh0zLJ-jYOe7nrBOHuMiGKOdDgHLZtQ@mail.gmail.com>
Date: Fri, 15 May 2015 10:32:35 -0700
Message-ID: <CANff2=OkAgKtzmjJ5iVe_bZ0dixoDJVpy7_hC7ne3HikBfppqA@mail.gmail.com>
Subject: Re: [Bug report] Runtime, IOPS, bandwidth recorded incorrectly if
 small size with time_based
From: Brian Fulton <bfulton@google.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Akash Verma <akashv@google.com>, fio <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Hi Jens,

I've completed the regression tests and, from analyzing the results,
the bug appears to be no longer present.  In addition, I did not see
any inconsistencies or issues that were caused by this change.

- Brian

On Mon, May 4, 2015 at 6:12 PM, Brian Fulton <bfulton@google.com> wrote:
> Hi Jens,
>
> Thanks for your explanation regarding the comma initialization.  I
> just wanted to make sure I wasn't doing something that would break
> certain compilers.
>
> I was able to isolate the bug and reproduce it on one of my machines.
> I then created the fix and found that the bug was no longer
> reproducible with the fixed binary on the one machine (as of last
> Friday May 1st 2015) .
>
> I am currently running the tests that discovered the initial issue on
> multiple machines.  The tests may take some time to complete and upon
> completion I'll post my findings.
>
> - Brian
>
> On Mon, May 4, 2015 at 5:37 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 05/04/2015 05:17 PM, Brian Fulton wrote:
>>>
>>> Hi Jens,
>>>
>>> Akash and I both discovered this bug and work together.  He is
>>> currently on holiday for the next two weeks or so.  I am currently
>>> using the same tests that originally discovered the bug to verify it
>>> is fixed.
>>
>>
>> Ah perfect, I didn't realize that!
>>
>>> Out of curiosity, why is the comma required after the zero in order to
>>> initialize all elements to zero?  I used this initializer instead of
>>> memset just as it was used here:
>>> https://github.com/axboe/fio/blob/master/cgroup.c#L26.  Are there
>>> certain compilers that require the comma?  I also checked the C99 spec
>>> http://www.open-std.org/jtc1/sc22/wg14/www/docs/n1256.pdf, Section
>>> 6.7.8, page 125, sections 1 and 21.  I just want to make sure I'm not
>>> loosing my mind.
>>
>>
>> Actually I might be mistaken, it's just an array. For structs you need the
>> comma to ensure it zero fills the rest of the members, for arrays I believe
>> your approach was actually fine.
>>
>> --
>> Jens Axboe
>>

