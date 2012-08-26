Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:48816 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2HZWUq (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 26 Aug 2012 18:20:46 -0400
Message-ID: <503AA116.6040301@kernel.dk>
Date: Sun, 26 Aug 2012 15:20:06 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio client/server with different job files
References: <CA+bjhhSHkDH-bAOo6_zRw4gRPqcc=R5JKq4gh61Nt+reeX8CvA@mail.gmail.com> <5035D1AE.8080309@kernel.dk>
In-Reply-To: <5035D1AE.8080309@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Frank Leers <fleers@gmail.com>
Cc: fio@vger.kernel.org

On 2012-08-22 23:46, Jens Axboe wrote:
> On 2012-08-23 02:32, Frank Leers wrote:
>> Hello,
>>
>> Is it possible to lanch fio against multiple servers, each having a
>> unique job file?
>>
>> example
>>
>> (assume fio --server started already on these two nodes)
>> # fio --client=node2 jobfile_for_node2 --client=node3 jobfile_for_node3.cfg
>>
>> Alternately, is there a directive that can be placed into a common job
>> file which would cause a specific server only to run jobs with that
>> directive?
>>
>> example
>>
>>
>> # fio --client=node2 --client=node3 jobfile.cfg
>>
>>
>> jobfile contains:
>>
>> [for_node2_only]
>> filename=/dev/shareddiskA
>> readwrite=read
>> runtime=60
>> ioengine=libaio
>> direct=1
>> iodepth=32
>> fsync_on_close=0
>> time_based
>> ioscheduler=noop
>> blocksize=4M
>> client=node2
>>
>>
>> [for_node3_only]
>> filename=/dev/shareddiskB
>> readwrite=read
>> runtime=60
>> ioengine=libaio
>> direct=1
>> iodepth=32
>> fsync_on_close=0
>> time_based
>> ioscheduler=noop
>> blocksize=4M
>> client=node3
> 
> It's not currently possible. It's one of the shortcuts I took when
> developing and testing the client/server mode. In reality it's just due
> to the parser sending all files to all servers, it'd be pretty easy to
> fix up so that you could do:
> 
> # fio --client=node2 jobfile_for_node2 --client=node3 jobfile_for_node3.cfg
> 
> and have it work exactly as you expect.
> 
> I've got some travel time coming up shortly, I'll get this fixed up. You
> are not the first to (rightfully) wonder why it behaves as it currently
> does :-)

Done mid-air (and still 10k up, fwiw), did not take too long. Please try
a current git snapshot, it should have support for doing the above
format of sending different ini files to different clients. I can't
really test it with no other machines to connect to, so feedback would
be appreciated.

-- 
Jens Axboe

