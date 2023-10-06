Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33693E94107
	for <fio@archiver.kernel.org>; Fri,  6 Oct 2023 19:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbjJFTxC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 6 Oct 2023 15:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjJFTxB (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 6 Oct 2023 15:53:01 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B937B8F
        for <fio@vger.kernel.org>; Fri,  6 Oct 2023 12:53:00 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-53b38d1ac36so1563286a12.2
        for <fio@vger.kernel.org>; Fri, 06 Oct 2023 12:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696621979; x=1697226779; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oZR3EJTprWFHevn9wMh684ewJScPFSKLtZqeZS4VfZY=;
        b=buMlK959FlX0awRYKBixKCGx+TySZkm2GRJ2JbLsQHjCZH4/aYc+gnn4d9O3CSHZQC
         9itC2akjTKKJwnDBaaEdxPqHvhhnQjBQ7IufL+VlszfAm+qWN1Te52VvS/qaKMyyeiPu
         K/UkquJkFlSsq2ZEJojy31EQUQje3oVnvYTmApN8WRDlB+PHyGrzuHxqong0+0ehLdE8
         rfSJRL99nAzzNyfCxEeb57UA7rGCCfWGowmJ6w5FFOUguxnKw94t6htLosfI0MnzzdMq
         A7F/zJFSr+D9QxPhAY9PodqoymtnHZHV7Z5C58dE7GHpZr0+Qdm+E0vXQz3N3maoIdRW
         wcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696621979; x=1697226779;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZR3EJTprWFHevn9wMh684ewJScPFSKLtZqeZS4VfZY=;
        b=ugjjWhXRUPzLaN3wBn3qEOEKWAN9CVLjKQkcEiZg7DKusQiY6Q1fNlTbg3Jgz7TgmK
         CFYnUq3r6v5nbvEcOkjJ7QT0g72K2QSpZ7INQLbr+5ivfRC1xbTZvlI2XoxDctTUAGqU
         KpZ/AVouipJugJU5Pites6HFTRQFADPdiDy+uVTj6kPmEJ8UjUsUBbR82KbOmiLobXJN
         CPiJTBpXoC3bR6Yx0yYcmK2FGCsA91ijGSoGUIDuTbtkEO3qMaqLquO9Zil/KKuF/XWf
         +vQfC1G23KZuwI4cbZ7haXsH6uHTo0mTKQkIUQdacalTzXLQqW6WKWXyLG9wSeiYIS1Y
         rHcg==
X-Gm-Message-State: AOJu0YxAvzn2LD0Zvr9Ul9m82Jw4lVOtz3FhJz//QMwK//DoDqSYmvM4
        p94hZfWe3b7cbrCd+Y7MGSuwiW79SBFruePBg0ZkQmQobXw=
X-Google-Smtp-Source: AGHT+IF0YtaY1vxCMH2ABvPGBO9Ta2k8+n6LZiJf8ZeArxrq34oVNakfrPIDFsYwvQq2e6MKS0EZ4zEQLvOGHOmes4g=
X-Received: by 2002:a05:6402:1843:b0:522:580f:8c75 with SMTP id
 v3-20020a056402184300b00522580f8c75mr7419062edy.17.1696621978856; Fri, 06 Oct
 2023 12:52:58 -0700 (PDT)
MIME-Version: 1.0
From:   Matthew Eaton <m.eaton82@gmail.com>
Date:   Fri, 6 Oct 2023 12:52:47 -0700
Message-ID: <CAF+0mvm8bw-wvnSv8SUm=6f+T+zSMd-uXm2weefGyONqL+qq=g@mail.gmail.com>
Subject: trim entries leaked?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi fio group,

I'm trying to get a workload doing concurrent writes, verifies, and/or
trims. I've narrowed down my job file to this:

[verify]
ioengine=psync
direct=1
size=5g
bs=4k
rw=randwrite
numjobs=1
iodepth=1
verify=crc32c
verify_backlog=1
trim_percentage=50
trim_backlog=1
filename=/dev/nvme0n1

With this job writes are read/verified but there are no trims. If I
set backlogs to 0 I get this message before the verification phase:

fio: 654981 trim entries leaked?

I'm using the latest fio as of today, fio-3.35-134-g6f9c.
