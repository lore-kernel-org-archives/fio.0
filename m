Return-Path: <fio-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34586 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758757Ab1FAKqR (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 1 Jun 2011 06:46:17 -0400
Message-ID: <4DE61875.4070501@fusionio.com>
Date: Wed, 1 Jun 2011 12:46:13 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Unaligned AIO/DIO
References: <4DE531D0.40600@arvin.dk>
In-Reply-To: <4DE531D0.40600@arvin.dk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Troels Arvin <troels@arvin.dk>
Cc: fio@vger.kernel.org

On 2011-05-31 20:22, Troels Arvin wrote:
> Hello,
> 
> Running fio 1.55 on RHEL 6.1 x86_64 with a multipath FC storage backend on an EXT4 file system.
> 
> Some minutes after starting fio, I see the following in syslog:
> kernel: EXT4-fs (dm-28): Unaligned AIO/DIO on inode 4063238 by fio; performance will be poor.
> 
> Should I be worried? Is there something wrong with my storage layout?
> Or am I using fio in strange way?
> 
> My job file:
> 
> [changed-from-iometer-file-access-server]
> bssplit=512/10:1k/5:2k/5:4k/60:8k/2:16k/4:32k/4:64k/10
> rw=randrw
> rwmixread=70
> direct=1
> size=10g
> ioengine=libaio
> iodepth=256
> write_bw_log
> write_lat_log
> numjobs=6

Do you have the RHEL6.1 kernel sources handy? That message is not in the
upstream kernel. Unaligned could be memory, or it could be offset/size.
In general O_DIRECT does not work for unaligned IO. Perhaps it's
referring to writes that aren't stripe aligned, but that seems fairly
expected and something dm should handle.

So to render an opinion on this, I'd need to see a copy of the file that
prints that message :-)

-- 
Jens Axboe

