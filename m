Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131B4C433F5
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 11:14:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7E861039
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 11:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236144AbhJKLQN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 07:16:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28740 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235970AbhJKLQI (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 11 Oct 2021 07:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633950848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PnpfxqAx5ZBl3fnKy32lAl1Jk1/daFqfsFzXCrwbgqs=;
        b=dGXc6f+6n1ZiKNKTruPOJWqhTLGzSQyLDeWwD3vF5LP5NbkIeKX0JW2GEgdEI1GcI1oaWl
        OPaZAJxWOD8JDHLx99rV8QsaPLTcXsPK3nEK1amoKrG8Slk5D3MuOejZZARLXfdvxuDIfk
        7vA2gqvyqh5XhTY7dtEKIGBFXEth0VE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-552-OxrC04REOX6eD1Ngk49HTQ-1; Mon, 11 Oct 2021 07:14:06 -0400
X-MC-Unique: OxrC04REOX6eD1Ngk49HTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E088410A8E02;
        Mon, 11 Oct 2021 11:14:05 +0000 (UTC)
Received: from T590 (ovpn-8-37.pek2.redhat.com [10.72.8.37])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D85610023AE;
        Mon, 11 Oct 2021 11:14:02 +0000 (UTC)
Date:   Mon, 11 Oct 2021 19:13:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <YWQcdTCMIFFdDnMh@T590>
References: <YVdBVdOjPLCayG1k@suse.de>
 <20211010083125.dne6pcjjboixdllo@fedora>
 <YWP/SmhG8TviBE2w@suse.de>
 <YWQEgBQLdD+zsHOZ@T590>
 <YWQO6RdR7oUSNpxN@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWQO6RdR7oUSNpxN@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 11:16:09AM +0100, Luís Henriques wrote:
> On Mon, Oct 11, 2021 at 05:31:44PM +0800, Ming Lei wrote:
> > On Mon, Oct 11, 2021 at 10:09:30AM +0100, Luís Henriques wrote:
> > > On Sun, Oct 10, 2021 at 04:31:25PM +0800, Zorro Lang wrote:
> > > > On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> > > > > Hi!
> > > > > 
> > > > > I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> > > > > Here's what I'm getting:
> > > > > 
> > > > > # cat results/generic/095.out.bad 
> > > > > QA output created by 095
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> > > > > fio: pid=4090, got signal=11
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> > > > > fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> > > > > fio: pid=4086, got signal=11
> > 
> > The issue should be from generic/095 test itself, which run dio with bs=1k,
> > but logical block size is 4k. I guess the test may work after you change
> > bs to 4k in generic/095.
> 
> Ah, I see what you mean.  Ok, I've used the patch bellow and the test now
> passes.  The patch changes the block size only for the DIO jobs, there are
> other jobs where bs=1k is still used.  Do you think other jobs should be
> changed as well?

Only DIO job need aligned bs parameter. 


thanks,
Ming

