Return-Path: <fio-owner@vger.kernel.org>
Received: from wbwburpvsmtpa.warnerbros.com ([168.161.192.150]:15224 "EHLO
	WBWBURPVSMTPA.amer.warnerbros.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S937127Ab3DJRrA (ORCPT
	<rfc822;fio@vger.kernel.org>); Wed, 10 Apr 2013 13:47:00 -0400
Received: from [10.130.18.140] (wally.mpi.warnerbros.com [10.130.18.140])
	by nismstr.mpi.warnerbros.com (8.13.8/8.13.1) with ESMTP id r3AHkwAw018766
	for <fio@vger.kernel.org>; Wed, 10 Apr 2013 10:46:58 -0700
Message-ID: <5165A592.1030502@warnerbros.com>
Date: Wed, 10 Apr 2013 10:46:58 -0700
From: Alan Hagge <Alan.Hagge@warnerbros.com>
MIME-Version: 1.0
Subject: Re: How to re-use default sequential filenames?
References: <515DAA33.4000009@warnerbros.com> <20130404181946.GD9683@kernel.dk> <20130404184104.GE9683@kernel.dk> <20130405083902.GL9683@kernel.dk> <CAHBo9gn2t6khrMGBsL4omOmiFoGZzfRCOmS9KfLRmRjPa4F-3w@mail.gmail.com> <20130408111745.GC12244@kernel.dk>
In-Reply-To: <20130408111745.GC12244@kernel.dk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 04/08/2013 04:17 AM, Jens Axboe wrote:
> On Mon, Apr 08 2013, Michal Šmucr wrote:
>> 2013/4/5 Jens Axboe<axboe@kernel.dk>:
>>> and then 'write' and 'read' job would be sharing those files. Let me
>>> know if it works for you.
>> Thank you for patch Jens.
>> Re-using files working for me and i also like that string format
>> specification. Compiled with last git and tested on Mac OS X and
>> Centos 5.
>> I played with fio and sequence tests, it already helps me to get
>> figures much closer to real world utilization. I always struggled with
>> generic synthetic benchmarks as it usually don't work with sequences.
>> So i can roughly set IO sizes, modes, but for example can't simulate
>> performance differences caused by different file allocation between
>> one huge file (with few extents due to filesystem internal
>> optimization) and thousands of files.
>> Great!
> Thanks for testing and confirming that it both works and that the
> semantics make sense. I tagged 2.0.15 this morning and kept a few
> pending features/fixes in a 'next' branch, all have been pulled into the
> master branch. So the filename_format option is now in current -git,
> though it did not make 2.0.15 final.
I too was able to compile the git version and try a test this morning 
and it looks to be working just fine.  This will help us immensely.  
Thanks for the quick response and flexible solution!

