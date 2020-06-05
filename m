Return-Path: <axboe@kernel.dk>
Subject: Re: Sequential profile in FIO 3.7 in linux CentOS 7
References: <CAFsSD_XNL1iA7LT1ChdL0ZFRT+_6TV9N+VerbTEJFYOvs4ZYXg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <818b44df-741d-dfc6-6a1f-479b11ab556a@kernel.dk>
Date: Fri, 5 Jun 2020 07:02:08 -0600
MIME-Version: 1.0
In-Reply-To: <CAFsSD_XNL1iA7LT1ChdL0ZFRT+_6TV9N+VerbTEJFYOvs4ZYXg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: harshit jain <kumarjain10@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6/5/20 12:52 AM, harshit jain wrote:
> Hi Jen's,
> 
> I need help in creating an I/O profile wherein the LBA access are
> sequential. Basically is it possible to create a profile wherein the
> LBA pattern is write on LBA 0 followed by read on LBA 0 immediately
> and so on?
> 
> I am trying to generate the below mentioned sequence
> 
> Write LBA0
> Read LBA0
> 
> Write LBA1
> Read LBA1
> 
> Write LBAn
> Read LBAn
> 
> And so on till all LBA sectors is covered.
> 
> Any pointers would be much appreciated.

Please send general queries etc to the mailing list, I've CC'ed it.

For this use case, I'd just do a verify workload with a backlog of 1.
That means that after 1 write, we'll verify it.

rw=write                                                                        
verify=crc32c                                                                   
verify_backlog=1                                                                

-- 
Jens Axboe


