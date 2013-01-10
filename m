Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:52459 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3AJMO6 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 10 Jan 2013 07:14:58 -0500
Message-ID: <50EEB0BE.90909@fusionio.com>
Date: Thu, 10 Jan 2013 13:14:54 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: The relation about size/filesize/nrfiles
References: <2013011020083650949610@gmail.com>
In-Reply-To: <2013011020083650949610@gmail.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: fio <fio@vger.kernel.org>

On 2013-01-10 13:08, majianpeng wrote:
> Hi all,
> 	I wanted to test some files.But i wanted to use size rather than nrfiles.The job file is:
> [global]
> rw=write
> directory=/media
> bs=64k
> size=500M
> 
> [j1]
> filesize=256k
> 
> But fio only created one file.If i used nrfiles,the size is ignored.
> So how to write which can do what i wanted?

If you just set size= and nrfiles=, then the file size will set according
to that. By default, each file will be size / nrfiles. You can influence
that with filesize=low:high.


The above wont work, fio will not calculate the number of files
needed to satisfy that job file (it could though, I'll take a patch!).

-- 
Jens Axboe

