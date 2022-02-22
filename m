Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E4DC433F5
	for <fio@archiver.kernel.org>; Tue, 22 Feb 2022 01:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiBVBcg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Feb 2022 20:32:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiBVBcf (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Feb 2022 20:32:35 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF91C24F19
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 17:32:10 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id w4so19473789vsq.1
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 17:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=OGmQOoTRCkc8ncitTAyhvfnB3ls0gPrL162qFTaXaCY=;
        b=pSdpcI5St1//jr8Da94D3umJeJqgZ/7ijuGFgDnqPe3Fzp3di1zss6vwIb1rm/tEft
         +fWhXNQ7yoLYfbox4pqqGtfHbGJaQ8QL/vgXciFTTIzPLOahNjGKVN628IXKz8HGeKPS
         88gtwiqKJgajyBL76Alaymvh3FkDAasajcYfTgBgRB3vJ+wrrI1MZtshSmXp0a91gTyf
         LR9lhzQ6NY2YuAdVsinMz9j/UCSZK2N1Nrn8JmJWoSvDLvml8vU0HuBSzMMW71qGqvzg
         ihSHB/L6J4sbW7ulPMVXttMxw3s2273r/jJ69y58uBD1pFnh85/XqY/8cQPraET7aiIF
         E/nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OGmQOoTRCkc8ncitTAyhvfnB3ls0gPrL162qFTaXaCY=;
        b=DoeP9QJuMBxuX16uXWePE7n2YOYSzhGkKav1qepq1VtYugzUgTgrxgYuGKMqohl7qM
         aiOryF1DbQFxEHeSloZDMcmUT6s7a+mAt7d0Z/hydl2ogfonY0Wp6Z4RiBmhtCriLWYC
         PhudeHUsTzmhXG70LUweRL2lTtQL+WM6ZPb/aq2UEKbs5GlLWrbtN7aoQCsYOr06JzAv
         ozAiXygwrrr7EZq0/FC+86hzcofLD/9Sbgfze9sg2faOJL+ysSi6j5zAnCQ6MFEMIYiC
         cwbMZt07g8vI/1o7wo4FFj+Zkv5mH7ADQwG8evbrUbNuhW3PZsidIULBWom8HQelaAVQ
         /5eQ==
X-Gm-Message-State: AOAM530Fq3xuXjbQcRXe1WxectK0PzHW7lDmx/nrY+erhoM+bfNp+bwv
        cP0/1NinoMi2auFCRkQZDfopSXnqJf3d0BvwK99gcJz49p0=
X-Google-Smtp-Source: ABdhPJxOUHPZ1j63PyfEC/I4Kxuym56jnFhsugb8GRPMbwtdugYchbh07ItWK/0uM2krJf2pmX7P3//DElR7kV9xmeI=
X-Received: by 2002:a67:b846:0:b0:31b:9365:b799 with SMTP id
 o6-20020a67b846000000b0031b9365b799mr8424806vsh.51.1645493529952; Mon, 21 Feb
 2022 17:32:09 -0800 (PST)
MIME-Version: 1.0
From:   Lam Nguyen <lamnguyen3801@gmail.com>
Date:   Mon, 21 Feb 2022 20:31:59 -0500
Message-ID: <CAPWcSwsemZfOGYwM=6BgPJXmfzDPtNxuS8DFZb8mSZcSttpDMg@mail.gmail.com>
Subject: Looking for assistance on FIO. verify job fail with error=Permission denied
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,
I'm running FIO job on Windows instances by running python scripts
using subprocess.Popen.

& $Env:ProgramFiles\fio\fio.exe
--output=verify_vol-0d0e9b90be2a4cb35_ev_writes.out --direct=1
--ioengine=windowsaio --filename=\\.\PHYSICALDRIVE3 --iodepth=32
--verify=crc32c --rw=randwrite --verify_dump=1 --verify_fatal=1
--randseed=6918 --do_ver
ify=1 --name=vol-0d0e9b90be2a4cb35_ev_writes --bsrange=4k-128k
--verify_pattern=0xFF --norandommap=1 --replay_no_stall=1
--read_iolog=read_vol-0d0e9b90be2a4cb35_ev_writes.iolog

observe the following error: windowsaio: failed to flush file buffers
func=td_io_queue, error=Permission denied

I have also tried to run the command with Start-Process on the
instance, but I still get the same error.

Can you please help me troubleshoot the issue below?
Thanks in advance!
