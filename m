Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22D8C4332F
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 17:15:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF302610EA
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 17:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbhJMRRM (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 13:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbhJMRRK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 13:17:10 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 481DEC061760
        for <fio@vger.kernel.org>; Wed, 13 Oct 2021 10:15:06 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id u32so8092495ybd.9
        for <fio@vger.kernel.org>; Wed, 13 Oct 2021 10:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=utexas-edu.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=0m00QGUi7C/HeKFYEy6t7+RB9xp1NswrS2v/TTGrWt8=;
        b=uN6yQmeYqjMRDpypnrsXb7j4x+aS199oSoENcWmxq0/7V62mhFG3FHfXmfEfgeUxR5
         L3oitXYkyYpYvrTQwb2Y8GqEoQLmutwSXkH9aZ93XaEFzYz2qxYa2C3LjTrGADXdp9en
         M5cvzSga6MQ1OQ/oHt0MiosuMorE6tpZEFJYuNP2XenR/05JKgL4VWiYV+0OYtmyt6l4
         NUmhteo/W0pXoqRdeFvjBv/ANdGz3sUxzPO1SpyzT8E//rw28Zfckw1F56zEBwCqTFDU
         rfKFAgmLoAFnFQ4dV8HBsRKpR5956fXNfW5rEcaid6InzfUQM52Ubd7/ZcZj+8R3H+KS
         PTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0m00QGUi7C/HeKFYEy6t7+RB9xp1NswrS2v/TTGrWt8=;
        b=t75GulLe2pKzaSk/6jgDSvEoYuWL4yB7/s8mtrh7UKrFiTd2/IxBdRa6kn7g3lntfN
         Ow9mC6Nr1HGLkllugg++6UdN3CmXeb6nC+kEqnNh3PwY5VcrbR4vQPfKjg6M/yHyNpde
         Plf4elV1aMw2Mcih1qgPMrVQpjMBwAGglrr54mbDfzviDvYnFIUJytb6EhgKZQ3aPLzx
         JeR+sTmloPm07fi+yeMCg9Y4+K9U/nxTW8smqRdqkTOdtEe24gCZmdrmY39MvxFaF1TR
         2oCR/gDmCvDpsDPw2l2lqJpYhXwHgQ92cDAwP4iWK0/hRxCSR68QTRHePGU2EIQuUjqr
         27dA==
X-Gm-Message-State: AOAM531d2Y8bqJO7IZ9k6/k9H3NLdgzbv4C7uIrokjrLhFfa0qRXZCN8
        M2KEoNdMMgfXKEkb2uQ3DlWeVNJPtqd3So/zav1Z1XeOPqGeWcaX
X-Google-Smtp-Source: ABdhPJxdlitORDMxyuxKypM9B4RGlsn2CMF0lcXSkbc7PTxegwH6Vl/ST1Id0V2CHNA2p5zPSikXJVmtEakvrAFssLk=
X-Received: by 2002:a25:6106:: with SMTP id v6mr574012ybb.531.1634145305433;
 Wed, 13 Oct 2021 10:15:05 -0700 (PDT)
MIME-Version: 1.0
From:   Nobel Truong <nobelt@utexas.edu>
Date:   Wed, 13 Oct 2021 10:14:55 -0700
Message-ID: <CABxiyTjCUGkuAqz_+v_8rP9ORV5ZgjARU_ZWfQ-4DzbUgtr_ew@mail.gmail.com>
Subject: Unique block count
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hi,

I am looking to count the number of unique blocks written by fio.
Could you advise on the best approach to do this? Is it possible?

I see that one approach might be to set random_generator to lfsr,
which guarantees that no offset will be generated twice. If this
guarantee holds, then I could calculate the number of blocks by the
io_bytes reported at the end of the fio job.

> LFSR guarantees that we never generate the same offset twice, and it's also less computationally expensive.

Older docs also mention that the 'block number' is stored in the
header information. I'm not sure what this would be in the header
struct, because the closes I found as verify_header>numberio, but that
seems to just be the I/O issuance number?

> meta
> Write extra information about each I/O (timestamp, block number, etc.). The block number is verified. See verify_pattern as well.

Thanks!
