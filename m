Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38650 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab2HAIux (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Aug 2012 04:50:53 -0400
Message-ID: <5018EDE8.7080200@kernel.dk>
Date: Wed, 01 Aug 2012 10:50:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: How to get latency logs after 1.39?
References: <201207102239.q6AMdutO26456531@zion.americas.sgi.com>
In-Reply-To: <201207102239.q6AMdutO26456531@zion.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: emery@sgi.com
Cc: fio@vger.kernel.org

On 07/11/2012 12:39 AM, emery@sgi.com wrote:
> emery@sgi.com:  Scott Emery <emery@sgi.com>
> In message <201207092138.q69LcsAr22293463@zion.americas.sgi.com>, Scott Emery w
> rites:
>>
>> 	I eventually want to specify a job on the command line that includes
>> collecting latency/bandwidth/iops logs.
>>
>> 	I have a command/job script combination that makes latency
>> logs in 1.38 and doesn't in 1.39.   I fail to get latency logs for a fair
>> sample of fio versions from 1.39 to 2.07. I discovered this in attempting
>> to figure out where the behavior changed.
>>
>> cat ./run
>> #
>> /loaner/semery/fio/fio-1.39/fio --output test.small.loaner --latency-log --ban
>> dwidth-log  --alloc-size=4096 test.small
>>
>> cat test.small
>> #
>> [global]
>> bs=2m
>> ioengine=libaio
>> iodepth=1
>> size=1g
>> direct=1
>> runtime=1200
>> directory=/loaner/semery/fio/latencylogs
>> group_reporting
>>
>> [seq-read]
>> rw=read
>> numjobs=2
>>
>> [seq-write]
>> new_group
>> rw=write
>> numjobs=1
>>
>>
>> When run uses fio-1.38 I get the following:
>> [semery@lou2-mov4 latencylogs]$ ./run
>> [semery@lou2-mov4 latencylogs]$ ls
>> run		   seq-write.3.0	  test.putgetstorm.iod4.loaner
>> seq-read.1.0	   seq-write_clat.log	  test.small
>> seq-read.2.0	   seq-write_slat.log	  test.small.loaner
>>
>> With fio-1.39 I get:
>> [semery@lou2-mov4 latencylogs]$ ls
>> run	      seq-write.3.0	     test.putgetstorm.iod4.loaner
>> seq-read.1.0  test.putgetstorm	     test.small
>> seq-read.2.0  test.putgetstorm.iod4  test.small.loaner
>>
>> I grovelled through a diff -r of 1.38 and 1.39 and the significant looking
>> difference is this:
>>
>> diff -r fio-1.38/init.c fio-1.39/init.c
>> 884,886d883
>> <       def_thread.o.write_bw_log = write_bw_log;
>> <       def_thread.o.write_lat_log = write_lat_log;
>> <
>>
>>
>> 	Have latency logs, et. al. been deprecated?  Is there a  new/better
>> way to get them?
>>
>>
>> Scott Emery
>> emery@sgi.com
>> --
>> To unsubscribe from this list: send the line "unsubscribe fio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> That is commit 91da686ce2136e70c0ba734ad5698684582ab1b0
> http://git.kernel.dk/?p=fio.git;a=commit;h=91da686ce2136e70c0ba734ad5698684582ab1b0A
> "Keep the global command line bw/lat logs separate from per job logs"
> 
> That sounds like a good goal, but I don't seem to be able to generate
> bw/lat logs using the command line since fio-1.39. 

Hmm weird, I'll take a look at this.

-- 
Jens Axboe

