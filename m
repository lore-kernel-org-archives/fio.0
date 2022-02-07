Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1B9C41535
	for <fio@archiver.kernel.org>; Tue,  8 Feb 2022 01:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbiBHBFR (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 7 Feb 2022 20:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiBGXOo (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 Feb 2022 18:14:44 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBA7C061355
        for <fio@vger.kernel.org>; Mon,  7 Feb 2022 15:14:43 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id a28so5519349qvb.10
        for <fio@vger.kernel.org>; Mon, 07 Feb 2022 15:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=p/O7K3o5IUIeIzYqyHAEwceGS8duRJ4WprbrDhGD8/4=;
        b=G2fwXrldQB7MOBnhLZhze+h6sdFztozK0d+H3URsSPU2Aar+VMGjIe2bA1+aQyzSf9
         X3cFC7JfDycWbUVm8ICx0HWo+EA5Pz4WTWWqkCLC2Ae+dATvJ6SYHHBYlCKtJmWo/w05
         bkKqwcNHLnjdNSjYf4LOHR+GlEKtDLJ2i92irdjX0DbC8ml9zzjbhW3i6iUx8+PJjrwf
         XUWo4hSIRMB9ezSHVnDUdm7dWfXEuoBEzss7N7HISPp2LehxUqaCFNSz1Zmq1gkd3tTy
         kc9S9wrnOPHrqy9IuXCqhG/Kx+4oON4qCGaOvF4GIlvDs4cGvvYG3GE6pYr3IHgp9XJc
         5p0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=p/O7K3o5IUIeIzYqyHAEwceGS8duRJ4WprbrDhGD8/4=;
        b=Q2Re2r7aspPhHXXSHfxs5i6E4x0KZws9015JlwzcuBOxMqbfDWPC2vNX8FSERCB9YZ
         aPpz7XXNFb5koaGZwef3w9Z3TpP8eYJJYh/LYP3Tkvc3dIyTn+7tZ4cXJj/WSjkCiPPQ
         AVUVelmjMJdjy+JuHXkVVTAaD27nE9iUV0HVFSpbnFj5cY2koAs19xuTDcHwIw9D8nYq
         USWOjg2smKv3MAVIkhaoNqF9rWyvBKOAeAtG9YqaiGsw54ajf+6Cqb2uMPBvoelSl+TK
         RA5AvgTabRos4RSVbUpBDZjqJlTJlMkpsH/wIdqCBZ507KrVkXh3x40p/s0LOZIDFTHd
         c7vQ==
X-Gm-Message-State: AOAM530t6/70GbY8aX6VamdfPnVPOE6elXGFjge8j4TlxDw3C9TzG7dt
        1DsrQQW/wyWxLL/7tLOJGwXvtQMaAQzgV9WEBsL8k7pveNpflQ==
X-Google-Smtp-Source: ABdhPJzNXow2MJgv4RkvsCu/5Vtad9fT56QdBQuf/MhbgiRLhs8xkHPU56Lk/oq2N7yrMZnQgfSb/hJEomzrvBwC/Ew=
X-Received: by 2002:a05:6214:29e7:: with SMTP id jv7mr1473941qvb.114.1644275682478;
 Mon, 07 Feb 2022 15:14:42 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Mon, 7 Feb 2022 17:14:30 -0600
Message-ID: <CADqNVTrbc+gtK1PuLLZqaGTTeppXckTP-TFPaRT__iF63+f3Kg@mail.gmail.com>
Subject: Odd (wrong?) behavior with :<nr> suffix on readwrite parameter
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I was playing with this feature today. It seems like a nice feature as
it will allow you to simulate a read or write of a somewhat fragmented
file. From the docs, I can do something like
--rw=randread:8
and expect fio will do 8 I/Os "before getting a new offset". So when
fio does its reads, they will occur at offset1, offset1+block_size,
offset1+block_size*2, ... offset1+block_size*7, and then at a new
random offset2, followed by offset2+block_size, offset2+block_size*2,
etc...

What I'm seeing with this feature though is that using it causes the
first offset chosen to always be 0, and it is used (plus multiples of
block size) for the first 7 (nr-1) I/Os. For example, with this
command:

sudo fio --ioengine=libaio --direct=1 --output-format=json+ --name=job
--filename=/dev/nvme1n1 --size=128MB --rw=randread:8 --iodepth=1
--bs=4K --write_bw_log=fio_0 --log_offset=1

The bandwidth log entries are (fifth column is the offset):

14, 288, 0, 4096, 0, 0
14, 36141, 0, 4096, 4096, 0
14, 34715, 0, 4096, 8192, 0
14, 34406, 0, 4096, 12288, 0
14, 34700, 0, 4096, 16384, 0
14, 27766, 0, 4096, 20480, 0
15, 34633, 0, 4096, 24576, 0
15, 20233, 0, 4096, 8093696, 0
15, 39409, 0, 4096, 8097792, 0

This seems odd, and kinda wrong - the first nr-1 ops do not happen
from a random offset as specified by the randread/randwrite value, but
instead from offset 0. When one does a random I/O operation without
the :<nr> suffix, the first operation is from a random offset, not 0.

I'm happy to find and fix the behavior, but wanted to first make sure
it isn't intentional or that I'm somehow misunderstanding it.
