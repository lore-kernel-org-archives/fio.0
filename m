Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C88C77B7A
	for <fio@archiver.kernel.org>; Thu, 18 May 2023 02:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjERCj5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 17 May 2023 22:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjERCj4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 17 May 2023 22:39:56 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1838A4
        for <fio@vger.kernel.org>; Wed, 17 May 2023 19:39:55 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1aaebed5bd6so11889615ad.1
        for <fio@vger.kernel.org>; Wed, 17 May 2023 19:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684377595; x=1686969595;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kjTElF21c1uHI7Q/sZ5nRQ5cjMl3EXBT2MTVjKc4zvU=;
        b=cehKV+xf7QC17Jk6oQ2eYLjvO0hvZ+2JjFIMokM+258HdyZYCuk3979JIBmVXtfnup
         ++YtXznuYhwokdnmmgnNYGr/UBRxPeJGsi28aLA+PCIMP2Tqj8LrTBJNZlo4PVFOLieL
         a8Gbep07d50NGGNVX0ad/k2VtMD+Wp32utbt/Ef77vtcG3X0rI4nhsldnYK7LyRRHv8E
         g8GTOucdV1nWzyhFL+XOLxC2EMZz18LlHAvOfcT1QqESZM0s+V1U5GnuUi2Bg4q5maAX
         6nK+Q+AuytckhAjyeBSUyBg0MSqgtjc7QXzTuqCquw6xA57nSoX4sEDQ+iPK4IkkMrGV
         TwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684377595; x=1686969595;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kjTElF21c1uHI7Q/sZ5nRQ5cjMl3EXBT2MTVjKc4zvU=;
        b=NJICyp24lrXeEj8mrjXvwQFMX28A7tC5vVuI9QPITClvJFQzIUMe55eX/FAtiYkR4n
         VgD4nZEsQUR77m1ztHvZ3+QzupMjHEWS4QDscvVUQbO8N0FByVZ5R0BJQg0JMdE/BOst
         Z7C5wB6/Vnr2KV0rzZAIPaiAeu4zZ+FkaG6wFkoX7KRme7gB1bay6Bda8PHfrnVie5hs
         55xxgeMw+rhOoKSHfuJ38B+C94RT5ZZktxpRPXj3R/a6lYlDQzoZDXwWiQs7jHhpeNmM
         4OihFkUuPAtshwpQ/fZ3ddIW6zfU1h5TEqZ6qMFCnCOpjovLG09mTIA9OhYup2qa+KwX
         qN1g==
X-Gm-Message-State: AC+VfDyEStoQYOZtXVNwTmvIKYialYVDGroSw4DhMBbZMFBvsQqRlZqY
        Gj+odhSwGkack1kgpXqlRAD4ieRhepDrRhTssQd8IrXbeAA=
X-Google-Smtp-Source: ACHHUZ5Yy+yoMWZhzDICvJmzmwxmD664sf3e7TiAAsDVV2ir/iqtJFtmND/Kw2OnWOwUyONRxqeERoIFiglwz+GU0iQ=
X-Received: by 2002:a17:902:ce8d:b0:1a9:a672:12b8 with SMTP id
 f13-20020a170902ce8d00b001a9a67212b8mr980160plg.68.1684377594911; Wed, 17 May
 2023 19:39:54 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Veentjer <alarmnummer@gmail.com>
Date:   Thu, 18 May 2023 05:39:44 +0300
Message-ID: <CAGuAWdAyy2yaM4mJ-CprFgg1JEOriom5Dv_xE8jH1qURdce9xA@mail.gmail.com>
Subject: Fio sequential I/O request generation
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I'm working on io_uring integration for Java and using Fio to get a
performance baseline. The problem is that Fio is slower than my
benchmark and hence I do not have a proper baseline.

Part of my problem is that I don't understand how sequential I/O
generating works when the io_depth is larger than 1 (I'm testing with
64).

In the first version, I was iterating over the blocks in the file and
sequentially issuing the requests, and keeping the required number of
requests in flight. The problem is that this will lead to many
concurrent and consecutive blocks being scheduled and the Linux I/O
scheduler will merge many. iostat Confirmed that a huge percentage of
requests were merged.

Using iostat I have verified that Fio is not suffering from merged
read-request or write-requests, so I guess Fio is not using the above
approach.

Some other approaches I have tried.

1) Split the file into smaller sections and let each stride access a
portion of the file. E.g. io_level = 64 and a 64 MB file, each stride
gets a 1MB section of the file.

2) Each stride goes over the whole file but starts from a different
position. With 64 io_level, there are 64 different start offsets.

The performance I'm getting is still significantly higher than what
Fio measures so I'm sure that I'm doing something wrong (no apples vs
apples comparison). But the numbers my benchmark measures are
consistent with what iostat is reporting: the bandwidth and IOPS do
match.

I have included the Fio configuration for completeness:

fio --name=sometest --numjobs=1 --filesize=4M --time_based
--runtime=60s --ramp_time=2s --ioengine=io_uring  --direct=1
--verify=0 --bs=4k --iodepth=64 --rw=read --group_reporting=1
--cpus_allowed=1

I'm testing with Direct I/O and using a single thread that is pinned
to core 1 which does sequential reads and I want to keep 64 requests
in flight.

If someone could shine a light on how Fio generates requests for
sequential reads/writes.

Regards,

Peter.
