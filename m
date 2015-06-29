Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <5591687D.6040803@kernel.dk>
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
 <5591687D.6040803@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 29 Jun 2015 10:53:40 -0500
Message-ID: <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com>
Subject: Re: competime_assert failure without -O3 optimization flag expected ?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Sure, I will investigate it. Just want to confirm the issue is in the
compiletime_assert() code as you mentioned and it is not in that line
of code that I cite in my last email. I managed to remedy this issue a
little bit by using -O1 instead of -O3 but still the optimized program
order is not exactly similar to the default source code order.

--Alireza

On Mon, Jun 29, 2015 at 10:47 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/29/2015 08:46 AM, Alireza Haghdoost wrote:
>>>
>>> +struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
>>> +{
>>> +       struct all_io_list *rep;
>>> +       struct thread_data *td;
>>> +       size_t depth;
>>> +       void *next;
>>> +       int i, nr;
>>> +
>>> +       compiletime_assert(sizeof(struct all_io_list) == 8,
>>> "all_io_list");
>>
>>
>>
>> I am getting compile time assertion failure on the following line of
>> code when I remove the optimization flag (-O3) in the Makefile. Is
>> this something expected ? I want to remove optimizations in order to
>> debug my code based on original source code line order not optimized
>> code order.
>
>
> Yeah it's expected, but should be fixed. I just haven't looked into why the
> compiletime_assert() fails if optimizations are disabled. It really
> shouldn't, since the size of the struct is still 8 when disabled. So it's a
> bug in the compiletime_assert() code. Feel free to poke at it :-)
>
> --
> Jens Axboe
>

