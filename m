Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56746DCA.201@kernel.dk>
References: <CANvN+emA01TZfbBx4aU+gg5CKfy+AEX_gZW7Jz4HMHvwkdBNoQ@mail.gmail.com>
 <56746DCA.201@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 18 Dec 2015 23:36:33 +0300
Message-ID: <CANvN+ekZxS_KVHkeUpqZir-bHg5__0=7ufJFGuH8yq=iadff7Q@mail.gmail.com>
Subject: Re: Stonewall reverse?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Fri, Dec 18, 2015 at 11:34 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/18/2015 01:28 PM, Andrey Kuzmin wrote:
>>
>> Stonewall option enforces post-serialization in that a job with the
>> option set waits for all other jobs in the file to complete. I'm
>> facing a use case where the reverse might be useful: have a number of
>> jobs wait for the specific one to complete. Is that something that can
>> be done with the existing options or a new development?
>
>
> So something like
>
> wait_for=id
>
> and 'id' would refer to a certain job?

Right. Or slightly extended to cover groups and inter-group
serialization (may be an overkill to start with).

> I can see that being a useful
> primitive, fio can't currently do that. Though it would be pretty easy to add.
>

OK, I'll look into this in my spare time.

Regards,
A.

> --
> Jens Axboe
>

