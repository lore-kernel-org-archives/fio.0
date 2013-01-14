Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38926 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab3ANJKB (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 14 Jan 2013 04:10:01 -0500
Message-ID: <50F3CB5F.8070507@kernel.dk>
Date: Mon, 14 Jan 2013 10:09:51 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: asking for an example job file
References: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
In-Reply-To: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Hong Jiang <hong@maginatics.com>
Cc: fio <fio@vger.kernel.org>

On 2013-01-11 20:24, Hong Jiang wrote:
> Hi there,
> 
> I am pretty new to this tool, and currently evaluating it on both
> linux and windows platforms.  Would appreciate if someone shows me an
> example of job file that can test this scenario:
> 
> I have a share that's created out of the "cloud", on windows client
> side it's mounted as a new drive, on linux it's mounted to a
> directory.  I would like to run some file op tests against the share.
> 
> I tried to use the example job file that came with the package -
> 1mbs_clients, modifying the "directory" parameter setting in the file,
> but I am not sure it's really running against the share, as the result
> looks exact the same when I ran the test on 2 different shares.
> 
> Thanks in advance for your help!

Delete the output files and run the test again? If the files are
created, then you should be able to safely confirm that it is running
where you think it is running. Fio will prefix any file with the
--directory= setting. So if you did set it, it should work...

-- 
Jens Axboe

