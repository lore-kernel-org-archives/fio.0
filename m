Return-Path: <axboe@kernel.dk>
Message-ID: <5344519A.9020607@kernel.dk>
Date: Tue, 08 Apr 2014 13:44:26 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Qn on setting ioengine on Replay job
References: <CAEyTGCfDabxuWOXW_UWq76bmVYqNUELk9X3YqcVFe5gtCvOGwg@mail.gmail.com> <53444A86.3030904@kernel.dk>
In-Reply-To: <53444A86.3030904@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 04/08/2014 01:14 PM, Jens Axboe wrote:
> On 04/08/2014 10:39 AM, Lakshmi wrote:
>> Hi Jens,
>>
>>    Is it possible to set the ioengine and iodepth on a replay job?
>> Would it have any effect on the replay jobs? I tried setting as below,
>> but didnt see any change. So wanted to make sure if what I am doing is
>> valid.
>>
>> [global]
>> replay_no_stall=1
>> ioengine=posixaio
>> buffered=0
>> iodepth=6
>>
>> [job1]
>> read_iolog=/home/file_3080658.bin
>
> The ioengine will always work, the iodepth should work as well. blktrace
> loading doesn't actually set the iodepth, so it should run at depth 1
> unless you tell it otherwise. That should be fixed up, actually.
>
> That said, you wont see higher depth than the job itself has done. The
> depth will be naturally limited by the events in that trace. However, if
> a lower depth is set, then that should be enforced (since fio is forced
> to wait on IO if it runs out of IO buffers).

Added a patch to probe the depth from the blktrace file. So should now 
set the detected depth, if it can.

-- 
Jens Axboe


