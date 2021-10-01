Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 068D5C433EF
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 17:11:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCF8661A02
	for <fio@archiver.kernel.org>; Fri,  1 Oct 2021 17:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhJARNh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:13:37 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53504 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbhJARNg (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 1 Oct 2021 13:13:36 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4DF292006B;
        Fri,  1 Oct 2021 17:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1633108311; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VctBODUHbFQB1Sc2cd5LyFurOFpUoXLnR72mYi2P/5c=;
        b=QbbtV/H8AtuB8tY2pr3WwYgbheB3RXD21+QNatQf1nFmZTowSIg8qECyrRmC6hQKQpQEW1
        gx049amGXAMm01AEZ6LnSkZblwfAi1OooMSxcwv7hphxquo06++39TU1WABe7e2lZheHa8
        a44EtrbKDWqGGQYo4cIDJElsWb+lEe4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1633108311;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VctBODUHbFQB1Sc2cd5LyFurOFpUoXLnR72mYi2P/5c=;
        b=wKNHQ2XvIILnku1KouVQZBtALh9g6iUOZCowhgYNxk1dbEn7zdhvuQGPvpge4PyPcAqap7
        3MU5iyZxL69JUTDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1021513BC1;
        Fri,  1 Oct 2021 17:11:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lz5TAFdBV2FMeQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 01 Oct 2021 17:11:50 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 8f79f75e;
        Fri, 1 Oct 2021 17:11:50 +0000 (UTC)
Date:   Fri, 1 Oct 2021 18:11:49 +0100
From:   Luis Henriques <lhenriques@suse.de>
To:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: generic/095 failing in ext4 and xfs
Message-ID: <YVdBVdOjPLCayG1k@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi!

I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
Here's what I'm getting:

# cat results/generic/095.out.bad 
QA output created by 095
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
fio: pid=4090, got signal=11
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
fio: pid=4086, got signal=11
Silence is golden

This was for ext4 but the output for xfs is similar.  Since fio is getting
killed I suspect this may be an issue with this tool.  Thus I'm sending
this to both fio and fstests mailing-lists.

I'm using a 5.15-rc3 kernel and fio-3.28.  Is anyone else seeing something
similar?

Cheers,
--
Luís
