Return-Path: <fio-owner@vger.kernel.org>
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50045 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232281AbhHPOvU (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 16 Aug 2021 10:51:20 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F8FA107BEF6
        for <fio@vger.kernel.org>; Mon, 16 Aug 2021 14:50:45 +0000 (UTC)
Date: Mon, 16 Aug 2021 22:50:31 +0800
From: Ming Lei <ming.lei@redhat.com>
Subject: Re: Can't setup io_uring for buffered IO
Message-ID: <YRp7Nx30QAXORcsN@T590>
References: <YRpT0019mbS1jSE4@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRpT0019mbS1jSE4@T590>
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On Mon, Aug 16, 2021 at 08:02:27PM +0800, Ming Lei wrote:
> Hello Guys,
> 
> I tried to use the following script to run buffered io with io_uring,
> but looks it always complains with 'Operation not supported', and any
> idea to make it working?
> 
> ++ /root/git/fio/fio --readonly --name=onessd --filename=/dev/nvme0n1 --filesize=16m --rw=randread --bs=4k --direct=0 --overwrite=0 --numjobs=1 --iodepth=1 --time_based=1 --runtime=1 --ioengine=io_uring --registerfiles --fixedbufs --hipri=1 --gtod_reduce=1 --group_reporting
> onessd: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=io_uring, iodepth=1
> fio-3.25-229-gdf9e8
> Starting 1 process
> fio: io_u error on file /dev/nvme0n1: Operation not supported: read offset=1011712, buflen=4096
> fio: pid=3278, err=95/file:io_u.c:1841, func=io_u error, error=Operation not supported
> 
> onessd: (groupid=0, jobs=1): err=95 (file:io_u.c:1841, func=io_u error, error=Operation not supported): pid=3278: Mon Aug 16 12:01:17 2021

Just figured out that --hipri can't be applied for buffered IO.

-- 
Ming


