Return-Path: <fio-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53011 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbZDRRsN (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 18 Apr 2009 13:48:13 -0400
Date: Sat, 18 Apr 2009 19:48:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Recent changes
Message-ID: <20090418174812.GD4593@kernel.dk>
References: <20090409040002.0D18237A271@kernel.dk> <512785.43007.qm@web63808.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512785.43007.qm@web63808.mail.re1.yahoo.com>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

On Fri, Apr 17 2009, Girish Satihal wrote:
> Hi Jens,
> I am seeing a serious problem with fio testing. I tried running fio
> test on ext3 partition with Sequential Reads and Writes. I keep
> getting the I/O write error for Sequential writes. I tried with
> multiple servers with different controllers and I still get the same
> error. With Sequential Reads and Random Reads/Writes there is no issue
> seen. Please find the attached fio results file for Sequential
> Reads/Writes which has the error details pertaining to Sequential
> writes on ext3 file system. Thanks, Girish

That's pretty strange. Your test job(s) seem pretty massive, you don't
happen to have a cut down version that exhibits the problem?

There also seems to be parts of the error missing from io_u_log_error(),
like the file associated with the error and the io_u details (offset=
and buflen=, for instance).

What version of fio are you using?

-- 
Jens Axboe

