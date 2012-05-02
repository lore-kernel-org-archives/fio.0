Return-Path: <fio-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:49305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab2EBMNJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 2 May 2012 08:13:09 -0400
Message-ID: <4FA124B9.8050505@kernel.dk>
Date: Wed, 02 May 2012 14:12:41 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Running fio with offset Increment option
References: <CAN8qX8bPefV2J1xtNVBZ36sEKE-Vg-te+_Kj__hDoJGEzLzW=A@mail.gmail.com> <4F899663.8050406@kernel.dk> <4F8997E9.6090206@kernel.dk> <CAN8qX8bNZ4VPFP1a09DdJSaVa2D0MZ0vqLqHF-S4hbdHwuJZcw@mail.gmail.com> <4F8D0E1A.2020004@kernel.dk> <CAN8qX8ZJXpKibjFfyG9ZBG=eXNwWtdm5X9FyRduKvCcyQx7RwA@mail.gmail.com> <4F8FA704.30006@kernel.dk> <CAN8qX8baRKJrLRQ3p--NBMH9hA+G5om6R9hRQEr2ZXwbDc3Hwg@mail.gmail.com> <4F9101C0.100@kernel.dk> <CAN8qX8a4=a4hBkuB54MGV3_+=+wrPVae6oN6Hh=H-ZQt+0ewyA@mail.gmail.com>
In-Reply-To: <CAN8qX8a4=a4hBkuB54MGV3_+=+wrPVae6oN6Hh=H-ZQt+0ewyA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Suresh Dhanarajan <sureshdrajan@gmail.com>
Cc: fio@vger.kernel.org

On 04/28/2012 09:09 PM, Suresh Dhanarajan wrote:
> Hi Jens,
> 
> I verified the offsets by using the write_io_log switch.
> when i use offset increment without patch the offset are incremented
> and not reset to zero after stone wall.
> when i use with patch the offset resets to zero after stone wall.
> I hope you are testing with the patch.
> If it is so this what the behavior iam  also seeing.

I'm puzzled. Did a full test here now, with the patch. Simple job:

[global]
ioengine=null
bs=1k
size=10m
offset_increment=1m
numjobs=2
write_iolog=log

[job1]
rw=read

[job2]
stonewall
rw=read

using both the write_iolog and --debug=io, I verified that job1 has two
files, one starts at 0M the next at 1M. job2 has two files, one starts
at 0M the next at 1M. If I remove the stonewall, job1 has 0M/1M and job
has 2M/3M.

That certainly looks like it's working to me. I think you need to check
and double check that you are indeed using a patched version. And note
that write_iolog will _append_ to an existing log file. Perhaps you are
looking at an earlier entry set?

-- 
Jens Axboe

