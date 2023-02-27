Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AE2C64ED6
	for <fio@archiver.kernel.org>; Mon, 27 Feb 2023 17:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjB0RRZ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 27 Feb 2023 12:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjB0RRY (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 27 Feb 2023 12:17:24 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4037720D1D
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 09:17:23 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id ks17so4918135qvb.6
        for <fio@vger.kernel.org>; Mon, 27 Feb 2023 09:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s5h82CyTUxKs1mzOOIp7elxUogu+25TDEfFZ3kPiS8I=;
        b=mB747DXqUQC2kuJbfLZzYccDpAUfOO6VAstADu3LE2OvMf0GBO3n4k1NriE1yyAUDd
         +PdAhdOB5z6/pNPOxR0v1gZjUBaHXjqq70RVl8x9g3Nugy19ZH9Juq1FAO4QhZF+zMk8
         rcqHVDYPGsKdV2yNrMmOIe2s3dBam9nEEf7UU4gO9De5S1oYPtCcZcY5TMaXwMx3fnb2
         v/dIw1KPyS4btS1NibqRnmP6ovgOFqLIKPQ/AYtp6MxM92YUJyxR8IeAw0T9V9F31Qd1
         CkHoLp7TdaIiO0bykj2LidqWj+z+0SwlGNUft+FYLGAeNPWEZWmugtrnn+HUUwcPFfCg
         mkDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s5h82CyTUxKs1mzOOIp7elxUogu+25TDEfFZ3kPiS8I=;
        b=GCNBj7q2r9XE9W1akli1HedXI2XP5sR6s0CUSIsz5d/Bmqen2CsH4XYxk1G0lkSRxp
         CTS1dOQDEgGUgsPxONJ3YOdmKlRnuXIJ2FGGeYtbFdS0R/gFKyKJgELnvzPhrUdnwPdq
         tRxbrKL1FT31W4ysEqZj0CpZ8tJMeUWV7EofwY0wW9aEQk8phaifz5Ik2DKXQhVdG7Ps
         hi1k9LDaDOMvZGSEK9qmmYfil4sP6sS+pQZnOt5NZbee2XS+fjSnXBsEVQTvq9Wxz2/U
         8f7SwZCMYLOZ4+r5s8+fDfEbQz5FKDB4lSJqWUz87x7p9vofz8JLemlMAll3yG042K+q
         LnFA==
X-Gm-Message-State: AO0yUKUMSlRjeyjXrX9fe71F3QJ3Dbpz+UgJRBy/iZtD4vPHNmB0vYG3
        D1tf0B9pydWtF7sMib6tkXfdEeLvYjxmf54ajvFvxgEqg2K7ng==
X-Google-Smtp-Source: AK7set+f6T6zG/HYNNnXZlMRv2WSxFqhcdEDWqj+XDiyTYZ6MpZNmN9x5S3O/1no/Sl0kNNvAa4bBk3FceiLVFz6NFk=
X-Received: by 2002:a05:6214:14a9:b0:56f:497:ecc9 with SMTP id
 bo9-20020a05621414a900b0056f0497ecc9mr62809qvb.2.1677518242044; Mon, 27 Feb
 2023 09:17:22 -0800 (PST)
MIME-Version: 1.0
From:   lokesh jaliminche <lokesh.jaliminche@gmail.com>
Date:   Mon, 27 Feb 2023 09:17:11 -0800
Message-ID: <CAKJOkCpUwrGbXHF3xnwX_Q_XK7rPekdA+aXLDvZuSMOQKFN4HA@mail.gmail.com>
Subject: thinktime and thinktime_iotime do not work as expected
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

 Hi Everyone,

As mentioned in the readthedocs, thinktime, and thinktime_iotime
 can be used to simulate the IO phase followed by the idle phase
 of the workload. For example, --thinktime_iotime=1s --thinktime=9s
 repeat the 10-second cycle with IOs for 1 second and stall for
 9 seconds. However, in my test for the first 10sec, fio keeps submitting
 without respecting thinktime and thinktime_iotime. After the first 10
 seconds fio starts simulating mentioned IO phases according to parameters.
 Following is my fio script.

[global]
direct=1
runtime=20
time_based
[job_1]
rw=randread
bs=4k
rate_iops=1
numjobs=1
ioengine=libaio
iodepth=1
offset=40G
size=30G
filename=/dev/nvme0n1p2
thinktime_iotime=1s
thinktime=9s
rate_ignore_thinktime=1

Results:
Run status group 0 (all jobs):
READ: bw=2457B/s (2457B/s), 2457B/s-2457B/s (2457B/s-2457B/s),
 io=48.0KiB (49.2kB), run=20001-20001msec

From the results, we can see that the total IO is 48KiB it should be
 ideally 8KiB.

Is this a known issue?

Thanks & Regards,
Lokesh
