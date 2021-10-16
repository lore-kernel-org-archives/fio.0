Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9671CC433EF
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 23:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB7E60240
	for <fio@archiver.kernel.org>; Sat, 16 Oct 2021 23:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhJPXFa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 16 Oct 2021 19:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235593AbhJPXFa (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 16 Oct 2021 19:05:30 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57619C061765
        for <fio@vger.kernel.org>; Sat, 16 Oct 2021 16:03:21 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id l7so12083856qkk.0
        for <fio@vger.kernel.org>; Sat, 16 Oct 2021 16:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=j+HUIKFgr1d0hgv1MLUKHrqPeuNZfQ+HP2OqhupTAhE=;
        b=SvOa9nBVeiul9lB981AjJYNFUmhG1R7LPAWbkG53UVSqkyWhc0ANKhFmo+rkYGDnW5
         4yXnXWGn2f1jBEDjBxkhFqJivwzLHgId8lSCRsu5VZqXW9m9/1odZIdZo3Xk3b5HQz1c
         1D8/YxYreBRfDCcQHcXFluvthts4gbxQD4rfYnV3H5e51vXJ2a1rdUmsaroHf0tjVAGh
         zKCGRC/AUhI9y9zHXMhnIW73v4cIrTRQFyPA7xCfRulBaUEyoIFsYbc0n6/yF3av7PHC
         +XS0YWh/DYzewSDVsPVutd6Jghv9sU/KmWeJwTMyqnXmzs9j3RgdHBoalDLYA3hzf05n
         bc3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=j+HUIKFgr1d0hgv1MLUKHrqPeuNZfQ+HP2OqhupTAhE=;
        b=lTmLwf5NTfA+8+Gg7JdytiKB1iDofdJUWAF6XYuGXlFYqcfbis+lniNQJCqh5/B6gJ
         2ixkkcJ3m0hGtGWmM7px26/vEEM5de2M7TM6gBJtaxea7++agrJlLUMKxVumcZSc77+n
         AUxGjfIWgTGgNggMIlO0Mi7ZROpq7QMPSZmlnS60WM30ipESOSnwq5nPr2fcGuwGRvaQ
         pG/p/zPUhEsYnKasSr0+4rx+9Xi/W+lNoXEt/ekA1GrkR+lr0394qxbYoMd3s+06jHJ5
         1NU0PzQOnkoEVyWknzx0SegOSQn/M4YvvMfg4sh0GdFkSbx667VsH7ZawR/w4RIxw/Cs
         ba9Q==
X-Gm-Message-State: AOAM532e8HMF5CCFudU2u4KwIOWl1TaWENyIEJmcfUC6lI4vSWH7QyHV
        IbkassoOi3tNS+et85zb3MMZd6zoZ9M=
X-Google-Smtp-Source: ABdhPJxViXHg1+cOkmVE47bwet8xMo+Icj37GfjDKmFl1qe6wpnoO4sVmx2lSA6bpVYx4M/LBV2W1Q==
X-Received: by 2002:ae9:d842:: with SMTP id u63mr16603311qkf.44.1634425399970;
        Sat, 16 Oct 2021 16:03:19 -0700 (PDT)
Received: from smtpclient.apple ([149.20.200.35])
        by smtp.gmail.com with ESMTPSA id 74sm4466044qke.109.2021.10.16.16.03.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:03:19 -0700 (PDT)
From:   Michael Green <mishagreen@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Building FIO 3.28 with libcufile support
Message-Id: <CF0FF607-185F-4D7C-87CA-D7BC8A8D0BA4@gmail.com>
Date:   Sat, 16 Oct 2021 19:03:18 -0400
To:     fio <fio@vger.kernel.org>, info@systemfabricworks.com
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello collective wisdom,

I'm trying to build FIO with GPU Direct support.
My system is a NVIDIA DGX-A100 with CUDA 11.4 and GDS 1.0.2

This is how I'm trying to configure and how it fails. Any ideas what I =
am doing wrong?

export LDFLAGS=3D"-L/usr/local/cuda-11.4/lib64"
./configure --enable-libcufile --enable-cuda =
--extra-cflags=3D"-I/usr/local/cuda-11.4/include =
-I/usr/local/cuda-11.4/lib64"


config.log shows

Compiling test case cuda
gcc -D_GNU_SOURCE -include config-host.h -I/usr/local/cuda-11.4/include =
-I/usr/local/cuda-11.4/lib64 -Werror-implicit-function-declaration -o =
/tmp/fio-conf--1279005-.exe /tmp/fio-conf--1279005-.c =
-L/usr/local/cuda-11.4/lib64 -lcuda -lrt -lz -lpthread
Compiling test case libcufile
gcc -D_GNU_SOURCE -include config-host.h -I/usr/local/cuda-11.4/include =
-I/usr/local/cuda-11.4/lib64 -Werror-implicit-function-declaration -o =
/tmp/fio-conf--1279005-.exe /tmp/fio-conf--1279005-.c =
-L/usr/local/cuda-11.4/lib64 -lcuda -lcudart -lcufile -lcuda -lrt -lz =
-lpthread
/usr/bin/ld: /usr/local/cuda-11.4/lib64/libcufile.so: undefined =
reference to `dlopen'
/usr/bin/ld: /usr/local/cuda-11.4/lib64/libcufile.so: undefined =
reference to `dlclose'
/usr/bin/ld: /usr/local/cuda-11.4/lib64/libcufile.so: undefined =
reference to `dlerror'
/usr/bin/ld: /usr/local/cuda-11.4/lib64/libcufile.so: undefined =
reference to `dlsym'
collect2: error: ld returned 1 exit status

--
Thanks,
Michael=
