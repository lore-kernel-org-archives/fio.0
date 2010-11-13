Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:54309 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932084Ab0KMUC7 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 13 Nov 2010 15:02:59 -0500
Message-ID: <4CDEEEE5.5060305@fusionio.com>
Date: Sat, 13 Nov 2010 21:02:45 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: IOPS higher than expected on randwrite, direct=1 tests
References: <20101109182801.GP15588@sebastiankayser.de>	<AANLkTikCz7-myG8JCkG+W44AKbg8DSqFcYUHLLOr_3wu@mail.gmail.com>	<20101110082223.GB14261@sebastiankayser.de>	<20101111162222.GO28050@sebastiankayser.de>	<AANLkTi=hTTmURQ8q9SJgDrPGx80F+Gjn6E1EBdLkoVwz@mail.gmail.com>	<20101112134359.GR28050@sebastiankayser.de> <AANLkTik5=tSj9h-O8O5Bub8J86rRiyYrTx7mmX5asgqC@mail.gmail.com>
In-Reply-To: <AANLkTik5=tSj9h-O8O5Bub8J86rRiyYrTx7mmX5asgqC@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Shawn Lewis <shawnlewis@google.com>
Cc: Sebastian Kayser <sebastian@skayser.de>, fio@vger.kernel.org

>> I wonder how many times I saw someone - including myself - fire up
>> bonnie++ or iozone with a rather small test file compared to the full
>> disk size ... Thanks very much everyone! This was an (overdue) eye
>> opener.
> In addition, testing with a file is dependent on the state of the file
> system. For example, if you're using a 100GB file and there's not enough
> contiguous free space to lay it out in one chunk you could have regions on
> different parts of the disk. Further, even there is enough space, that space
> could be near the inner or outer diameter which would also affect
> performance.
> 
> There is a way to get a file address to lba map (which would give you some
> insight into how a file is laid out). I think there's a syscall. Jens should
> know.

Yep, you can use FIBMAP/FIEMAP to walk the extents of the file and get a
full map of how it's laid out on disk. Not sure if there are tools
that'll do this for you, if not is pretty trivial to write.

-- 
Jens Axboe

