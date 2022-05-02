Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D888C433F5
	for <fio@archiver.kernel.org>; Mon,  2 May 2022 13:34:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiEBNhq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 2 May 2022 09:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiEBNhp (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 2 May 2022 09:37:45 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88054A1B0
        for <fio@vger.kernel.org>; Mon,  2 May 2022 06:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651498456; x=1683034456;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=PfUwjyCySBbltawdblsSvjgYT/tSl2QHdN/rGuX1nbY=;
  b=T5if3lVc2Vztbwc3RMHBjteMS1/o1W13TD57pw1MQ5RBU/PYo7MSTqPe
   3E4+YjuSqgTUhL9fvx4RJm/vcAOTBf+tfo6Td9hOmbjkl8MCa55KBKH/J
   GKclG1iTJYZMYWx9zi6drkYBo2XV5H6cnhyJMRqWn50C/kfXDQ7+RSMXF
   vVkTNMWQrEyuv0OVz6jpaKaITGBnFNI7TfJCvfcb2V2MhL2BzaalFBFty
   n/OHgmiNzFnHssFVm7vN8wFRcvjulTzeYJyzEi5NE/aQqaLeQsmChzvYn
   2LlP/21x/weNUEXsp8fc7QSV32edHaPDhrca+pDAOLJhuYMIRzj+gem05
   g==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647273600"; 
   d="scan'208";a="303550298"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 21:34:15 +0800
IronPort-SDR: 6jpNija+bQ6rmPUaWCGD9SDfXMVwrN+rHBoTqOeeI7iKPON4tWH5Gjo6stuFo7Qurw3Dh4rLSo
 IJ0imiKZ9Cs3gJV+jDDqF2A+iMyGkcFzcoP5erLrvpKxkEfIvUX845utwG3uZV7AAs13HbU+R1
 cvXYuJjtgCKn+pSAE9dTHpig+KoVj+i8U30p6CA0BW/oO3uegwSvbF08OqNli+v3AqiH2gHv7A
 MqewL574n+ZKDjX8titHmu4+NC1kFxADVhbBl+rQwyitB7AmXRFmlbWcmm2F40KTBU9mKEt7Mm
 1yYDdHrFhWE48PgjwlM64JTP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 06:05:00 -0700
IronPort-SDR: qxUuHyjAgDgy+9OSNwTHSTQ/+REHYB1n5Z4J++OG6KhZlJ3TRL9qrQUTVUWtt+Yc4fFew8Y5BQ
 9+pYfnJk+JBKS9TqczkXWsfqIee1dOjtEIRcFpCI1uqc8sJnCoR4mhZjFYPIHhsNRgobNH6sYq
 yauLRb/zMHzNO/GDzGscL4SnAprXcRvN7FOlw5IaiGy3cIYpmiRUnl4Zu1cIm6DdQ8nrqfEPlD
 CYdAUF6QKcsa3cc8hJRlJnZQRfg094v2Za7KLpcrdx3P+4xr712GygAizcrVsXNk/7t9HZTz7P
 SbQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 06:34:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsPFg2ykLz1Rvlx
        for <fio@vger.kernel.org>; Mon,  2 May 2022 06:34:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651498454; x=1654090455; bh=PfUwjyCySBbltawdblsSvjgYT/tSl2QHdN/
        rGuX1nbY=; b=jSOT+Xq0HCf/P/zYwzKBBPNtVaMThGg5KtI97xL6/Y+23XzV8eH
        LRmF4HUiQJY1pmgkHUdPZ2Hy4axgtWeXzNLeaLtEm/wye/BYjV1fMs2TEGl3wmVt
        HlZYfitLcBLi0LfbyXijK3yer2pi7FTl8cqVHnqp8YosuXmgMqFQwTBw/yRCro6D
        xtfribQ2og109K9WzrUwFWeg3tcEWyM6ovNNkRmtfclpcULpLTiYUC6HeCUtsPTO
        WALkEoW6PaZU4onDrWw8y7ZmCFta8pxkS0Xg0m+XmJUo2Z4zNer/ZQhML4Gr4SjK
        7fnjmOc/pgYZVrfk1Iu/3aGig8d1yTtn+bQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cuWRlhvY7EMk for <fio@vger.kernel.org>;
        Mon,  2 May 2022 06:34:14 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsPFf5q9Qz1Rvlc;
        Mon,  2 May 2022 06:34:14 -0700 (PDT)
Message-ID: <6e6da881-6c3c-965f-e2cf-caa5a0b5c16a@opensource.wdc.com>
Date:   Mon, 2 May 2022 22:34:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: http engine dependencies?
Content-Language: en-US
To:     Sagi <sagiahrak@gmail.com>, fio@vger.kernel.org
References: <CAH0a3kZD0L8otacwyOY=Ek0phxVfYcB+ZPEq0pfhVS5oaZ+Wgw@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAH0a3kZD0L8otacwyOY=Ek0phxVfYcB+ZPEq0pfhVS5oaZ+Wgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2022/05/02 21:44, Sagi wrote:
> Hey!
>=20
> My name is Sage and I=E2=80=99m trying to use fio with http IO engine (=
s3).
>=20
>  On fio configuration stage, the http-engine isn=E2=80=99t being instal=
led.
>=20
> I was looking in the configure code
> (https://github.com/axboe/fio/blob/1588c8f571f67a004571e51cdbb5de97c3e4=
f457/configure#L1818-L1826),
> and tried =E2=80=9Capt-getting=E2=80=9D libcurl4 or similar packages I =
thought would
> be relevant, but I couldn=E2=80=99t make the http-engine work.

You need to install the development packages for the libraries too (e.g.
libcurl4-devel or whatever it is called on your distro) so that the libra=
ry C
header files are also installed. Without these, the engines will not be c=
ompiled.

>=20
> I'm using Ubuntu OS, would appreciate any hint or help :)


--=20
Damien Le Moal
Western Digital Research
