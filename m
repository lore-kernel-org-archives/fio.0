Return-Path: <axboe@kernel.dk>
Message-ID: <5591687D.6040803@kernel.dk>
Date: Mon, 29 Jun 2015 09:47:09 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: competime_assert failure without -O3 optimization flag expected
 ?
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
In-Reply-To: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Alireza Haghdoost <haghdoost@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/29/2015 08:46 AM, Alireza Haghdoost wrote:
>> +struct all_io_list *get_all_io_list(int save_mask, size_t *sz)
>> +{
>> +       struct all_io_list *rep;
>> +       struct thread_data *td;
>> +       size_t depth;
>> +       void *next;
>> +       int i, nr;
>> +
>> +       compiletime_assert(sizeof(struct all_io_list) == 8, "all_io_list");
>
>
> I am getting compile time assertion failure on the following line of
> code when I remove the optimization flag (-O3) in the Makefile. Is
> this something expected ? I want to remove optimizations in order to
> debug my code based on original source code line order not optimized
> code order.

Yeah it's expected, but should be fixed. I just haven't looked into why 
the compiletime_assert() fails if optimizations are disabled. It really 
shouldn't, since the size of the struct is still 8 when disabled. So 
it's a bug in the compiletime_assert() code. Feel free to poke at it :-)

-- 
Jens Axboe


