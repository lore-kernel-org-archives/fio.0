Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB317C636CD
	for <fio@archiver.kernel.org>; Fri, 10 Feb 2023 08:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjBJIQi (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Feb 2023 03:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjBJIQh (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Feb 2023 03:16:37 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92066B46F
        for <fio@vger.kernel.org>; Fri, 10 Feb 2023 00:16:35 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F09985C010E;
        Fri, 10 Feb 2023 03:16:34 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 10 Feb 2023 03:16:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=irrelevant.dk;
         h=cc:cc:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1676016994; x=1676103394; bh=nY
        NAuglR6aMTeioTesP0Eo0KEC8ihN/iCl5u4Sg3xXM=; b=DO/5HgRaC2suprX/PS
        vupmkl2KUKoWxzjtTHcvkMtalpN9rTDc1E2LuFaK4LzXFdtX0xyHlxZzKPCONhi8
        MtsgvExQ6miHHjtD53F2ToxcxjatE9YHEc2C/0y6wqDnSuStd18lU7GkOPiJ54O8
        jY/26FVM5NoQle48n3Og/UXzfDY2MsKMQgxROVlVaXowIq4uPUHPPYvlhJ3Z8ZoB
        gKc2AqUhQW3+7oZxJG0imGDG11RahmTOZLpyeLOsSbf7CHvRAPO2Gj1tKsw8Lcwa
        gizi/Qo/YFwQ9NveelN7jmk7oueB1BNh3f7Z4n0wgZ2IhOv/mN7f/gUr4ZoXyUmx
        TIqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676016994; x=1676103394; bh=nYNAuglR6aMTeioTesP0Eo0KEC8i
        hN/iCl5u4Sg3xXM=; b=l4TGZFqJyT+vyjih0eAxIVRj48c+j5A7x/A4MbyPHCD7
        3d6Y9gi4088BIKklppaWIdk14vpsSM3tIV7Ubp2XsBARCr+0EhBgEcU37PE5XsHe
        RGJjCI9Fg8DF1pOM9RunGFPfQ0dQsV/qTzvulsbNaMvFIltJtUjYdeBje09vAVU/
        HKjPUOyHM5ImmkDICmOokcCTVRlqg5A9BlyQYMi4EZhE0ANWR5UrzFWjKzHThaE/
        Dv4+Zwkso9uIZxtz/6FbG6OU5NTgQ8x4F7JfuacaiyTT5f9SqmW1PNST21C88VnS
        sOfPpRBEmT/WNmTFRvIgCyWg4P/OG1dX2Iwja8kZSQ==
X-ME-Sender: <xms:Yf3lY0XRdQM-UexdjT_Xl4KAwxE6zQjR4UcPvTv2ouSkmumfpiI-1g>
    <xme:Yf3lY4k0wFz9U3wm98n5MLwcPAjo9hKSJfcCmft706stl9h7L0P0iOaAejpTFSsKb
    Ovh8wR1hbAmae9RiLU>
X-ME-Received: <xmr:Yf3lY4bMtWDhSxJd7_nmCJxHUf3Jg5OdXrXkHubWe9pgQiR-p7VKfaeYfIGK1kDutYU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehgedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpefmlhgr
    uhhsucflvghnshgvnhcuoehithhssehirhhrvghlvghvrghnthdrughkqeenucggtffrrg
    htthgvrhhnpeejgfejfeffvdeuhfeifefhgffgueelhedukeevjeevtdduudegieegteff
    ffejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hithhssehirhhrvghlvghvrghnthdrughk
X-ME-Proxy: <xmx:Yf3lYzXlk4ebdlH3Ctx6tUBRxaXD7qKzYkNLhDOXeZuOKdVG7ItvGw>
    <xmx:Yf3lY-n5BRnC3kbtYGtTeHFfEMunY8f4HaQmYFXvGZzoBTDmIzjV-A>
    <xmx:Yf3lY4daxfcdYgkOuopKIiqtedl21wK1yVcz70u6BJgX1H3u79XNgw>
    <xmx:Yv3lY8YRPiskkZsXBpnJXbV4QsZn7kOJ4OW5Yp_d4UZ-3I1-a4bDng>
Feedback-ID: idc91472f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Feb 2023 03:16:32 -0500 (EST)
Date:   Fri, 10 Feb 2023 09:16:29 +0100
From:   Klaus Jensen <its@irrelevant.dk>
To:     Keith Busch <kbusch@meta.com>
Cc:     fio@vger.kernel.org, axboe@kernel.dk,
        damien.lemoal@opensource.wdc.com, vincentfu@gmail.com,
        Keith Busch <kbusch@kernel.org>,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: Re: [PATCHv2] fio: add fdp support for io_uring_cmd nvme engine
Message-ID: <Y+X9XZjsdwz9GpLM@cormorant.local>
References: <20230209171236.1113887-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MJ56EODp08zdY1FH"
Content-Disposition: inline
In-Reply-To: <20230209171236.1113887-1-kbusch@meta.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


--MJ56EODp08zdY1FH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb  9 09:12, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
>=20
> Add support for NVMe TP4146 Flexible Data Placemen, allowing placement
> identifiers in write commands. The user can enabled this with the new
> "fdp=3D1" parameter for fio's io_uring_cmd ioengine. By default, the fio
> jobs will cycle through all the namespace's available placement
> identifiers for write commands.

Technically, the namespace has Placement *Handles* associated and when
writing, a Placement *Identifier* is used to also specify the Reclaim
Group.

> The user can limit which placement
> identifiers can be used with additional parameter, "fdp_plis=3D<list,>",
> which can be used to separate write intensive jobs from less intensive
> ones.

With the above in mind, it might make sense to align with the spec and
call this "fdp_pids" instead. As far as I can tell, fio won't cycle
through reclaim groups and create the pid on its own, without fdp_plis
explicitly indicating it?

--MJ56EODp08zdY1FH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEUigzqnXi3OaiR2bATeGvMW1PDekFAmPl/VwACgkQTeGvMW1P
Dek0EQf9HDNbbCbIjBe9Llg6h6CGMX0aM7QqTxpmQweeIXcJz7Wr9L8b17MtEH/e
L43vQ0Oa+I62QIpIgJsgUl9q/6+Nw0ANJBLXHfF0CGkmLkYC90Vn/bXuCEwZWjQE
h733JgCIzSOuYjQyGW1qzf6TPXxjh9RyFDbAOH8B+93h5ecaXInVCcliYqJWEedG
c0P+nWTdjsHfKJl80cY+2p4CtODVEyLwzpOOvO8xVyNTfdE3TuCMZ+Z1KjoaemLf
0iPhxESTd1SwqIXdkc85/AwhYJSdsoLzj2CPX4TG7EleTTnCxkG/F73j8LpAc4gr
0cedZxN61nDAvBuSUtHAZ6p2ZDIS9g==
=QDmk
-----END PGP SIGNATURE-----

--MJ56EODp08zdY1FH--
