Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8F3C433F5
	for <fio@archiver.kernel.org>; Thu, 10 Mar 2022 19:48:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242669AbiCJTs7 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 10 Mar 2022 14:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241948AbiCJTs6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 10 Mar 2022 14:48:58 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B923E44A4
        for <fio@vger.kernel.org>; Thu, 10 Mar 2022 11:47:56 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id g8so1764760qke.2
        for <fio@vger.kernel.org>; Thu, 10 Mar 2022 11:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pcpartpicker.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=SP7BL6njVvvFJAvWVJ99juzO+SDTiGa4lGMy4nuWpK4=;
        b=pVUyIk6x73gsf7T1qVr1HngjpSCLFaLyGrSmRu8+WfA6+mKnZIhvioe53BjhjwKwj+
         RIWOO7dyYu7qVmJdfEqdmzp2EGt3hU7OD7ZyuoWseaPxUBL+8/KWRM3B9hOTWLZsdG42
         j6efclV2ZVJ5ZKwBh4UBHk25yQRMrJoKgBBIY0YS8v4iHk0Zu4kuq+xnEwh6IjMEBEv1
         OvRadDqKC/EfJcNTFb9AkygR7P6/dKc/59N5WG433xFtg63+d/fgTWQE6VRRppznj+lq
         6RCJxZ/AgoKHQCjnc5UAOatBRegy3mBsiWvvJjs+qpEJrKZXvT1zRbtNJrtkL4u8I7qc
         9GVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SP7BL6njVvvFJAvWVJ99juzO+SDTiGa4lGMy4nuWpK4=;
        b=KFXYa9uQOIZsA0pYHBaWmbeY87s1OCt6T+QteTVgppCxiVxeSjnJE7cPaQhBoavT4d
         5ANYQU0akWA91O16BHk1xkgeTyY+8eoRHGoU6MB/9wkBRn+snw8XuOI4Eua3rCzLtiKt
         qmLu6B00UcJQUBVvH6DpbsRGKo6/xyrRmR8vRkCPyaHnZ8nBVX/+8+3XNBqd1I2pHXbo
         Q0GdnW1PHnLBtqDMr7ie+aecP2KBGwfBdYT3rt+oz/HMq/EMppfZcf4ZNqoKQoTNJ6jv
         9WzHMIx8SV93RgajB4UR0hDguIyQTJkU/HKKLyjkK3rVnZ5pNYexqXnU8zRDJoQnksGY
         Xl1w==
X-Gm-Message-State: AOAM530qnDTMrI7I0MV2O02AyB2rNNb0XD/G1NXT48NT/NRFQY309PFl
        c+azAAM7627V5otGnrDJORfe9gJ8pHe4hdFqf6472+FcPMnNMg==
X-Google-Smtp-Source: ABdhPJzQjrCIExBMu39kPBOKOmqBhWODGpHF9VE61SFaGesQCc/bfpfRcK8ir6LnW14cOO0diUDSIE3aT5CYh8oKceU=
X-Received: by 2002:a37:64a:0:b0:67d:430e:2a20 with SMTP id
 71-20020a37064a000000b0067d430e2a20mr4221490qkg.265.1646941675174; Thu, 10
 Mar 2022 11:47:55 -0800 (PST)
MIME-Version: 1.0
From:   Nick Neumann <nick@pcpartpicker.com>
Date:   Thu, 10 Mar 2022 13:47:43 -0600
Message-ID: <CADqNVToftFmBMWRNRfp_N2k-+wicyfAOfS8vSy+x77LDjj0-uw@mail.gmail.com>
Subject: Logging and its significant impacts on performance
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I had switched to doing per_unit (every sample) logging recently in
order to work around some issues I was hitting with using
--log_avg_msec.

After looking at my results, I could see a significant decrease in
maximum and average bandwidth during runs. So I started playing with
disabling other aspects of logging and was really surprised by the
effect, running a 60 second random write test after an nvme format and
10 minutes of idle. I repeated the experiment many times to make sure
it wasn't just noise.

With a 970 Evo 1TB, I saw the following results:
--log_avg_msec=100, all latency/latency percentile options disabled:
max bandwidth 1.04GB/s, avg for run 0.99GB/s
--log_avg_msec=100, all latency/latency percentile options enabled:
max bandwidth 1.00GB/s, avg for run 0.94GB/s
no log_avg_msec, all latency/latency percentile options enabled:
max bandwidth 0.95GB/s, avg for run 0.91GB/s

Between the best and worst performance is on the order of 100MB/s of
bandwidth. Is this surprising at all, or expected with fio?
