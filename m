Return-Path: <axboe@kernel.dk>
Message-ID: <542AC2B2.1070801@kernel.dk>
Date: Tue, 30 Sep 2014 08:48:18 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl> <5429C839.7090408@kernel.dk> <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl> <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com> <542A1A21.4070406@kernel.dk> <BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl> <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com> <BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com> <CANvN+ekYFU7=Fyq3Owv9Z-E8ZSR3xHXru3LVSCseCoqJJpjAYg@mail.gmail.com> <BLU402-EAS136DE85E04B0A269494B374E0BB0@phx.gbl> <CANvN+eme+6YiF8oNVDN0juq=8xLmf8Cn3FXjcgf5z26UVHW_zw@mail.gmail.com>
In-Reply-To: <CANvN+eme+6YiF8oNVDN0juq=8xLmf8Cn3FXjcgf5z26UVHW_zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Jon Tango <cheerios123@outlook.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-30 03:17, Andrey Kuzmin wrote:
> On Tue, Sep 30, 2014 at 1:14 PM, Jon Tango <cheerios123@outlook.com> wrote:
>>
>> The same thing could be done by partitioning the SSD in the operating system with the desired partition size, and then running a time-based fio job against the partition.
>>
>> Basically, fio options offset/size should yield the same net result, but I'm always unsure on what is the actual effect of mixing size and time_based in a single job, and whether fio will wrap around the specified size to the specified offset if the job is time-based. HOWTO could have used some clarification on size/time_based interaction.
>>
>> Regards,
>> Andrey
>>
>> On Sep 30, 2014 11:41 AM, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>>>
>>> On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
>>>>
>>>> The taskfile is this:
>>>
>>> I should have been more specific - you need to show both the _vdbench_
>>> parameter file that you are comparing to in addition to showing your
>>> fio job file.
>>>
>>> --
>>> Sitsofe |http://sucs.org/~sits/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in the
>>> body of a message tomajordomo@vger.kernel.org More majordomo info at
>>> http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> I'm really wanting to avoid the filesystem, they create so much interference. I am focusing on just testing the raw device :)
>
> I'm not sure why a filesystem should be involved in partitioning, that
> happens at the raw device level.

I think there's some limitation in Windows that doesn't allow partition 
raw IO. I may be mistaken.

But I agree, partition would work. But just limiting the LBA range with 
size= will do the same job.

-- 
Jens Axboe


