Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 073DFC433FE
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E345360EB4
	for <fio@archiver.kernel.org>; Mon, 11 Oct 2021 13:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhJKNqW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 11 Oct 2021 09:46:22 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44442 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234661AbhJKNqV (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 11 Oct 2021 09:46:21 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 84DD722099;
        Mon, 11 Oct 2021 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633959860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Ei1TMdsj4bdCC7d92ByOANv7ITTL+BPtkpOgORd26Q=;
        b=H0v3xfj+mr/k6YpmWtzRDtS8vT+cbWJ5140e5HCE+I1XlGfcBIZaKt24aeulDoKhLD7eny
        6aIMK6FTkmEis6PUo3Ue4ldOEhmT+kJyXcbloUKPy75gbfXegkd5KDxt9bVcj7uMeSmaV9
        wM2oaodMl5gvLENJPoB/Mib7jbu+MrY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633959860;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Ei1TMdsj4bdCC7d92ByOANv7ITTL+BPtkpOgORd26Q=;
        b=v0VLVB+8uA9I5ICfMyyAVDnQBLnhsSVH51kHwWbRHYkFLwwc82ytYd3LBtehhJqcj8Mi6c
        gpVh2WAqF+c5KIBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 433B313C5E;
        Mon, 11 Oct 2021 13:44:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0oV4DbQ/ZGGFHwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Mon, 11 Oct 2021 13:44:20 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 56bef880;
        Mon, 11 Oct 2021 13:44:19 +0000 (UTC)
Date:   Mon, 11 Oct 2021 14:44:19 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org
Subject: Re: [PATCH] fio: make sure io_u->file isn't NULL before using it
Message-ID: <YWQ/s44zyPC/ULBi@suse.de>
References: <6f867fa0-c3e9-6f65-d97f-4779c029ef81@kernel.dk>
 <20211011102739.10429-1-lhenriques@suse.de>
 <42aee776-323c-634f-d950-9792de7724d2@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42aee776-323c-634f-d950-9792de7724d2@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Oct 11, 2021 at 06:58:52AM -0600, Jens Axboe wrote:
> On 10/11/21 4:27 AM, Luís Henriques wrote:
> > While running fstests generic/095 against ext4 on a zram device I started
> > seeing fio crashing.  Fix it by making sure io_u->file isn't NULL before
> > accessing it.
> > 
> > Signed-off-by: Luís Henriques <lhenriques@suse.de>
> > ---
> >  io_u.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/io_u.c b/io_u.c
> > index 5289b5d1d9c6..b8e715d4118c 100644
> > --- a/io_u.c
> > +++ b/io_u.c
> > @@ -2009,7 +2009,8 @@ static void io_completed(struct thread_data *td, struct io_u **io_u_ptr,
> >  			io_u->xfer_buf += bytes;
> >  			io_u->offset += bytes;
> >  			td->ts.short_io_u[io_u->ddir]++;
> > -			if (io_u->offset < io_u->file->real_file_size) {
> > +			if (io_u->file &&
> > +			    (io_u->offset < io_u->file->real_file_size)) {
> >  				requeue_io_u(td, io_u_ptr);
> >  				return;
> >  			}
> 
> This will prevent the crash, but I'm wondering why io_u-> == NULL for this case.
> It really should be a valid file.
> 
> Can you let me know exactly how you're reproducing this? Then I'll give it
> a whirl too.

Sure, here's my recipe for reproducing this bug:

 # modprobe zram num_devices=2
 # echo 1G > /sys/block/zram0/disksize 
 # echo 1G > /sys/block/zram1/disksize 
 # mkfs.ext4 /dev/zram0
 # mkfs.ext4 /dev/zram1

 # ./check generic/095

Cheers,
--
Luís
