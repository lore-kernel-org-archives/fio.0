Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C5B2C433FE
	for <fio@archiver.kernel.org>; Sun, 10 Oct 2021 08:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1989961039
	for <fio@archiver.kernel.org>; Sun, 10 Oct 2021 08:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhJJIdc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 10 Oct 2021 04:33:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231131AbhJJIdb (ORCPT
        <rfc822;fio@vger.kernel.org>); Sun, 10 Oct 2021 04:33:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633854692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wWm6MZEgsIqvR/LGmdBzAuow2ZxRc8S3j2PHzbeom1E=;
        b=Qw39YqL6q5cETCBx4VmGYN0ke1YThXXJz6oXg8fxIFodH0e2Kr0Q5UZfJVv88OWcgaWCr3
        zPvkZ7aEF+L/ab7O2/tqGtCr5BfYLhx1mjzpg3rfWAV0OYR9eyOedDCx4mp4xlw8WhgAQR
        LPVHrIV6wufX0/6TEB2SmHYNMKlKNI0=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-dFzuAXIdPDODFktsEnB5zw-1; Sun, 10 Oct 2021 04:31:31 -0400
X-MC-Unique: dFzuAXIdPDODFktsEnB5zw-1
Received: by mail-pg1-f197.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso5101557pgv.22
        for <fio@vger.kernel.org>; Sun, 10 Oct 2021 01:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=wWm6MZEgsIqvR/LGmdBzAuow2ZxRc8S3j2PHzbeom1E=;
        b=29wWN8r7nlwHMGuY405cqlGD5Y8oIxI1bRMin4e6WOQJUbRT4WdDIQOi2WvWmuIn8o
         W6KUlw+N7Mi/fuqwnMBERU0JO8+0q86rQ6ZI5gHf3yPST778Uo1xJ1AsA33Z5oJTp7Vd
         pq4Kj8fFa87eTjbQ2fj5IW9q7ksoWYc3EeZNGSKZ3n3QIqNCtZrpn/YaRFUD/FMroJrz
         xT9VQZJnSKFZq53suKepZdbQfdK008Jctz7JSCoqwvrYDndpWl1QiSZMD+xmL/ZrxsqN
         KNmtZBP0gROAge+HHn4hlhUVUW6w0CQNY6aUt18Hs3qAG3ZHoREjFMATXqhYvcmXqiIr
         ZoKw==
X-Gm-Message-State: AOAM530E9kjEDrx/8lpvr8HmL3hFQ3smYtSsbi8kxJf73JE2J+I6zY+M
        Dko+FK+SLEH2V/mgPVgS8gqYVziJzfM6rYhHS1vP/dLMFvWHWbcnWMUtsKLP9R4P50lV0JFS2Bn
        yS6u+Iq5NuA/v
X-Received: by 2002:a17:90b:4c4c:: with SMTP id np12mr22668211pjb.205.1633854690240;
        Sun, 10 Oct 2021 01:31:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylVddTVKM9QEike7OQzKOWn6zbeUYL/x8CwGY3KrZpaUXePVUcXZ5G8dw+YawN/BTqCsNjSQ==
X-Received: by 2002:a17:90b:4c4c:: with SMTP id np12mr22668194pjb.205.1633854689960;
        Sun, 10 Oct 2021 01:31:29 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d14sm4018034pfr.123.2021.10.10.01.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 01:31:29 -0700 (PDT)
Date:   Sun, 10 Oct 2021 16:31:25 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Luis Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, fio@vger.kernel.org
Subject: Re: generic/095 failing in ext4 and xfs
Message-ID: <20211010083125.dne6pcjjboixdllo@fedora>
Mail-Followup-To: Luis Henriques <lhenriques@suse.de>,
        fstests@vger.kernel.org, fio@vger.kernel.org
References: <YVdBVdOjPLCayG1k@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YVdBVdOjPLCayG1k@suse.de>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Oct 01, 2021 at 06:11:49PM +0100, Luis Henriques wrote:
> Hi!
> 
> I'm seeing generic/095 failing both with ext4 and xfs (but not on btrfs).
> Here's what I'm getting:
> 
> # cat results/generic/095.out.bad 
> QA output created by 095
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=51200, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=133120, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=92160, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=158720, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=513024, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=33792, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file2: Invalid argument: write offset=449536, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=45056, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=30720, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=222208, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: read offset=342016, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=177152, buflen=1024
> fio: pid=4090, got signal=11
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=43008, buflen=1024
> fio: io_u error on file /tmp/mnt/scratch/file1: Invalid argument: write offset=308224, buflen=1024
> fio: pid=4086, got signal=11

I *guess* it might be caused by a striped storage(fs) of you?

Thanks,
Zorro

> Silence is golden
> 
> This was for ext4 but the output for xfs is similar.  Since fio is getting
> killed I suspect this may be an issue with this tool.  Thus I'm sending
> this to both fio and fstests mailing-lists.
> 
> I'm using a 5.15-rc3 kernel and fio-3.28.  Is anyone else seeing something
> similar?
> 
> Cheers,
> --
> Luís
> 

