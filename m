Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF81C433F5
	for <fio@archiver.kernel.org>; Wed, 24 Nov 2021 16:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbhKXQEs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Nov 2021 11:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhKXQEs (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Nov 2021 11:04:48 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27CEC061574
        for <fio@vger.kernel.org>; Wed, 24 Nov 2021 08:01:38 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id l8so2975764ilv.3
        for <fio@vger.kernel.org>; Wed, 24 Nov 2021 08:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=2hyD4jGELvEiyfVlGEASuQm0zW9dKcwCIHxuQaKmavc=;
        b=jX2MdSb3stJqr03KiZ37b30jtMGhg48n+VlF2xaOhfrbwssE5/CwRfc0z9cNxa96y5
         z26aKDXeWqaBO29cNrlFsK/tA1R2z7s1YwoUbHiK71sRcMoKi8OaIK/s3FDKULRK/8wn
         1imeeNFBBlOQaIAbriJ4TDBSlxKA772a0CsdNu7dy8N7MwvnWU3Ddam69IyAQ3ERgEKk
         W/wuKP1EsZkfn4ICOeWO+3dCaBvnR/sJjJHsRgUCBTte0WFDDtCsppIyGC6EwzrqNbNQ
         YPwvTiHEDrdRIg46KDHk02jkH693nKdHzQ0GztSHopDD8uTS0D+RotDwZBOVObLMO71y
         IT4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2hyD4jGELvEiyfVlGEASuQm0zW9dKcwCIHxuQaKmavc=;
        b=Mbb6boFcA3monkde/+nYp5x7Q7RZ8osa7O1AQ5YvxWCylnkY5YhciGjZKxTSBqw+rM
         uod6wcC9l9tu9UY0wmcpV0hv8FmC3cV6yfOR4vndPIohKLciSxnjiBTSWR09Fh22sdm7
         FtOTKcpi03khMBnwlGJIAMrwTJHVx2zY2y0UNLnXVIsD4eIzUEYrRTfhHHrZ9LbNPSoc
         3NSZ9XYGB/CoAeaJIMyoNj4rzAgVKLTn1fDQdQ7WmalX/FW61Cfn/3ScVGBujpy1nz1c
         NEyHLMA9rNRrhD25CNMwgxJt8bNrHdjLG+rsfNuYCyfxQAW26VzfgQMhAtTtwMqgc2AL
         NTpQ==
X-Gm-Message-State: AOAM532dSc2lG87MhFsOezRCd7ylZwVfF9W9QDUwo7I2TCValBhsTBw9
        tT4q68GwGLZsP6GKEsivAT7UVWfHE85DKeL3/lgPLm9W6hlaJo1qyuI=
X-Google-Smtp-Source: ABdhPJwnVOuTvp9seLZpCzA5V50NdHbB/CPrrYqd2OoYBxVfc0YtethwwU4HNPgSKR+7p2tez69KxgKVsLg32f589m0=
X-Received: by 2002:a92:50a:: with SMTP id q10mr4011612ile.23.1637769697881;
 Wed, 24 Nov 2021 08:01:37 -0800 (PST)
MIME-Version: 1.0
From:   Seyed Mohammad Fakhraie <fk.smoh@gmail.com>
Date:   Wed, 24 Nov 2021 19:31:26 +0330
Message-ID: <CACzyWQx0YZgwyJLRzBESL-8EoLzWzyFrqWMsVb0hs1Z-K7TMSA@mail.gmail.com>
Subject: Using FIO to benchmark Gluster
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello people,
I am trying to benchmark Gluster with FIO. I am getting the following error:

4vm-1G-randrw: (g=0): rw=randrw, bs=(R) 4096B-4096B, (W) 4096B-4096B,
(T) 4096B-4096B, ioengine=gfapi, iodepth=4
...
fio-3.12
Starting 4 processes
failed fio extend file 4vm-1G-randrw.1.0 to 18446744073709551615
failed fio extend file 4vm-1G-randrw.3.0 to 18446744073709551615
failed fio extend file 4vm-1G-randrw.0.0 to 18446744073709551615
failed fio extend file 4vm-1G-randrw.2.0 to 18446744073709551615
Jobs: 4 (f=0): [f(4)][-.-%][eta 00m:00s]

Run status group 0 (all jobs)

Any help for debugging this issue is much appreciated. My FIO version
is "fio-3.28-104-gf7c3f".
