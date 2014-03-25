Return-Path: <fio-owner@vger.kernel.org>
Received: from mx12.netapp.com ([216.240.18.77]:37111 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754837AbaCYUys convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 25 Mar 2014 16:54:48 -0400
From: "Neto, Antonio Jose Rodrigues" 
	<Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: Compressible and Dedupable ratios using fio
Date: Tue, 25 Mar 2014 20:54:47 +0000
Message-ID: <CF576193.61C6%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <CF43A47E.293D5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <CAF+0mv=suTk2XbOuRyhfVyKFVAjk5mhfpawwqP5Nb7BeQKTu0g@mail.gmail.com>
 <CF4BB600.4797%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <CF4BB600.4797%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28A03EAED328C44695F59174D46123A1@hq.netapp.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Matthew Eaton <m.eaton82@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>


>><Antonio.Jose.Rodrigues.Neto@netapp.com> wrote:
>>> Hi All,
>>>
>>> This is neto from Brazil
>>>
>>> How are you?
>>>
>>> I need to know how to control the % of compression and deduplication
>>>using
>>> fio?
>>>
>>> My idea is to generate some workload based on:
>>>
>>> Workload Random
>>> 0% compressible and 0% dedupable
>>>
>>> Workload Mixed
>>> 20% compressible and 20% dedupable
>>>
>>> Workload Easier
>>> 100% compressible and 100% dedupable
>>>
>>> Could you please help me?
>>>
>>> Thank you very much,
>>>
>>> All the best
>>>
>>> neto
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>Hi Neto,
>>
>>Have you tried using buffer_compress_percentage?  Setting this to 100
>>would get you 100% compressible data while 0 would be 0% compressible.
>> Note that if you use fio prior to version 2.1.6 in git, you will also
>>want to set scramble_buffers=0 to get the desired compression.
>>
>>I don't know how you would control how dedupable the data is, since to
>>my knowledge there is no way to specify how repeatable the data
>>pattern is.  But I think fully incompressible data is naturally not
>>dedupable, while the opposite is true for fully compressible data.

Hi All,

This is neto from Brazil

How are you?

I am doing some tests here and I would like to share the results.

Go fio :-)

[oracle@s1][flash1][~/fio]$ ./fio -version
fio-2.1.6.1-18-g190b

Config file:
[workload]
bs=8k
ioengine=libaio
iodepth=1
numjobs=1
direct=1
runtime=10
size=1024m
filename=/home/oracle/fio/bigfile
rw=read
thread
unified_rw_reporting=1
group_reporting=1
buffer_compress_percentage=100

Assuming 100% compressible - it's working



[oracle@s1][flash1][~/fio]$ gzip -v bigfile
bigfile:	 99.9% -- replaced with bigfile.gz



Now I will try to generate something with 0 compressible:

[workload]
bs=8k
ioengine=libaio
iodepth=1
numjobs=1
direct=1
runtime=10
size=1024m
filename=/home/oracle/fio/bigfile
rw=read
thread
unified_rw_reporting=1
group_reporting=1
buffer_compress_percentage=0


[oracle@s1][flash1][~/fio]$ gzip -v bigfile
bigfile:	  0.3% -- replaced with bigfile.gz

One question:

1) Are these parameters (randrepeat=0, norandommap=1,
file_service_type=random) going to help in the randomness and
compressibility of the data?

2) Do you have any practical example where I have to use those parameters?

In my tests, I haven't notice any difference.


Thank you very much,

All the best

neto










