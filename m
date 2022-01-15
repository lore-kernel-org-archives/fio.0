Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA56C433EF
	for <fio@archiver.kernel.org>; Sat, 15 Jan 2022 16:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbiAOQSX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sat, 15 Jan 2022 11:18:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiAOQSX (ORCPT <rfc822;fio@vger.kernel.org>);
        Sat, 15 Jan 2022 11:18:23 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0192BC061574
        for <fio@vger.kernel.org>; Sat, 15 Jan 2022 08:18:22 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 25-20020a05600c231900b003497473a9c4so13697658wmo.5
        for <fio@vger.kernel.org>; Sat, 15 Jan 2022 08:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZzthMdo6QlVYt+qS/WH1rMl6h0OzkOxtRfiM13scLCk=;
        b=jxTU3lodZq6q8371hryhb+5SSwgzA+8ILZA2FE43Q5NZr+pbYI75fICvcDbZtndgWv
         JEdoopDhYBoZ5pl+9tJ3PRSti53c2LnVGCF33cgux2hiCRAXB6KB9SQMeMfNMNm9AtKx
         1DaBPA7MQeFZp3c9C0UyWE80OY9ZeKO52t3sCv66QaHzAc2M5pC888rfbeWJ4G8J8JaC
         QxugIxix8zEWW1Xh0asOjNTWdcMBCMaGgH1oEoWHFX+cKjrR0jcFeFMUrGQpC74LUpbA
         0llBhfFTB6rgaCYlZDczq0Pk7c7L97nZ9LoWe/tAzc5Hb1YjWATay3nM7jR1PidNDRQu
         ODOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZzthMdo6QlVYt+qS/WH1rMl6h0OzkOxtRfiM13scLCk=;
        b=hkcyOjt8fulbHE43EpzxCepeyCXKPQLXb77ZDruaOlJpebdW35OjvI//EoaE4bcZHb
         159JHtqW9cnW5i0N8d4ciLt8pj+5MAfMtzGB6m+wIrX8A5d1dkuXBYynkcJQmnnrYdmz
         oKxRfNpgTjxLDiAC+pywXdd83e1Wh3lI06okBGlk0ty6TMt3OsbPGjWMgOL1c61X2hep
         lW69RVWK4xSMM908fgqTX2wkFHDebwwWF+vFS4rAtL8vQocKmxtSjVw7+TYVGQxiCwrA
         ni79+PARbhZDUT8TjzJayG/gLhzn1u2qEpt4BGp1VbTgcVyfqklgGy5Sk4Q2l31oI/6X
         DVDw==
X-Gm-Message-State: AOAM5331j8bNB+BslyE5U9q8G/qIRFWYDe78sEKVKo/9SuWaPRXtbpT2
        ci4UBnrWsJekeCy3lxr2/icymYHtxRfdzZIBTGI0qbMYZdc=
X-Google-Smtp-Source: ABdhPJyFP8k1AMBbcyFSjR2hgZjDhw0Wf+uPNpTG4Dts7kmQ5cLiTB+hC+HdJSrkPZQ0UzDiuZUYPcPmCgCR+YLWaqI=
X-Received: by 2002:adf:9148:: with SMTP id j66mr2591193wrj.434.1642263501410;
 Sat, 15 Jan 2022 08:18:21 -0800 (PST)
MIME-Version: 1.0
References: <BYAPR04MB5656A96F86BDED72F1823510EA4C9@BYAPR04MB5656.namprd04.prod.outlook.com>
In-Reply-To: <BYAPR04MB5656A96F86BDED72F1823510EA4C9@BYAPR04MB5656.namprd04.prod.outlook.com>
From:   Sitsofe Wheeler <sitsofe@gmail.com>
Date:   Sat, 15 Jan 2022 16:17:55 +0000
Message-ID: <CALjAwxgoACbNz0UUW=iypX=mvCr7QZCU6JbLpUOqiW7-ptw_2w@mail.gmail.com>
Subject: Re: FIO Dependency on LBA format in Linux
To:     Jeffrey Lien <Jeff.Lien@wdc.com>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Brandon Paupore <Brandon.Paupore@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, 7 Jan 2022 at 19:01, Jeffrey Lien <Jeff.Lien@wdc.com> wrote:
>
> I am trying to determine if FIO in Linux is dependent on the drive lba fo=
rmat (sector size + Protection Information size).  I have not found any ref=
erences to this in the FIO code but not totally sure where to look either. =
 My thoughts on this is that the device driver for the particular drive (nv=
me driver in my particular case) or the block layer would handle this and i=
solate FIO from any dependencies but would like to confirm it.  If anyone c=
ould either confirm this or explain any FIO dependencies, that would be gre=
atly appreciated.   Thanks

Apart from specialist ioengines (e.g. the sg ioengine) fio submits I/O
through the block layer and as such is beholden to it. For example
when you do direct=3D1 I/O you have to follow the restrictions
(positional alignment and size alignment) that the block layer imposes
on O_DIRECT I/O (search for O_DIRECT in
https://man7.org/linux/man-pages/man2/open.2.html ). The block layer
in the kernel itself may be unhappy for I/O to be submitted to a
device with a non-power of two block size... sometimes there's a
warning in dmesg about this when the kernel starts.

--=20
Sitsofe
