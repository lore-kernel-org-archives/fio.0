Return-Path: <emery@zion.americas.sgi.com>
Message-Id: <201211142126.qAELQEtO29426647@zion.americas.sgi.com>
From: emery@sgi.com
Subject: Re: All clients impatient 
In-reply-to: Your message of "Wed, 14 Nov 2012 12:58:00 MST."
             <50A3F7C8.4070103@kernel.dk> 
Date: Wed, 14 Nov 2012 15:26:14 -0600
Sender: emery@zion.americas.sgi.com
To: Jens Axboe <axboe@kernel.dk>
Cc: emery@sgi.com, fio@vger.kernel.org, emery@sgi.com
List-ID: <fio@vger.kernel.org>

emery@sgi.com:  Jens Axboe <axboe@kernel.dk>
In message <50A3F7C8.4070103@kernel.dk>, Jens Axboe writes:
>On 2012-11-14 12:29, emery@sgi.com wrote:
>> emery@sgi.com:  emery@sgi.com
>> In message <201211141909.qAEJ9HtO29431352@zion.americas.sgi.com>, emery@sgi.
>com
>>  writes:
>>> emery@sgi.com:  Jens Axboe <axboe@kernel.dk>
>>> In message <50A3DE92.3020509@kernel.dk>, Jens Axboe writes:
>>>> On 2012-11-14 10:54, Jens Axboe wrote:
>>>>> On 2012-11-14 10:42, Jens Axboe wrote:
>>>>>>> 	For a while it was totting things up after four clients,
>>>>>>> which kind of made sense... now it's stuck on three.  Back when
>>>>>>> it made more sense I thought that maybe handle_ts only dealt with
>>>>>>> the information from a single thread for each client rather than
>>>>>>> the aggregate of multiple thread jobs.  That part seems to hold
>>>>>>> true even when it doesn't have the info for all the clients.
>>>>>>>
>>>>>>> 	Is this reporting the aggregate as expected?
>>>>>>> 	Is there a parameter change that I need to make to get
>>>>>>> the output I expect?
>>>>>>
>>>>>> As the job file is written, it will not aggregate results from a single
>>>>>> "instance" of the server. You would want group_reporting=1 to do that.
>>>>>> However, that will still give you one set of outputs per connection, not
>>>>>> one for all of them. Right now fio does not support collecting outputs
>>>>>> from all connections, a higher level group reporting if you will.
>>>>>
>>>>> Actually, I misremembered that and didn't check before replying. It
>>>>> _will_ sum all clients, if it has more than one connection. But there's
>>>>> a bug where we race on client exit and dec the expected client count.
>>>>> Does it work better with the below patch?
>>>>
>>>> Note that you still need group_reporting=1 in your job file, the all
>>>> clients report depend on getting only one set of stats from each client.
>>>> I'll look into fixing that up, too.
>>>>
>>>> -- 
>>>> Jens Axboe
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>> 	Ah, I just sent an email to you noticing that... :-)
>>>
>>> Scott Emery
>>> emery@sgi.com
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> 
>> 	Works great when I add group_reporting.
>> 
>> [semery@xxx2-zzz2 multi2]$ egrep 'groupid|bw=' write_tape_2.out
>> wt2: (groupid=1, jobs=2): err= 0: pid=3070: Wed Nov 14 11:26:17 2012
>>   read : io=20480MB, bw=554641KB/s, iops=270 , runt= 37811msec
>> wt2: (groupid=1, jobs=2): err= 0: pid=10638: Wed Nov 14 11:26:17 2012
>>   read : io=20480MB, bw=556658KB/s, iops=271 , runt= 37674msec
>> wt2: (groupid=1, jobs=2): err= 0: pid=26969: Wed Nov 14 11:26:17 2012
>>   read : io=20480MB, bw=553703KB/s, iops=270 , runt= 37875msec
>> wt2: (groupid=1, jobs=2): err= 0: pid=14154: Wed Nov 14 11:26:17 2012
>>   read : io=20480MB, bw=553251KB/s, iops=270 , runt= 37906msec
>> All clients: (groupid=1, jobs=4): err= 0: pid=0: Wed Nov 14 11:26:17 2012
>>   read : io=85899MB, bw=2266.2MB/s, iops=1080 , runt= 37906msec
>
>Should work without group_reporting as well with the below patch. Can
>you confirm?
>


	Provides "All clients" correctly with and without  group_reporting
in the job description.

	Here is the output of without (plus a little debug code):
[semery@xxx2-zzz2 multi2]$ egrep 'groupid|bw=|sum_stat_clients' write_tape_2.out
wt2: (groupid=1, jobs=2): err= 0: pid=6167: Wed Nov 14 13:20:44 2012
  read : io=20480MB, bw=554905KB/s, iops=270 , runt= 37793msec
 sum_stat_nr 0, sum_stat_clients 4
wt2: (groupid=1, jobs=2): err= 0: pid=13534: Wed Nov 14 13:20:44 2012
  read : io=20480MB, bw=556628KB/s, iops=271 , runt= 37676msec
 sum_stat_nr 1, sum_stat_clients 4
wt2: (groupid=1, jobs=2): err= 0: pid=30390: Wed Nov 14 13:20:44 2012
  read : io=20480MB, bw=553003KB/s, iops=270 , runt= 37923msec
 sum_stat_nr 2, sum_stat_clients 4
wt2: (groupid=1, jobs=2): err= 0: pid=17854: Wed Nov 14 13:20:44 2012
  read : io=20480MB, bw=553003KB/s, iops=270 , runt= 37923msec
 sum_stat_nr 3, sum_stat_clients 4
All clients: (groupid=1, jobs=4): err= 0: pid=0: Wed Nov 14 13:20:44 2012
  read : io=85899MB, bw=2265.1MB/s, iops=1080 , runt= 37923msec


