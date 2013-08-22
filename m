Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:59716 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab3HVRKC (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 22 Aug 2013 13:10:02 -0400
Message-ID: <521645E5.8010509@kernel.dk>
Date: Thu, 22 Aug 2013 11:09:57 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: write_iops_log/write_bw_log command line parameter bug
References: <1314394180.368686.1377164275463.JavaMail.root@thomas-krenn.com>
In-Reply-To: <1314394180.368686.1377164275463.JavaMail.root@thomas-krenn.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?UTF-8?B?R2VvcmcgU2Now7ZuYmVyZ2Vy?= <gschoenberger@thomas-krenn.com>
Cc: fio@vger.kernel.org

On 08/22/2013 03:37 AM, Georg Schönberger wrote:
> Hi Jens,
> 
> it seems that the command line options "write_iops_log" and "write_bw_log" don't work as they are described in the man page:
> "If no filename is given with this option, the default filename of "jobname_type.log" is used."
> 
> Unfortunately the files/filenames are not created automatically by fio:
> # fio --name=test --direct=1 --refill_buffers --filesize=1G --bs=8k --rw=randread --ioengine=libaio --runtime=60 --write_iops_log --write_bw_log
> [...]
> # ls
> lost+found  test.1.0  --write_bw_log_iops.log
> 
> If I specify the filenames everything is fine:
> # rm ./--write_bw_log_iops.log
> # fio --name=test --direct=1 --refill_buffers --filesize=1G --bs=8k --rw=randread --ioengine=libaio --runtime=60 --write_iops_log=rr-iops --write_bw_log=rr-bw
> [...]
> # ls
> lost+found  rr-bw_bw.log  rr-iops_iops.log  test.1.0
> 
> I am using fio version fio-2.1.2-13-g3e10.

Don't think there's an easy way to fix this, outside of requiring some
name being set. Arguably that should probably be the way that it functions.

-- 
Jens Axboe

