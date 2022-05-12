Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 521A0C433EF
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 12:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243107AbiELM0i (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 08:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353944AbiELM0P (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 08:26:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A82BB38
        for <fio@vger.kernel.org>; Thu, 12 May 2022 05:26:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id m12so4717303plb.4
        for <fio@vger.kernel.org>; Thu, 12 May 2022 05:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=2tyxlJPD6Kc/LaH6oJDeyfbWKPvRXucj2kVFNg2jPaU=;
        b=jetX7b7DcX9rRF2flF1utQ+Lfdmfx2KaibCjMQbFqab3OKDHxLbx7Nl7uZ+Txr224J
         8U+3vs1KTj16p0lBDfcZefcSr63K0xjF23IaCVVFTP2fq8gUArOPk3Kl7z48j+0UpVBw
         EFhskuK0nQCj05Y4snKltwkJvOLruYUXN0MPQdj0/uFmaMcC/M4eS2ZgT0Y7BSWFZ7rX
         MkGNqukShortMspV/LKapjZPqvi7aFexBh0EadtwcqYKSWGXRqPL8eyFlKksTPr7ymoB
         Ee/aJDJlrce7U6JsrFNT30odMDC5bpoRNYKZZk7WYtzF+qyqlMx2mGZES4OWd4a/U8Aa
         QqQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2tyxlJPD6Kc/LaH6oJDeyfbWKPvRXucj2kVFNg2jPaU=;
        b=7hCfqRqeDNyWVCjW4k3eeu0PLS5epdoRBsOMcpwttJ4aAVADc83qJHiJQFdNkGak8b
         Wz+ykxt11B5d1IX0CPiSPtVCusmgaZEfJhL03IwBDksDmOkUjmJbbBsDT6YEbLOyeYfH
         znb1V9cgZHqWlchgsOnTvpYh+PqzStDBHwQJcV2LBBb50oNv44B+aORgJxbifp6eIqOd
         SMdddGpglZ4dA9kb3CdbTVGP+FuPOctf7Gy9miDxEEMigilUMfm94iQBVG76xPWZcyIj
         cGCDIxv6G29shcdZOgOyd6FwJqk8MisgMFWOp9OcAHbwWTKB5DgWggNFlncq0GVFNj3s
         U2ow==
X-Gm-Message-State: AOAM532EBjsyYbo4R95l626Yxnop2+CzcyA2dfvxurA+AUJrODGwqI9w
        8etGfK+L9B5G//6g/XoHHjTIlQEXrPGKFA==
X-Google-Smtp-Source: ABdhPJyT/0HX+wCxgvAn5ZU4IwYyytpWvZg6tdZnj4cUxPxFp9yLECwz/GqKZ/VzhW+QjTEnSAzuYg==
X-Received: by 2002:a17:902:bb90:b0:158:a031:2ff2 with SMTP id m16-20020a170902bb9000b00158a0312ff2mr30199364pls.117.1652358363294;
        Thu, 12 May 2022 05:26:03 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t10-20020a17090b018a00b001cd4989fecbsm1712923pjs.23.2022.05.12.05.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 05:26:02 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ankit.kumar@samsung.com
Cc:     krish.reddy@samsung.com, fio@vger.kernel.org,
        simon.lund@samsung.com
In-Reply-To: <20220511163019.5608-1-ankit.kumar@samsung.com>
References: <CGME20220511163552epcas5p4c2e1b204a47a543c24f84da89ef0c89a@epcas5p4.samsung.com> <20220511163019.5608-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH v2 0/3] fio: add xnvme engine
Message-Id: <165235836201.232800.17311871788672732995.b4-ty@kernel.dk>
Date:   Thu, 12 May 2022 06:26:02 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, 11 May 2022 22:00:16 +0530, Ankit Kumar wrote:
> This patch introduces a new xnvme fio engine.
> 
> xNVMe provides an API for synchronous and asynchronous I/O.
> A library backs the API, libxnvme, which provides implementations for API users to
> run their I/O application on Linux, FreeBSD, macOS, and Windows without changing the application code.
> 
> Implementations of sync. interfaces include:
> * psync (preadv/pwritev)
> * Linux NVMe driver-ioctl
> * FreeBSD NVMe driver-ioctl
> 
> [...]

Applied, thanks!

[1/3] engines/xnvme: add xnvme engine
      commit: a3ff873ed4e7eed863927d749f39560068d40940
[2/3] docs: documentation for xnvme ioengine
      commit: 454154e66e93b3dc314955c197a21eeacbe69c78
[3/3] examples: add example job file for xnvme engine usage
      commit: d338e8760f3f442b3e4498598854130e55745eb9

Best regards,
-- 
Jens Axboe


