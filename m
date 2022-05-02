Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E80FC433EF
	for <fio@archiver.kernel.org>; Mon,  2 May 2022 12:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbiEBMsV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 2 May 2022 08:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346302AbiEBMsU (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 May 2022 08:48:20 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32C713E9E
        for <fio@vger.kernel.org>; Mon,  2 May 2022 05:44:50 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id e19so1750178vsu.12
        for <fio@vger.kernel.org>; Mon, 02 May 2022 05:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=krGrL2B2K4KzskD5lUf+IZ+eyUmJlqC0g44d6U5hdok=;
        b=SAhP1xPvNTuy2mOhDiwQqR+7uK+xIcgHsxDEAFHB+qz4EtPerR9jQJaYFdu4CvlpyY
         EZJohJboPWCu0oQ+1NplAijQ/dRYM4TFtVBQ6KNKylyZheg4j8ZFtB50DKrEhnOHDugq
         A/58yE9YXBpv8bTecumyOeQ0Om6ccOErA8UH6I5gZHw4/xlauVwvOS854xbQiJ0KjtLa
         885Xy8AZ1S4pbqPfEww89ugzdJVGwNYnC1wLXlRk1g9PS6g2T9hTE9gTFeAA5u3EwrAu
         kxHLzc+f+bkNqIdpxNuI6ZUkEgFg0j/z5C9tcEG7J9nALfgxVpmkb1p/1oGKj2owBxsh
         HK5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=krGrL2B2K4KzskD5lUf+IZ+eyUmJlqC0g44d6U5hdok=;
        b=zXo1dSS7kXq2zUw/eoz+XjEQpXxeGCymboU/AjS0uA8A3PE0dU/mQgRNYDBuz/ikOs
         937YNiHVfR2g862OLkoVOQVRAGyeI9o/DpRYLVbwPj18rARexzq7CxSZVFhT9RiNeDUz
         vFOt7UgeMIRUrdgtgarS5LS9QyfiMdCLKcRsWyxx5DJ8mgflG+FzRFB+CbZgJoWnHM8X
         z5XHgYKoyjqTWkjOsrNhaZuLAcreC+t3PHQZePgCglwq+/EPysjzQt6y6FkgKuzF9Tkj
         V9xZ64w9nB2QfMRN9dX9M78v7tGyeOOqB6E8Cu9ANO06Ylq/6xuQ7uhqW0ZTVCgM64CC
         doZw==
X-Gm-Message-State: AOAM532BNMHwG4iofqRKxrz+E9/caW+s1UCNXuiI8NNH809ZXHaoULCU
        KDsYG5FppHDijOOnaL/2WocZPP032skEdbcM8BauJpgahJM=
X-Google-Smtp-Source: ABdhPJzVPfmtTGHyf9NS/t6+PR9IfIeAJ3x0OUvw/w1GjaKm2eflOQ1mUIrlCKK0YNaXFDLIndcJ5rpI6eoCoFk9Ne8=
X-Received: by 2002:a67:d61a:0:b0:32d:4c95:36d5 with SMTP id
 n26-20020a67d61a000000b0032d4c9536d5mr218902vsj.36.1651495489341; Mon, 02 May
 2022 05:44:49 -0700 (PDT)
MIME-Version: 1.0
From:   Sagi <sagiahrak@gmail.com>
Date:   Mon, 2 May 2022 15:44:38 +0300
Message-ID: <CAH0a3kZD0L8otacwyOY=Ek0phxVfYcB+ZPEq0pfhVS5oaZ+Wgw@mail.gmail.com>
Subject: http engine dependencies?
To:     fio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hey!

My name is Sage and I=E2=80=99m trying to use fio with http IO engine (s3).

 On fio configuration stage, the http-engine isn=E2=80=99t being installed.

I was looking in the configure code
(https://github.com/axboe/fio/blob/1588c8f571f67a004571e51cdbb5de97c3e4f457=
/configure#L1818-L1826),
and tried =E2=80=9Capt-getting=E2=80=9D libcurl4 or similar packages I thou=
ght would
be relevant, but I couldn=E2=80=99t make the http-engine work.

I'm using Ubuntu OS, would appreciate any hint or help :)
