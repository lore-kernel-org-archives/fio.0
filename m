Return-Path: <fio-owner@vger.kernel.org>
Received: from fukushima.klipix.org ([85.12.144.25]:42867 "EHLO
        fukushima.klipix.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751578AbeEOQys (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 May 2018 12:54:48 -0400
Subject: Re: io_submit depth
References: <6c4cdf73-b7d9-7843-8061-86646c20ef02@klipix.org>
 <CALjAwxhF2s9V=JcjU5Lu74nLio+9S=YRrG9PpSoSkJLeXGU9TQ@mail.gmail.com>
From: Julien Desfossez <ju@klipix.org>
Message-ID: <29f37e87-986c-3682-052f-6ae441a4f063@klipix.org>
Date: Tue, 15 May 2018 12:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <CALjAwxhF2s9V=JcjU5Lu74nLio+9S=YRrG9PpSoSkJLeXGU9TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio@vger.kernel.org

On 05/15/2018 12:32 PM, Sitsofe Wheeler wrote:
> Hello Julien,
> 
> On 15 May 2018 at 16:20, Julien Desfossez <ju@klipix.org> wrote:
>> Hi,
>>
>> When stracing fio running on Linux (4.13) with libaio engine, I saw that
>> only one request is sent in the io_submit system call regardless of the
>> iodepth parameter value.
>>
>> To see this:
>> strace -f fio --name=tmp --filename=/tmp/fio --filesize=8G \
>> --ioengine=libaio --bs=4k --iodepth=32 --rw=randwrite \
>> --runtime=10 2>&1 | grep io_submit
>>
>> All of the lines look like this:
>> io_submit(140287955259392, 1, [{pwrite, fildes=3, str="...", nbytes=4096,
>> offset=1035223040}]) = 1
>>
>> I would have expected to see the second parameter to be 32.
> 
> By the by, did you see the warnings related to libaio in the
> manual/HOWTO (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-ioengine
> and http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth
> ) regarding buffering / not setting direct=1?
Yes I did and I usually benchmark with direct=1, I just removed 
parameters while doing this test.

>> I see that the iodepth parameter has an impact in how many requests are sent
>> at the beginning (in this example, I see 32 requests sent), but after that
>> the requests are sent one by one as soon as one completes. I understand this
>> is done to keep the number of "requests in flight" steady, but this is not
>> what I expected when setting iodepth.
>>
>> So is there a way to run fio so that we can send multiple requests per
>> io_submit call ?
> 
> Is iodepth_batch_submit
> (http://fio.readthedocs.io/en/latest/fio_doc.html#cmdoption-arg-iodepth-batch-submit
> ) and following what you're looking for?
> 
Indeed it helps !

Apparently what I am looking for is:
--iodepth=32 --iodepth_batch=32 --iodepth_batch_complete=32

Thanks !

Julien
